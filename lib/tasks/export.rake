namespace :export do

  # Splits strings by entity for easier reading by humans
  task :split, [:str] => [:environment] do |task, args|
    pp args[:str].split(' ').map{|s| s.split('￨')[1] }.uniq
  end
  
  task :bref_url, [:id] => [:environment] do |task, args|
    puts Game[args[:id]].basketball_reference_url
  end

  task :test_accuracy_data, [:id] => [:environment] do |task, args|
    Game.each do |game|
      tigs = game.teams_in_game
      team_codes = game.team_codes
      home_code = TeamName.rotowire_to_bref_code(team_codes[:home])
      visiting_code = TeamName.rotowire_to_bref_code(team_codes[:visiting])
      start_year = game.season.start_year
      d = game.rw_date_str()
      arr = [
        "#{d}",
        "#{tigs[:home].team_name}",
        "#{tigs[:visiting].team_name}",
        "#{game.basketball_reference_url}",
        "#{home_code}",
        "#{visiting_code}",
        "https://www.basketball-reference.com/teams/#{home_code}/#{start_year+1}_games.html",
        "https://www.basketball-reference.com/teams/#{visiting_code}/#{start_year+1}_games.html",
      ]
      print(arr.join(','), "\n")
    end
  end

  def write_data_file partition, arr, h_key, prefix='_D0', folder='exported_files', extension='txt'
    File.open(Rails.root.join(folder, "#{prefix}#{partition}_#{h_key}.#{extension}"), "w") do |file|
      file.write arr.map{|h| "#{h[h_key]}\n" }.join
    end
  end

  # Output files in the ONMT format used by Clement Rebuffel, using original Rotowire partitions
  task :rebuffel, [:mode, :limit] => [:environment] do |task, args|
    args.with_defaults(mode: 'EXTENDED')
    args.with_defaults(limit: 'ALL')

    split_names = []
    %w(contam decontam).each do |c|
      DatasetSplit.each do |d|
        split_names << "#{c}_#{d.name}"
      end
    end

    split_h = split_names.map{|split_name| [split_name, []] }.to_h

    (2014..2018).each do |y|
      split_h[y] = []
    end

    # Sort the games:
    # - by those with one summary first as they have to go in that partition
    # - then valid/test pairs, so they can be evenly distributed
    # - then by pairs including train, so even distribution can be finished, then all else dumped in train
    games = args[:limit] == 'ALL' ? Game.all : Game.first(args[:limit].to_i)
    games.sort_by!{|game| game.rotowire_entries.size + (game.rotowire_entries.map{|rwe| rwe.dataset_split.name }.include?('train') ? 2 : 1) }

    games.each_with_index do |game, i|
      contam_split = nil
      decontam_split = nil
     
      rwes = game.rotowire_entries

      if rwes.size == 0
        text = 'No summary was available.'
        puts "#{game.id}: #{text}" 
        next
      elsif rwes.size > 0
        rwe_sizes = rwes.map{|rwe| ["decontam_#{rwe.dataset_split.name}", split_h["decontam_#{rwe.dataset_split.name}"].size] }.to_h
        rwe_sizes.sort_by{ |_, v| v }
        pp rwe_sizes
        rwe_sizes.each do |k,v|
          # Warning:  The magic number 1075 in here will not hold if a different input corpus is used with more games etc
          if ['decontam_test', 'decontam_valid'].include?(k) && split_h[k].size < 1075
            decontam_split = k
            break
          else
            decontam_split = 'decontam_train'
          end
        end
      end

      record_class = args[:mode] == 'EXTENDED' ? SettOpenNMTRecord : RebuffelOpenNMTRecord

      rwes.each do |rwe|
        contam_split = "contam_#{rwe.dataset_split.name}"
        text = rwe.summary
        rebuffel = record_class.new(game)
        # rebuffel = SettOpenNMTRecord.new(game)
        # rebuffel = RebuffelOpenNMTRecord.new(game)
        rebuffel.values.each do |v|
          text.gsub!(v.gsub('_',' '),v) if v =~ /_/
        end

        # Names like K.J. are not properly tokenized in output texts
        if text =~ /[A-Z]\.[A-Z]\s\./
          text.scan(/[A-Z]\.[A-Z]\s?\.\s?/).each do |s|
            x = s.gsub(/\s/,'') + ' '
            text.gsub!(s, x)
          end
        end

        # Create the original RW partitions, the decontaminated partitions, and the yearly ones.
        # See paper for the difference
        split_h[game.season.start_year] << {data: rebuffel, text: "#{text}"}
        split_h[contam_split]           << {data: rebuffel, text: "#{text}"}
        split_h[decontam_split]         << {data: rebuffel, text: "#{text}"}

        puts "#{i}/#{Game.count}" if i % 20 == 0
      end
    end

    dataset_prefix = args[:mode] == 'EXTENDED' ? 'D2' : 'D1'

    split_h.each do |partition, arr|
      [:data, :text].each do |h_key|
        write_data_file(partition, arr, h_key, "#{dataset_prefix}_", 'exported_files', 'txt')
      end
    end
  end
end