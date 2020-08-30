class PersonInTeamInGameDiscrepancy < Discrepancy
  # TODO - Remove the Statistic record if it is zero (and all associations)
  def resolve!
    discrepant_object.set_statistic_by_type(statistic_type, should_be)
    puts "   setting #{statistic_type.code} from #{quantity} to #{quantity_should_be} for #{discrepant_object.name}/#{cti_type}"

    s = statistic
    if s
      s.update(quantity: quantity)
    else
      s = Statistic.create(quantity: quantity, statistic_type_id: statistic_type.id)
      self.add_statistic(s)
    end
    s
  end
end