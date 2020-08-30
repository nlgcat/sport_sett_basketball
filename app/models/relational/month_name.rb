class MonthName < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :games

  def to_s
    name
  end
end
