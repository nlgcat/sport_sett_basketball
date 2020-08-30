class DiscrepancyAdjustment < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_through_one :discrepancy
end
