class PlayStatisticReason < Sequel::Model
  plugin :timestamps, update_on_create: true

  one_to_many :play_statistic
  one_to_many :play_statistic_reason_type
end
