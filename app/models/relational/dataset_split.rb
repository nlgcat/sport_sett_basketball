class DatasetSplit < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :rotowire_entries

  def self.get_lookup
    DatasetSplit.map{|s| [s.name, s] }.to_h
  end
  
  def games
    rotowire_entries.map(&:games).flatten
  end
end
