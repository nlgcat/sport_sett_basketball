class PlayStatisticReasonType < Sequel::Model
  plugin :timestamps, update_on_create: true

  one_to_many :play_statistic_reasons
end
