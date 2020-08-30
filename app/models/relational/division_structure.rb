class DivisionStructure < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :team_in_seasons
  many_to_one :conference
  many_to_one :division
  many_to_one :league_structure

  def to_s
    "#{conference} #{division}"
  end

  def onmt_h
    {
      'CONFERENCE'  => conference.name,
      'DIVISION'    => division.name,
    }
  end
end
