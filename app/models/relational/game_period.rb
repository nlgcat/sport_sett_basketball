class GamePeriod < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :game
  one_to_many :team_in_game_period

  def rotowire_key
    value > 4 ? "OT#{value-4}" : "QTR#{value}"
  end

  def onmt_name
    value > 4 ? "#{(value-4).ordinalize}_overtime" : "#{value.ordinalize}_quarter"
  end
end
