Sequel.migration do
  change do
    create_table(:dataset_splits) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
    end
    
    create_table(:discrepancies) do
      primary_key :id
      column :cti_type, "text", :null=>false
      column :resolved, "boolean", :default=>false, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:resolved]
    end
    
    create_table(:discrepancy_adjustments) do
      primary_key :id
      column :quantity, "integer", :null=>false
      column :quantity_should_be, "integer", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:quantity]
      index [:quantity_should_be]
    end
    
    create_table(:month_names) do
      primary_key :id
      column :name, "text", :null=>false
      column :calander_month_int, "integer", :null=>false
      column :year_offset, "integer", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:calander_month_int]
      index [:name]
      index [:year_offset]
    end
    
    create_table(:people) do
      primary_key :id
      column :name, "text", :null=>false
      column :first_name, "text"
      column :last_name, "text"
      column :url_seg, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:first_name]
      index [:last_name]
      index [:name]
      index [:name], :name=>:people_name_key, :unique=>true
      index [:url_seg], :unique=>true
    end
    
    create_table(:place_types) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
    end
    
    create_table(:play_statistic_reason_types) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
    end
    
    create_table(:playoff_round_types) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
    end
    
    create_table(:playoff_series_numbers) do
      column :id, "integer", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      primary_key [:id]
    end
    
    create_table(:playoff_series_team_in_seasons) do
      primary_key :id
    end
    
    create_table(:roles) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
    end
    
    create_table(:schema_migrations) do
      column :filename, "text", :null=>false
      
      primary_key [:filename]
    end
    
    create_table(:sports) do
      primary_key :id
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
    end
    
    create_table(:statistic_types) do
      primary_key :id
      column :name, "text", :null=>false
      column :code, "text", :null=>false
      column :counts_for_double, "boolean", :default=>false, :null=>false
      column :points_per, "integer", :default=>0, :null=>false
      column :multiplier, "integer", :default=>1, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:code]
      index [:counts_for_double]
      index [:multiplier]
      index [:name]
      index [:points_per]
    end
    
    create_table(:team_names) do
      primary_key :id
      column :name, "text", :null=>false
      column :code, "text", :null=>false
      column :determiner, "boolean", :default=>true, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:code]
      index [:determiner]
      index [:name]
    end
    
    create_table(:teams) do
      primary_key :id
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
    end
    
    create_table(:discrepancies_discrepancy_adjustments) do
      foreign_key :discrepancy_adjustment_id, :discrepancy_adjustments, :null=>false, :key=>[:id]
      foreign_key :discrepancy_id, :discrepancies, :null=>false, :key=>[:id]
      
      index [:discrepancy_adjustment_id, :discrepancy_id], :name=>:discrepancies_discrepancy_adjustments_discrepancy_adjustment_id
    end
    
    create_table(:leagues) do
      primary_key :id
      foreign_key :sport_id, :sports, :null=>false, :key=>[:id]
      column :name, "text", :null=>false
      column :abreviation, "text", :null=>false
      column :determiner, "text", :default=>Sequel::LiteralString.new("true"), :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:abreviation]
      index [:name]
      index [:sport_id]
    end
    
    create_table(:people_teams) do
      foreign_key :person_id, :people, :null=>false, :key=>[:id]
      foreign_key :team_id, :teams, :null=>false, :key=>[:id]
      
      index [:person_id]
      index [:team_id]
    end
    
    create_table(:places) do
      primary_key :id
      foreign_key :place_type_id, :place_types, :null=>false, :key=>[:id]
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
      index [:place_type_id]
    end
    
    create_table(:positions) do
      primary_key :id
      foreign_key :role_id, :roles, :null=>false, :key=>[:id]
      column :name, "text", :null=>false
      column :code, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:code]
      index [:name]
      index [:role_id]
    end
    
    create_table(:rotowire_entries) do
      primary_key :id
      foreign_key :dataset_split_id, :dataset_splits, :null=>false, :key=>[:id]
      column :summary, "text", :default=>"", :null=>false
      column :rw_line, "integer", :default=>Sequel::LiteralString.new("'-1'::integer"), :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:dataset_split_id]
      index [:rw_line]
    end
    
    create_table(:statistics) do
      primary_key :id
      foreign_key :statistic_type_id, :statistic_types, :null=>false, :key=>[:id]
      column :quantity, "integer", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:quantity]
      index [:statistic_type_id]
    end
    
    create_table(:team_names_teams) do
      foreign_key :team_id, :teams, :null=>false, :key=>[:id]
      foreign_key :team_name_id, :team_names, :null=>false, :key=>[:id]
      
      index [:team_id]
      index [:team_name_id]
    end
    
    create_table(:conferences) do
      primary_key :id
      foreign_key :league_id, :leagues, :null=>false, :key=>[:id]
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:league_id]
      index [:name]
    end
    
    create_table(:discrepancies_statistics) do
      foreign_key :statistic_id, :statistics, :null=>false, :key=>[:id]
      foreign_key :discrepancy_id, :discrepancies, :null=>false, :key=>[:id]
      
      index [:statistic_id, :discrepancy_id]
    end
    
    create_table(:divisions) do
      primary_key :id
      foreign_key :league_id, :leagues, :null=>false, :key=>[:id]
      column :name, "text", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:league_id]
      index [:name]
    end
    
    create_table(:league_structures) do
      primary_key :id
      foreign_key :league_id, :leagues, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:league_id]
    end
    
    create_table(:people_positions) do
      foreign_key :person_id, :people, :null=>false, :key=>[:id]
      foreign_key :position_id, :positions, :null=>false, :key=>[:id]
      
      index [:person_id]
      index [:position_id]
    end
    
    create_table(:places_in_places) do
      foreign_key :parent_id, :places, :null=>false, :key=>[:id]
      foreign_key :child_id, :places, :null=>false, :key=>[:id]
      
      index [:child_id]
      index [:parent_id]
    end
    
    create_table(:places_teams) do
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
      foreign_key :team_id, :teams, :null=>false, :key=>[:id]
      
      index [:place_id]
      index [:team_id]
    end
    
    create_table(:stadia) do
      primary_key :id
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
      column :name, "text", :null=>false
      column :capacity, "integer", :null=>false
      column :opened, "integer", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:name]
      index [:opened]
      index [:place_id]
    end
    
    create_table(:division_structures) do
      primary_key :id
      foreign_key :conference_id, :conferences, :null=>false, :key=>[:id]
      foreign_key :division_id, :divisions, :null=>false, :key=>[:id]
      foreign_key :league_structure_id, :league_structures, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:conference_id]
      index [:division_id]
      index [:league_structure_id]
    end
    
    create_table(:seasons) do
      primary_key :id
      foreign_key :league_structure_id, :league_structures, :null=>false, :key=>[:id]
      column :start_year, "integer", :null=>false
      column :end_year, "integer", :null=>false
      column :season_start, "timestamp without time zone", :null=>false
      column :season_end, "timestamp without time zone", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:end_year]
      index [:league_structure_id]
      index [:season_end]
      index [:season_start]
      index [:start_year]
    end
    
    create_table(:stadia_teams) do
      foreign_key :stadium_id, :stadia, :null=>false, :key=>[:id]
      foreign_key :team_id, :teams, :null=>false, :key=>[:id]
      
      index [:stadium_id]
      index [:team_id]
    end
    
    create_table(:games) do
      primary_key :id
      foreign_key :season_id, :seasons, :null=>false, :key=>[:id]
      foreign_key :month_name_id, :month_names, :null=>false, :key=>[:id]
      column :day_of_month, "integer", :null=>false
      column :date, "timestamp without time zone", :null=>false
      column :attendance, "integer", :default=>0, :null=>false
      column :stage, "integer", :default=>Sequel::LiteralString.new("'-1'::integer"), :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:attendance]
      index [:day_of_month]
      index [:month_name_id]
      index [:season_id]
      index [:stage]
    end
    
    create_table(:playoffs) do
      primary_key :id
      foreign_key :season_id, :seasons, :null=>false, :key=>[:id]
      column :playoff_start, "timestamp without time zone", :null=>false
      column :playoff_end, "timestamp without time zone", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:playoff_end]
      index [:playoff_start]
      index [:season_id]
    end
    
    create_table(:team_in_seasons) do
      primary_key :id
      foreign_key :division_structure_id, :division_structures, :null=>false, :key=>[:id]
      foreign_key :season_id, :seasons, :null=>false, :key=>[:id]
      foreign_key :team_id, :teams, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:division_structure_id]
      index [:season_id]
      index [:team_id]
    end
    
    create_table(:game_periods) do
      primary_key :id
      foreign_key :game_id, :games, :null=>false, :key=>[:id]
      column :value, "integer", :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:game_id]
      index [:value]
    end
    
    create_table(:games_rotowire_entries) do
      foreign_key :game_id, :games, :null=>false, :key=>[:id]
      foreign_key :rotowire_entry_id, :rotowire_entries, :null=>false, :key=>[:id]
      
      index [:game_id]
      index [:rotowire_entry_id]
    end
    
    create_table(:games_stadia) do
      foreign_key :stadium_id, :stadia, :null=>false, :key=>[:id]
      foreign_key :game_id, :games, :null=>false, :key=>[:id]
      
      index [:game_id]
      index [:stadium_id]
    end
    
    create_table(:person_in_team_in_seasons) do
      primary_key :id
      foreign_key :team_in_season_id, :team_in_seasons, :null=>false, :key=>[:id]
      foreign_key :person_id, :people, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:person_id]
      index [:team_in_season_id]
    end
    
    create_table(:places_team_in_seasons) do
      foreign_key :place_id, :places, :null=>false, :key=>[:id]
      foreign_key :team_in_season_id, :team_in_seasons, :null=>false, :key=>[:id]
      
      index [:place_id]
      index [:team_in_season_id]
    end
    
    create_table(:playoff_rounds) do
      primary_key :id
      foreign_key :playoff_id, :playoffs, :null=>false, :key=>[:id]
      foreign_key :playoff_round_type_id, :playoff_round_types, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:playoff_id]
      index [:playoff_round_type_id]
    end
    
    create_table(:stadia_team_in_seasons) do
      foreign_key :stadium_id, :stadia, :null=>false, :key=>[:id]
      foreign_key :team_in_season_id, :team_in_seasons, :null=>false, :key=>[:id]
      
      index [:stadium_id]
      index [:team_in_season_id]
    end
    
    create_table(:team_in_games) do
      primary_key :id
      foreign_key :team_in_season_id, :team_in_seasons, :null=>false, :key=>[:id]
      foreign_key :game_id, :games, :null=>false, :key=>[:id]
      column :winner, "boolean", :null=>false
      column :home, "boolean", :null=>false
      column :points, "integer", :null=>false
      column :game_number, "integer", :default=>0, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:game_id]
      index [:game_number]
      index [:home]
      index [:points]
      index [:team_in_season_id]
      index [:winner]
    end
    
    create_table(:team_in_seasons_team_names) do
      foreign_key :team_in_season_id, :team_in_seasons, :null=>false, :key=>[:id]
      foreign_key :team_name_id, :team_names, :null=>false, :key=>[:id]
      
      index [:team_in_season_id]
      index [:team_name_id]
    end
    
    create_table(:discrepancies_team_in_games) do
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      foreign_key :discrepancy_id, :discrepancies, :null=>false, :key=>[:id]
      
      index [:discrepancy_id]
      index [:team_in_game_id]
    end
    
    create_table(:person_in_team_in_games) do
      primary_key :id
      foreign_key :person_in_team_in_season_id, :person_in_team_in_seasons, :null=>false, :key=>[:id]
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      column :starter, "boolean", :default=>false, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:person_in_team_in_season_id]
      index [:team_in_game_id]
    end
    
    create_table(:playoff_series) do
      primary_key :id
      foreign_key :playoff_round_id, :playoff_rounds, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:playoff_round_id]
    end
    
    create_table(:plays) do
      primary_key :id
      foreign_key :game_period_id, :game_periods, :null=>false, :key=>[:id]
      column :time_seconds, "double precision", :null=>false
      column :home_score, "integer", :default=>0, :null=>false
      column :home_cumulative_score, "integer", :default=>0, :null=>false
      column :visiting_score, "integer", :default=>0, :null=>false
      column :visiting_cumulative_score, "integer", :default=>0, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:game_period_id]
      index [:home_cumulative_score]
      index [:home_score]
      index [:time_seconds]
      index [:visiting_cumulative_score]
      index [:visiting_score]
    end
    
    create_table(:statistics_team_in_games) do
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      foreign_key :statistic_id, :statistics, :null=>false, :key=>[:id]
      
      index [:statistic_id]
      index [:team_in_game_id]
    end
    
    create_table(:team_in_game_periods) do
      primary_key :id
      foreign_key :game_period_id, :game_periods, :null=>false, :key=>[:id]
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:game_period_id]
      index [:team_in_game_id]
    end
    
    create_table(:discrepancies_person_in_team_in_games) do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, :null=>false, :key=>[:id]
      foreign_key :discrepancy_id, :discrepancies, :null=>false, :key=>[:id]
      
      index [:discrepancy_id]
      index [:person_in_team_in_game_id], :name=>:discrepancies_person_in_team_in_games_person_in_team_in_game_id
    end
    
    create_table(:person_in_team_in_game_periods) do
      primary_key :id
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, :null=>false, :key=>[:id]
      foreign_key :team_in_game_period_id, :team_in_game_periods, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:person_in_team_in_game_id]
      index [:team_in_game_period_id]
    end
    
    create_table(:person_in_team_in_games_positions) do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, :null=>false, :key=>[:id]
      foreign_key :position_id, :positions, :null=>false, :key=>[:id]
      
      index [:person_in_team_in_game_id], :name=>:person_in_team_in_games_positions_person_in_team_in_game_id_ind
      index [:position_id]
    end
    
    create_table(:person_in_team_in_games_statistics) do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, :null=>false, :key=>[:id]
      foreign_key :statistic_id, :statistics, :null=>false, :key=>[:id]
      
      index [:person_in_team_in_game_id], :name=>:person_in_team_in_games_statistics_person_in_team_in_game_id_in
      index [:statistic_id]
    end
    
    create_table(:person_in_team_in_games_team_in_games) do
      foreign_key :person_in_team_in_game_id, :person_in_team_in_games, :null=>false, :key=>[:id]
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      
      index [:person_in_team_in_game_id], :name=>:person_in_team_in_games_team_in_games_person_in_team_in_game_id
      index [:team_in_game_id]
    end
    
    create_table(:play_statistics) do
      primary_key :id
      foreign_key :play_id, :plays, :null=>false, :key=>[:id]
      foreign_key :statistic_id, :statistics, :null=>false, :key=>[:id]
      column :x, "integer", :default=>0, :null=>false
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:play_id]
      index [:statistic_id]
      index [:x]
    end
    
    create_table(:plays_team_in_games) do
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      foreign_key :play_id, :plays, :null=>false, :key=>[:id]
      
      index [:play_id]
      index [:team_in_game_id]
    end
    
    create_table(:statistics_team_in_game_periods) do
      foreign_key :team_in_game_period_id, :team_in_game_periods, :null=>false, :key=>[:id]
      foreign_key :statistic_id, :statistics, :null=>false, :key=>[:id]
      
      index [:statistic_id]
      index [:team_in_game_period_id]
    end
    
    create_table(:team_in_playoff_games) do
      primary_key :id
      foreign_key :team_in_game_id, :team_in_games, :null=>false, :key=>[:id]
      foreign_key :playoff_series_id, :playoff_series, :null=>false, :key=>[:id]
      foreign_key :playoff_series_number_id, :playoff_series_numbers, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:playoff_series_id]
      index [:playoff_series_number_id]
      index [:team_in_game_id]
    end
    
    create_table(:discrepancies_person_in_team_in_game_periods) do
      foreign_key :person_in_team_in_game_period_id, :person_in_team_in_game_periods, :null=>false, :key=>[:id]
      foreign_key :discrepancy_id, :discrepancies, :null=>false, :key=>[:id]
      
      index [:discrepancy_id], :name=>:discrepancies_person_in_team_in_game_periods_discrepancy_id_ind
      index [:person_in_team_in_game_period_id], :name=>:discrepancies_person_in_team_in_game_periods_person_in_team_in_
    end
    
    create_table(:discrepancies_play_statistic_statistics) do
      foreign_key :play_statistic_id, :play_statistics, :null=>false, :key=>[:id]
      foreign_key :discrepancy_id, :discrepancies, :null=>false, :key=>[:id]
      
      index [:discrepancy_id]
      index [:play_statistic_id]
    end
    
    create_table(:person_in_team_in_game_periods_play_statistics) do
      foreign_key :person_in_team_in_game_period_id, :person_in_team_in_game_periods, :null=>false, :key=>[:id]
      foreign_key :play_statistic_id, :play_statistics, :null=>false, :key=>[:id]
      
      index [:person_in_team_in_game_period_id], :name=>:person_in_team_in_game_periods_play_statistics_person_in_team_i
      index [:play_statistic_id], :name=>:person_in_team_in_game_periods_play_statistics_play_statistic_i
    end
    
    create_table(:person_in_team_in_game_periods_statistics) do
      foreign_key :person_in_team_in_game_period_id, :person_in_team_in_game_periods, :null=>false, :key=>[:id]
      foreign_key :statistic_id, :statistics, :null=>false, :key=>[:id]
      
      index [:person_in_team_in_game_period_id], :name=>:person_in_team_in_game_periods_statistics_person_in_team_in_gam
      index [:statistic_id]
    end
    
    create_table(:play_statistic_reasons) do
      primary_key :id
      foreign_key :play_statistic_id, :play_statistics, :null=>false, :key=>[:id]
      foreign_key :play_statistic_reason_type_id, :play_statistic_reason_types, :null=>false, :key=>[:id]
      column :created_at, "timestamp without time zone", :null=>false
      column :updated_at, "timestamp without time zone", :null=>false
      
      index [:play_statistic_id]
      index [:play_statistic_reason_type_id]
    end
    
    create_table(:play_statistics_team_in_game_periods) do
      foreign_key :team_in_game_period_id, :person_in_team_in_game_periods, :null=>false, :key=>[:id]
      foreign_key :play_statistic_id, :play_statistics, :null=>false, :key=>[:id]
      
      index [:play_statistic_id]
      index [:team_in_game_period_id], :name=>:play_statistics_team_in_game_periods_team_in_game_period_id_ind
    end
  end
end
              Sequel.migration do
                change do
                  self << "SET search_path TO \"$user\", public"
                  self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123093243_create_dataset_splits.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123093244_create_month_names.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123093245_create_team_names.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123093246_create_sports.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123093837_create_leagues.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123123832_create_conferences.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123124019_create_divisions.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123124524_create_league_structures.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123124527_create_division_structures.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123135026_create_seasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123135257_create_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123135618_create_game_periods.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123140045_create_teams.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123140049_create_people.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123140618_create_roles.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123140625_create_positions.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123141059_create_place_types.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123141101_create_places.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123141117_create_stadia.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123141118_create_statistic_types.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123141119_create_statistics.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123141845_create_team_in_seasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123142625_create_team_in_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123143031_create_person_in_team_in_seasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123143342_create_person_in_team_in_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145502_create_person_in_team_in_games_team_in_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145549_create_stadia_teams.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145559_create_stadia_team_in_seasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145627_create_places_in_places.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145637_create_places_teams.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145648_create_places_team_in_seasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145658_create_people_teams.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145708_create_people_positions.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145720_create_person_in_games_positions.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145903_create_team_names_teams.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200123145917_create_team_in_seasons_team_names.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200311133716_create_games_stadia.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314085152_create_playoffs.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314090205_create_playoff_round_types.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314090208_create_playoff_rounds.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314090213_create_playoff_series.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314090222_create_playoff_series_numbers.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314090223_create_team_in_playoff_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314090903_create_playoff_series_team_in_seasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314194224_create_rotowire_entries.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200314194239_create_games_rotowire_entries.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200322124549_create_team_in_game_periods.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200331155213_create_person_in_team_in_game_periods.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200331155232_create_person_in_team_in_game_periods_statistics.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200405072957_create_person_in_team_in_games_statistics.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200405074559_create_statistics_team_in_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200405074603_create_statistics_team_in_game_periods.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200407135556_create_plays.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200407135557_create_play_statistics.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200407135631_create_person_in_team_in_game_periods_plays.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200407135642_create_plays_team_in_game_periods.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200407140324_create_play_statistic_reason_types.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200407140350_create_play_statistic_reasons.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413060545_create_discrepancies.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413061030_create_discrepancies_person_in_team_in_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413061033_create_discrepancies_person_in_team_in_game_periods.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413061040_create_discrepancies_play_statistics.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413070859_create_discrepancies_statistics.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413071912_create_discrepancy_adjustments.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200413071952_create_discrepancies_discrepancy_adjustments.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200414095400_create_plays_team_in_games.rb')"
self << "INSERT INTO \"schema_migrations\" (\"filename\") VALUES ('20200414145342_create_discrepancies_team_in_games.rb')"
                end
              end
