class Role < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_to_many :positions
end
