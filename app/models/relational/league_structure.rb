class LeagueStructure < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :league
  one_to_many :division_structures
  one_to_many :seasons

  def onmt_name
    league.abreviation
  end
end
