class Conference < Sequel::Model
  plugin :timestamps, update_on_create: true
  many_to_one :league
  one_to_many :division_structures

  def to_s
    name
  end
end
