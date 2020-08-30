months = %w(October November December January February March April May June July August September)
month_names = {}
months.each do |n|
  month_names[n] = MonthName.create(
    name: n,
    calander_month_int: Date::MONTHNAMES.index(n).to_i,
    year_offset: %(October November December).include?(n) ? 0 : 1
  )
end

dataset_split_names = %w(test train valid other)
dataset_splits = {}
dataset_split_names.each do |n|
  dataset_splits[n] = DatasetSplit.create(name: n)
end

# --
# Static Sport and League Structure
basketball = Sport.create(name: 'Basketball')

nba = League.create(name: 'National Basketball Association', abreviation: 'NBA', determiner: true, sport_id: basketball.id)

nba_conferences = {
  eastern: Conference.create(name: 'Eastern Conference', league_id: nba.id),
  western: Conference.create(name: 'Western Conference', league_id: nba.id)
}

nba_division_conferences = {
  southeast:  :eastern,
  central:    :eastern,
  atlantic:   :eastern,
  southwest:  :western,
  northwest:  :western,
  pacific:    :western
}

nba_divisions = {
  southeast:  Division.create(name: 'Southeast',  league_id: nba.id),
  central:    Division.create(name: 'Central',    league_id: nba.id),
  atlantic:   Division.create(name: 'Atlantic',   league_id: nba.id),
  southwest:  Division.create(name: 'Southwest',  league_id: nba.id),
  northwest:  Division.create(name: 'Northwest',  league_id: nba.id),
  pacific:    Division.create(name: 'Pacific',    league_id: nba.id)
}

nba_current_league_structure = LeagueStructure.create(league_id: nba.id)

nba_current_division_structures = {}
nba_divisions.each do |k, division|
  nba_current_division_structures[k] = DivisionStructure.create(
    league_structure_id:  nba_current_league_structure.id,
    division_id:          division.id,
    conference_id:        nba_conferences[nba_division_conferences[k]].id
  )
end

playoff_round_type_data = [
  'First Round',
  'Conference Semifinals',
  'Conference Finals',
  'NBA Finals',
]

playoff_round_types = {}
playoff_round_type_data.each do |n|
  r = PlayoffRoundType.create(name: n)
  playoff_round_types[r.id] = r
end

# There are some other minor issues in the 2013-14 season, as well as Covid-19 and the death of Kobe Bryant in 2019-20
playoff_dates = {
  # 2013 => {season_start: Date.new(2013,10,29), season_end: Date.new(2014,4,16), playoff_start: Date.new(2014,4,19), playoff_end: Date.new(2014,6,15)},
  2014 => {season_start: Date.new(2014,10,28), season_end: Date.new(2015,4,15), playoff_start: Date.new(2015,4,18), playoff_end: Date.new(2015,6,16)},
  2015 => {season_start: Date.new(2015,10,27), season_end: Date.new(2016,4,16), playoff_start: Date.new(2016,4,16), playoff_end: Date.new(2016,6,19)},
  2016 => {season_start: Date.new(2016,10,25), season_end: Date.new(2017,4,12), playoff_start: Date.new(2017,4,15), playoff_end: Date.new(2017,6,12)},
  2017 => {season_start: Date.new(2017,10,17), season_end: Date.new(2018,4,11), playoff_start: Date.new(2018,4,14), playoff_end: Date.new(2018,6, 8)},
  2018 => {season_start: Date.new(2018,10,16), season_end: Date.new(2019,4,10), playoff_start: Date.new(2019,4,13), playoff_end: Date.new(2019,6,13)},
  # 2019 => {season_start: Date.new(2019,10,22), season_end: Date.new(2020,4,15), playoff_start: Date.new(2020,4,18), playoff_end: Date.new(2020,6,30)},
}

nba_seasons = {}
nba_playoffs = {}
playoff_dates.each do |i, dates|
  nba_seasons[i] = Season.create(
    start_year: i,
    end_year: i+1,
    league_structure_id: nba_current_league_structure.id,
    season_start: dates[:season_start],
    season_end: dates[:season_end],
    
  )
  nba_playoffs[i] = Playoff.create(
    season_id:      nba_seasons[i].id,
    playoff_start:  dates[:playoff_start],
    playoff_end:    dates[:playoff_end],
  )
end

statistic_types = {
  TO:   StatisticType.create(name: 'Turnover',                  code: 'TOV',  points_per: 0),
  PF:   StatisticType.create(name: 'Personal Foul',             code: 'PF',   points_per: 0),
  DF:   StatisticType.create(name: 'Drawn Foul',                code: 'DF',   points_per: 0),
  VIO:  StatisticType.create(name: 'Violation',                 code: 'VIO',  points_per: 0),
  OREB: StatisticType.create(name: 'Offensive Rebound',         code: 'OREB', points_per: 0),
  DREB: StatisticType.create(name: 'Defensive Rebound',         code: 'DREB', points_per: 0),
  BLK:  StatisticType.create(name: 'Block',                     code: 'BLK',  points_per: 0),
  STL:  StatisticType.create(name: 'Steal',                     code: 'STL',  points_per: 0),
  AST:  StatisticType.create(name: 'Assist',                    code: 'AST',  points_per: 0),
  FTA:  StatisticType.create(name: 'Free Throw Attempt',        code: 'FTA',  points_per: 0),
  FGA:  StatisticType.create(name: 'Field Goal Attempt',        code: 'FGA',  points_per: 0),
  FG3A: StatisticType.create(name: 'Field Goal Three Attempt',  code: 'FG3A', points_per: 0),
  # FG3s come out of the FG totals, therefore they are worth 1 additonal point (on top of the FG2)
  FTM:  StatisticType.create(name: 'Free Throw Made',           code: 'FTM',  points_per: 1),
  FGM:  StatisticType.create(name: 'Field Goal Made',           code: 'FGM',  points_per: 2),
  FG3M: StatisticType.create(name: 'Field Goal Three Made',     code: 'FG3M', points_per: 1),
  SEC:  StatisticType.create(name: 'Seconds Played',            code: 'SEC',  points_per: 0),
  P_M:  StatisticType.create(name: 'Plus-Minus',                code: '+/-',  points_per: 0),
  # PTS:  StatisticType.create(name: 'Points',                    code: 'PTS',  points_per: 0),
}

# --
# Places and Stadia
place_data = {
  state_names: {
    place_type_name: 'State',
    place_names: {
      texas:  {name: 'Texas'},
      colorado: {name: 'Colorado'},
      california: {name: 'California'},
      tennessee: {name: 'Tennessee'},
      minnesota: {name: 'Minnesota'},
      louisiana: {name: 'Louisiana'},
      new_orleans: {name: 'New Orleans'},
      oklahoma: {name: 'Oklahoma'},
      arizona: {name: 'Arizona'},
      oregon: {name: 'Oregon'},
      utah: {name: 'Utah'},
      georgia: {name: 'Georgia'},
      atlanta: {name: 'Atlanta'},
      massachusetts: {name: 'Massachusetts'},
      new_york: {name: 'New York'},
      new_jersey: {name: 'New Jersey'},
      brooklyn: {name: 'Brooklyn'},
      north_carolina: {name: 'North Carolina'},
      illinois: {name: 'Illinois'},
      chicago: {name: 'Chicago'},
      ohio: {name: 'Ohio'},
      cleveland: {name: 'Cleveland'},
      michigan: {name: 'Michigan'},
      indiana: {name: 'Indiana'},
      indianapolis: {name: 'Indianapolis'},
      florida: {name: 'Florida'},
      wisconsin: {name: 'Wisconsin'},
      pennsylvania: {name: 'Pennsylvania'},
      ontario: {name: 'Ontario'},
      england: {name: 'England'},
      france: {name: 'France'},
      mexico: {name: 'Mexico'},
    }
  },
  region_names: {
    place_type_name: 'Region',
    place_names: {
      golden_state: {name: 'Golden State', in: :california}
    }
  },
  city_names: {
    place_type_name: 'City',
    place_names: {
      dallas: {name: 'Dallas', in: :texas},
      houston: {name: 'Houston', in: :texas},
      denver: {name: 'Denver', in: :colorado},
      san_francisco: {name: 'San Francisco', in: :california},
      los_angeles: {name: 'Los Angeles', in: :california, abreviation: 'LA'},
      memphis: {name: 'Memphis', in: :tennessee},
      minneapolis: {name: 'Minneapolis', in: :minnesota},
      oklahoma_city: {name: 'Oklahoma City', in: :oklahoma},
      phoenix: {name: 'Phoenix', in: :arizona},
      portland: {name: 'Portland', in: :oregon},
      sacramento: {name: 'Sacramento', in: :california},
      san_antonio: {name: 'San Antonio', in: :california},
      salt_lake_city: {name: 'Salt Lake City', in: :utah},
      boston: {name: 'Boston', in: :massachusetts},
      north_carolina: {name: 'North Carolina'},
      charlotte: {name: 'Charlotte', in: :north_carolina},
      illinois: {name: 'Illinois'},
      chicago: {name: 'Chicago', in: :illinois},
      cleveland: {name: 'Cleveland', in: :ohio},
      detroit: {name: 'Detroit', in: :michigan},
      indianapolis: {name: 'Indianapolis'},
      miami: {name: 'Miami', in: :florida},
      milwaukee: {name: 'Milwaukee', in: :wisconsin},
      manhattan: {name: 'Manhattan', in: :new_york},
      orlando: {name: 'Orlando', in: :florida},
      philadelphia: {name: 'Philadelphia', in: :pennsylvania},
      toronto: {name: 'Toronto', in: :ontario},
      washington: {name: 'Washington', in: :d_c},
      london: {name: 'London', in: :england},
      auburn_hills: {name: 'Auburn Hills', in: :michigan},
      bossier_city: {name: 'Bossier City', in: :louisiana},
      paris: {name: 'Paris', in: :france},
      oakland: {name: 'Oakland', in: :california},
      mexico_city: {name: 'Mexico City', in: :mexico},
    }
  }
}

place_data_file = Rails.root.join('db', 'seed_files', 'place_data.yml')
File.open(place_data_file, "w") { |file| file.write(place_data.to_yaml) }
place_data = YAML.load(File.read(place_data_file))

place_types = {}
places = {}
place_data.each do |k, type_data|
  place_type = PlaceType.create(name: type_data[:place_type_name])
  place_types[type_data[:place_type_name].to_sym] = place_type
  type_data[:place_names].each do |place_k, data|
    places[place_k] = Place.create(name: data[:name], place_type_id: place_type.id)
    places[place_k].parent = places[data[:in]] if data[:in]
  end
end



previous_stadium_data = {
  WIS: {name: "BMO Harris Bradley Center", place: :milwaukee, capacity: 18717, opened: 1988, alias: 'Bradley Center'},
  CLE: {name: 'Quicken Loans Arena', place: :cleveland, capacity: 19432, opened: 1994, alias_of: 'Rocket Mortgage FieldHouse'},
  ATL: {name: 'Philips Arena', place: :atlanta, capacity: 18118, opened: 1999, alias_of: 'State Farm Arena'},
  O2:  {name: 'The O2 Arena', place: :london, capacity: 20000, opened: 2007},
  UTA: {name: 'EnergySolutions Arena', place: :salt_lake_city, capacity: 18306, opened: 1991, alias_of: 'Vivint Smart Home Arena'},
  SAC: {name: 'Sleep Train Arena', place: :sacramento, capacity: 17317, opened: 1988},
  NOP: {name: 'New Orleans Arena', place: :new_orleans, capacity: 16867, opened: 1999, alias_of: 'Smoothie King Center'},
  DET: {name: 'Palace of Auburn Hills', place: :detroit, capacity: 22076, opened: 1986},
  TOR: {name: "Air Canada Centre", place: :toronto, capacity: 19800, opened: 1999, alias_of: 'Scotiabank Arena'},
  PHX: {name: "US Airways Center", place: :phoenix, capacity: 18055, opened: 1992, alias_of: 'Talking Stick Resort Arena'},
  GSW: {name: "Oracle Arena", place: :oakland, capacity: 19596, opened: 1966},
  WAS: {name: 'Verizon Center', place: :washington, capacity: 20356, opened: 1997, alias_of: 'Capital One Arena'},
  CHA: {name: "Time Warner Cable Arena", place: :charlotte, capacity: 19077, opened: 2005, alias_of: 'Spectrum Center'},
  MEX: {name: "Mexico City Arena", place: :mexico_city, capacity: 22300, opened: 2012},
  CLC: {name: "CenturyLink Center", place: :bossier_city, capacity: 12440, opened: 2000},
  UWP: {name: "UW–Milwaukee Panther Arena", place: :milwaukee, capacity: 10783, opened: 1974},
  PAR: {name: "AccorHotels Arena", place: :france, capacity: 15609, opened: 1984},
}

stadium_data = {
  PHI: {name: 'Wells Fargo Center', place: :philadelphia, capacity: 20478, opened: 1996},
  MIL: {name: 'Fiserv Forum', place: :milwaukee, capacity: 17500, opened: 2018},
  CHI: {name: 'United Center', place: :chicago, capacity: 20917, opened: 1994},
  CLE: {name: 'Rocket Mortgage FieldHouse', place: :cleveland, capacity: 19432, opened: 1994},
  BOS: {name: 'TD Garden', place: :boston, capacity: 18624, opened: 1995},
  LAC: {name: 'Staples Center', place: :los_angeles, capacity: 19068, opened: 1999},
  MEM: {name: 'FedExForum', place: :memphis, capacity: 17794, opened: 2004},
  ATL: {name: 'State Farm Arena', place: :atlanta, capacity: 18118, opened: 1999},
  MIA: {name: 'American Airlines Arena', place: :miami, capacity: 19600, opened: 1999},
  CHA: {name: 'Spectrum Center', place: :charlotte, capacity: 19077, opened: 2005},
  UTA: {name: 'Vivint Smart Home Arena', place: :salt_lake_city, capacity: 18306, opened: 1991},
  SAC: {name: 'Golden 1 Center', place: :sacramento, capacity: 17583, opened: 2016},
  NYK: {name: 'Madison Square Garden', place: :new_york, capacity: 19812, opened: 1968},
  LAL: {name: 'Staples Center', place: :los_angeles, capacity: 18997, opened: 1999},
  ORL: {name: 'Amway Center', place: :orlando, capacity: 18846, opened: 2010},
  DAL: {name: 'American Airlines Center', place: :dallas, capacity: 19200, opened: 2001},
  BKN: {name: 'Barclays Center', place: :brooklyn, capacity: 17732, opened: 2012},
  DEN: {name: 'Pepsi Center', place: :denver, capacity: 19520, opened: 1999},
  IND: {name: 'Bankers Life Fieldhouse', place: :indianapolis, capacity: 17923, opened: 1999},
  NOP: {name: 'Smoothie King Center', place: :new_orleans, capacity: 16867, opened: 1999},
  DET: {name: 'Little Caesars Arena', place: :detroit, capacity: 20332, opened: 2017},
  TOR: {name: 'Scotiabank Arena', place: :toronto, capacity: 19800, opened: 1999},
  HOU: {name: 'Toyota Center', place: :houston, capacity: 18055, opened: 2003},
  SAS: {name: 'AT&T Center', place: :san_antonio, capacity: 18418, opened: 2002},
  PHX: {name: 'Talking Stick Resort Arena', place: :phoenix, capacity: 18055, opened: 1992},
  OKC: {name: 'Chesapeake Energy Arena', place: :oklahoma_city, capacity: 18203, opened: 2002},
  MIN: {name: 'Target Center', place: :minneapolis, capacity: 18978, opened: 1990},
  POR: {name: 'Moda Center', place: :portland, capacity: 19441, opened: 1995},
  GSW: {name: 'Chase Center', place: :san_francisco, capacity: 18064, opened: 2019},
  WAS: {name: 'Capital One Arena', place: :washington, capacity: 20356, opened: 1997}
}

stadium_data_file = Rails.root.join('db', 'seed_files', 'stadium_data.yml')
File.open(stadium_data_file, "w") { |file| file.write(stadium_data.to_yaml) }
stadium_data = YAML.load(File.read(stadium_data_file))

stadia = {}
stadium_data.each do |k, d|
  stadia[k] = Stadium.find_or_create(name: d[:name], place_id: places[d[:place]].id, capacity: d[:capacity], opened: d[:opened])
end

previous_stadia = {}
previous_stadium_data_file = Rails.root.join('db', 'seed_files', 'previous_stadium_data.yml')
File.open(previous_stadium_data_file, "w") { |file| file.write(previous_stadium_data.to_yaml) }
previous_stadium_data = YAML.load(File.read(previous_stadium_data_file))

previous_stadium_data.each do |k, d|
  puts k
  pp d
  previous_stadia[d[:name]] = Stadium.find_or_create(name: d[:name], place_id: places[d[:place]].id, capacity: d[:capacity], opened: d[:opened])
end

team_data = {
  PHI: {name: '76ers', place: :philadelphia, wiki: ['Philadelphia']},
  MIL: {name: 'Bucks', place: :milwaukee, wiki: ['Milwaukee', 'Milwaukee Bucks']},
  CHI: {name: 'Bulls', place: :chicago, wiki: ['Chicago']},
  CLE: {name: 'Cavaliers', place: :cleveland, wiki: ['Cleveland']},
  BOS: {name: 'Celtics', place: :boston, wiki: ['Boston']},
  LAC: {name: 'Clippers', place: :los_angeles, wiki: ['L.A. Clippers', 'LA Clippers', 'L. A. Clippers', 'LA Cilppers', 'L.A.Clippers', 'LA Cilppers', 'L.A Clippers']},
  MEM: {name: 'Grizzlies', place: :memphis, wiki: ['Memphis']},
  ATL: {name: 'Hawks', place: :atlanta, wiki: ['Atlanta']},
  MIA: {name: 'Heat', place: :miami, wiki: ['Miami']},
  CHA: {name: 'Hornets', place: :charlotte, wiki: ['Charlotte']},
  UTA: {name: 'Jazz', place: :utah, wiki: ['Utah']},
  SAC: {name: 'Kings', place: :sacramento, wiki: ['Sacramento']},
  NYK: {name: 'Knicks', place: :new_york, wiki: ['New York', 'N. Y. Knicks', 'NY Knicks', 'N.Y. Knicks']},
  LAL: {name: 'Lakers', place: :los_angeles, wiki: ['L.A. Lakers', 'LA Lakers', 'L. A. Lakers', 'L.A Lakers', 'L.A.Lakers']},
  ORL: {name: 'Magic', place: :orlando, wiki: ['Orlando']},
  DAL: {name: 'Mavericks', place: :dallas, wiki: ['Dallas']},
  BKN: {name: 'Nets', place: :brooklyn, wiki: ['Brooklyn']},
  DEN: {name: 'Nuggets', place: :denver, wiki: ['Denver']},
  IND: {name: 'Pacers', place: :indiana, wiki: ['Indiana']},
  NOP: {name: 'Pelicans', place: :new_orleans, wiki: ['New Orleans']},
  DET: {name: 'Pistons', place: :detroit, wiki: ['Detroit']},
  TOR: {name: 'Raptors', place: :toronto, wiki: ['Toronto']},
  HOU: {name: 'Rockets', place: :houston, wiki: ['Houston']},
  SAS: {name: 'Spurs', place: :san_antonio, wiki: ['San Antonio']},
  PHX: {name: 'Suns', place: :phoenix, wiki: ['Phoenix']},
  OKC: {name: 'Thunder', place: :oklahoma_city, wiki: ['Oklahoma City', 'Oklahoma']},
  MIN: {name: 'Timberwolves', place: :minnesota, wiki: ['Minnesota']},
  POR: {name: 'Trail Blazers', place: :portland, wiki: ['Portland']},
  GSW: {name: 'Warriors', place: :golden_state, wiki: ['Golden State']},
  WAS: {name: 'Wizards', place: :washington, wiki: ['Washington']},
  # Old team names (the teams still exist, just with different names, but in older seasons we need these)
  CHB: {name: 'Bobcats', place: :charlotte, wiki: ['Charlotte']},
  NOH: {name: 'Hornets', place: :new_orleans, wiki: ['New Orleans']},
  NJN: {name: 'Nets', place: :new_jersey, wiki: ['New Jersey']},
}

team_data_file = Rails.root.join('db', 'seed_files', 'team_data.yml')
File.open(team_data_file, "w") { |file| file.write(team_data.to_yaml) }
team_data = YAML.load(File.read(team_data_file))

division_structure_data = {
  atlantic: [:BOS, :BKN, :NJN, :NYK, :PHI, :TOR],
  central: [:CHI, :CLE, :DET, :IND, :MIL],
  southeast: [:ATL, :CHA, :CHB, :MIA, :ORL, :WAS],
  northwest: [:DEN, :MIN, :OKC, :POR, :UTA],
  pacific: [:GSW, :LAC, :LAL, :PHX, :SAC],
  southwest: [:DAL, :HOU, :MEM, :NOP, :NOH, :SAS],
}

division_structure_data_file = Rails.root.join('db', 'seed_files', 'division_structure_data.yml')
File.open(division_structure_data_file, "w") { |file| file.write(division_structure_data.to_yaml) }
division_structure_data = YAML.load(File.read(division_structure_data_file))

division_structure_lookup = {}
division_structure_data.each do |division, teams|
  teams.each do |team_code|
    division_structure_lookup[team_code] = nba_current_division_structures[division]
  end
end


teams = {}
team_names = {}
team_data.each do |k, d|
  team_names[k] = TeamName.create(name: d[:name], code: k.to_s)
  teams[k] = Team.create()
  teams[k].stadium = stadia[k]
  teams[k].team_name = team_names[k]
  teams[k].add_place(places[d[:place]])
end

roles = {
  player: Role.create(name: 'player'),
  coach:  Role.create(name: 'coach')
}

positions = {
  PG: Position.create(name: 'point guard',    code: 'PG', role_id: roles[:player].id),
  SG: Position.create(name: 'shooting guard', code: 'SG', role_id: roles[:player].id),
  G:  Position.create(name: 'guard',          code: 'G',  role_id: roles[:player].id),
  SF: Position.create(name: 'small forward',  code: 'SF', role_id: roles[:player].id),
  PF: Position.create(name: 'power forward',  code: 'PF', role_id: roles[:player].id),
  F:  Position.create(name: 'forward',        code: 'F',  role_id: roles[:player].id),
  C:  Position.create(name: 'center',         code: 'C',  role_id: roles[:player].id),
  X:  Position.create(name: 'unknown',        code: 'X',  role_id: roles[:player].id),
}

all_stages_set = Set.new(['regular_season', 'preseason', 'postseason'])





########################################################################################################################
# The below scrapes game records from Wikipedia, included here as it uses some of the data generated above
# Direct as it is only ~150 pages.
########################################################################################################################

SCRAPE = false

if SCRAPE
  scraped_season_data = {}

  nba_seasons.each do |start_year, season|
    puts "\n--#{start_year}"
    scraped_season_data[start_year] = {}
    teams.each do |team_code, team|
      stages_set = Set.new
      playoff_round = 0

      # Handle teams who changed names / places
      next if team_code == :NJN && start_year >= 2012
      next if team_code == :BKN && start_year <  2012

      next if team_code == :NOH && start_year >= 2013
      next if team_code == :NOP && start_year <  2013
      
      next if team_code == :CHB && start_year >= 2014
      next if team_code == :CHA && start_year <  2014

      scraped_season_data[start_year][team_code] = {}
      puts "\n---#{team_code} - #{start_year}"

      team_url_key = "#{team.places.first.to_s.gsub(' ', '_')}_#{team.team_name.to_s.gsub(' ', '_')}_season"
      url = "https://en.wikipedia.org/wiki/#{start_year}%E2%80%93#{(start_year+1).to_s.last(2)}_#{team_url_key}"
      path = Rails.root.join('db','seed_files','seasons_teams',"#{start_year}-#{(start_year+1).to_s.last(2)}_#{team_url_key}.yml")

      doc = nil

      unless doc
        begin
          doc = Nokogiri::HTML(open(url))
        rescue
          puts "Cannot load: #{url}"
        end
      end

      next unless doc

      # Wikipedia has no preseason entries for these teams in this year
      season_stage = ([:WAS, :SAS, :NOP].include?(team_code) && start_year == 2014) ? 'preseason' : 'none'
      doc.xpath("//div[@class='NavFrame']//div[@class='NavContent']//table[@class='wikitable']//tbody//tr").each do |tr|
        tds = tr.children.select{|child| child.name == 'td'}
        next if tds.size != 9

        # 0 - Game Number
        game_number = tds[0].text.strip

        unless game_number =~ /\A[-+]?[0-9]*\.?[0-9]+\Z/
          puts "Invalid GN: #{game_number}, #{start_year}-#{team_url_key}"
          next
        end

        # Manual correction for 2013 Spurs season and 2011 Bobcats season
        # TODO - regex
        game_number = '78' if game_number == '78[2]'
        game_number = '25' if game_number == '25c'

        if season_stage == 'none'
          # Manually Hack because preseson does not exist on wiki for these teams.
          season_stage = ([:SAC].include?(team_code) && start_year == 2015) ? 'regular_season' : 'preseason'
        elsif season_stage == 'preseason'
           season_stage = 'regular_season' if game_number.to_i == 1
        else
          if game_number.to_i == 1
            season_stage = 'postseason'
            playoff_round += 1
          end
        end

        stages_set.add(season_stage)

        # 1 - Date (MonthName, DoM)
        arr = tds[1].text =~ /:/ ? tds[1].children[0].text.split : tds[1].text.split
        month = arr[0].strip
        day_of_month = arr[1].strip

        # 2 - Opponent ([@] Team)
        opponent = tds[2].text.strip

        # 3 - Score (W/L X-Y)
        score = tds[3].text.strip

        # 4 - High Points (ignore)
        # 5 - High Rebounds (ignore)
        # 6 - High Assists (ignore)

        # 7 - Location (Stadium\nAttendance)
        stadium     = tds[7].children.size > 0 ? tds[7].children[0].text.strip : nil
        attendance  = tds[7].children.size > 2 ? tds[7].children[2].text.strip : '0'

        # 8 - Record After Game (W-L)
        record = tds[8].text.strip

        h = {
          month:        month,
          day_of_month: day_of_month,
          opponent:     opponent,
          score:        score,
          stadium:      stadium,
          attendance:   attendance.gsub(/^\d/,''),
          record:       record
        }

        pp h

        scraped_season_data[start_year][team_code][season_stage] = {} unless scraped_season_data[start_year][team_code][season_stage]
        unless scraped_season_data[start_year][team_code][season_stage][playoff_round.to_s]
          scraped_season_data[start_year][team_code][season_stage][playoff_round.to_s] = {}
        end
        scraped_season_data[start_year][team_code][season_stage][playoff_round.to_s][game_number] = h
      end
  
      diff = all_stages_set - stages_set
      puts "no stage: (#{diff}) for #{start_year} in #{team_code}" unless stages_set.size == 3
    end
  end
end

scraped_season_data_file = Rails.root.join('db', 'seed_files', 'scraped_season_data.yml')
File.open(scraped_season_data_file, "w") { |file| file.write(scraped_season_data.to_yaml) } if SCRAPE
scraped_season_data = YAML.load(File.read(scraped_season_data_file))

nba_team_in_seasons = {}

scraped_season_data.each do |start_year, data|
  season = nba_seasons[start_year]
  data.each do |team_code, games|
    k = "#{team_code}-#{start_year}".freeze
    team = teams[team_code]
    nba_team_in_seasons[k] = TeamInSeason.create(
      team_id: team.id,
      season_id: nba_seasons[start_year].id,
      division_structure_id: division_structure_lookup[team_code].id
    )
    nba_team_in_seasons[k].team_name = team.team_name
    team.places.each do |place|
      nba_team_in_seasons[k].place = place
    end
    nba_team_in_seasons[k].stadium = team.stadium
  end
end

nba_game_data = {}

# Check that all the month names are correct (spelling issues in Wikipedia, Marth, Marsh etc)
scraped_season_data.each do |start_year, data|
  data.each do |team_code, stages|
    stages.each do |stage, rounds|
      rounds.each do |round, games|
        games.each do |game_number, game_data|
          raise "Invalid Month #{game_data[:month]}" unless months.include? game_data[:month]
        end
      end
    end
  end
end

stadia_lookup   = Stadium.get_lookup
stadium_set     = Set.new
other_opponents = Set.new

scraped_season_data.each do |start_year, data|
  puts start_year
  season = nba_seasons[start_year]
  nba_game_data[start_year] = {}

  data.each do |team_code, stages|
    stages.each do |stage, rounds|
      next unless stage == 'regular_season'
      rounds.each do |round, games|
        if games.size != (start_year == 2011 ? 66 : 82) && stage == 'regular_season'
          pp "#{start_year} #{team_code} #{games.size} #{((1..82).map{|x| x.to_s } - games.keys).join(',')}"
          raise "NON 82 Game Season"
        end
        games.each do |game_number, game_data|
          puts "G: #{team_code} | #{start_year} | #{stage} | #{game_number}"
          arr = game_number.split('_')
          game_stage = arr[0]
          game_number = arr[0]

          # TODO - postponed games due to the death of Kobe Bryant (also Covid-19)
          next if game_number.to_i > 46 && start_year.to_s == '2019'

          home = game_data[:opponent].first != '@'
          next unless home
          winner = game_data[:opponent].first == 'W'
          game_data[:opponent].slice!(0) unless home
          game_data[:opponent].lstrip!


          # TODO - Automate this a bit better (or fix at source)
          game_data[:opponent] = 'Miami'          if game_data[:opponent] == 'vs. Miami'
          game_data[:opponent] = 'Boston'         if game_data[:opponent] == 'Celtics'
          game_data[:opponent] = 'Detroit'        if game_data[:opponent] == 'Pistons'
          game_data[:opponent] = 'Dallas'         if game_data[:opponent] == 'Mavericks'
          game_data[:opponent] = 'Chicago'        if game_data[:opponent] == 'Bulls'
          game_data[:opponent] = 'Indiana'        if game_data[:opponent] == 'Pacers'
          game_data[:opponent] = 'Minnesota'      if game_data[:opponent] == 'Timberwolves'
          game_data[:opponent] = 'Brooklyn'       if game_data[:opponent] == 'Nets'
          game_data[:opponent] = 'Orlando'        if game_data[:opponent] == 'Magic'
          game_data[:opponent] = 'Philadelphia'   if game_data[:opponent] == '76ers'
          game_data[:opponent] = 'New York'       if game_data[:opponent] == 'Knicks'
          game_data[:opponent] = 'Golden State'   if game_data[:opponent] == 'Warriors'
          game_data[:opponent] = 'New Orleans'    if game_data[:opponent] == 'Pelicans'
          game_data[:opponent] = 'Milwaukee'      if game_data[:opponent] == 'Bucks'
          game_data[:opponent] = 'Denver'         if game_data[:opponent] == 'Nuggets'
          game_data[:opponent] = 'Utah'           if game_data[:opponent] == 'Jazz'
          game_data[:opponent] = 'Phoenix'        if game_data[:opponent] == 'Suns'
          game_data[:opponent] = 'Denver'         if game_data[:opponent] == 'vs Denver'
          game_data[:opponent] = 'L.A. Clippers'  if game_data[:opponent] == 'vs LA Clippers'
          game_data[:opponent] = 'Washington'     if game_data[:opponent] == 'Wizards'

          # TODO - Handle random preseason teams (these are ones found so far)
          #  "Maccabi Tel Aviv",
          #  "Flamengo",
          #  "Maccabi Haifa",
          #  "Bauru",
          #  "San Lorenzo",
          #  "Shanghai Sharks",
          #  "Sydney",
          #  "Brisbane",
          #  "Melbourne",
          #  "Guangzhou Long-Lions",
          #  "Melbourne United",
          #  "Maccabi",
          #  "Perth",
          #  "Adelaide",
          #  "Beijing",
          #  "Perth Wildcats",
          #  "New Zealand"}>

          opponent_candidates = []
          team_data.each do |code, t|
            opponent_candidates << code if t[:wiki].include? game_data[:opponent]
          end
          
          opponent_candidates.reject!{|oc| oc == :NOH && start_year > 2012 }
          opponent_candidates.reject!{|oc| oc == :NOP && start_year < 2013 }
          opponent_candidates.reject!{|oc| oc == :CHB && start_year > 2013 }
          opponent_candidates.reject!{|oc| oc == :CHA && start_year < 2014 }

          unless opponent_candidates.size == 1
            puts "error finding opponent"
            pp team_code
            other_opponents.add(game_data[:opponent])
            next
          end

          opponent_code = opponent_candidates.first

          team_keys = [team_code.to_s, opponent_code.to_s].sort
          team_keys << game_data[:month]
          team_keys << game_data[:day_of_month]
          team_keys << game_data[:stadium]
          team_keys = team_keys.join('_')

          unless nba_game_data[start_year][team_keys]
            score_arr = ["",""]
            score_i = 0
            game_data[:score].split('').each do |char|
              score_i = 1 if char == '–'
              break if char == '('
              score_arr[score_i] << char if char =~ /\d/
            end

            # TODO - Get this out of here and just use the data in the game table
            month_name = month_names[game_data[:month]]
            year = month_name.id > 3 ? season.end_year : season.start_year
            dom = game_data[:day_of_month].tr('^0-9', '').to_i

            gs = -2
            gs = -1 if stage == 'preseason'
            gs =  0 if stage == 'regular_season'
            gs = round if stage == 'postseason'

            g = Game.create(
              season_id: season.id,
              day_of_month:  dom,
              month_name_id: month_name.id,
              date: Game.date_from_segs(season, game_data[:month], dom),
              stage: gs,
              attendance: game_data[:attendance].gsub(/,/,'').to_i,
            )

            # manual hack for different styles of names (TODO - find better way with alias names or something)
            game_data[:stadium] = "American Airlines Arena" if game_data[:stadium] == "AmericanAirlines Arena"
            game_data[:stadium] = "FedExForum" if game_data[:stadium] == "FedEx Forum"
            game_data[:stadium]= "BMO Harris Bradley Center" if game_data[:stadium] == "Bradley Center"

            stadium = stadia_lookup[game_data[:stadium]]
            if stadium
              g.stadium = stadium
              g.save
            else
              stadium_set.add(game_data[:stadium])
            end

            unless score_arr.size == 2
              pp game_data, team_keys
              raise "Invalid Score" 
            end

            a = TeamInGame.create(
              game_id: g.id,
              team_in_season_id: nba_team_in_seasons["#{team_code}-#{start_year}"].id,
              home: home,
              winner: winner,
              points: score_arr[0]
            )

            b = TeamInGame.create(
              game_id: g.id,
              team_in_season_id: nba_team_in_seasons["#{opponent_code}-#{start_year}"].id,
              home: !home,
              winner: !winner,
              points: score_arr[1]
            )

            nba_game_data[start_year][team_keys] = {
              game: g,
              team_in_games: [a,b]
            }
          end
        end
      end
    end
  end
end

Season.each do |season|
  season.team_in_seasons.each do |tis|
    tis.team_in_games.sort_by(&:date).each_with_index.each do |tig, i|
      tig.update(game_number: i+1)
    end
  end
end

# Check the game numbers for each TeamInGame
scraped_season_data.each do |start_year, data|
  season = nba_seasons[start_year]
  data.each do |team_code, stages|
    # TODO - in Sequel
    tis = season.team_in_seasons.select{|tis| tis.team.code == team_code.to_s }.first
    tigs = tis.team_in_games.map{|tig| [tig.game.date.strftime("%Y-%m-%d"), tig] }.to_h
    stages.each do |stage, rounds|
      next unless stage == 'regular_season'
      rounds.each do |round, games|
        games.each do |game_number, h|

          begin
            d = Game.date_from_segs(season, h[:month], h[:day_of_month].tr('^0-9', '').to_i).strftime("%Y-%m-%d")
            tig = tigs[d]
            raise "gah" unless game_number.to_s == tig.game_number.to_s
          rescue Exception => e
            pp e
            puts "#{game_number} == #{tig ? tig.game_number : 'NIL'}"
            pp start_year
            pp team_code
            pp game_number
            pp h
            pp tig
            puts "--------------------"
            puts "--------------------"
            puts "--------------------"
          end
        end
      end
    end
  end
end

pp stadium_set
pp other_opponents