# Class for resolving discrepancies between statistics in different dimensions (i.e. game vs play-by-play)
# WARNING - This has never been fully deployed or tested.
class Discrepancy < Sequel::Model
  plugin :class_table_inheritance, key: :cti_type
  plugin :timestamps, update_on_create: true

  one_through_one :team_in_game
  one_through_one :person_in_team_in_game
  one_through_one :statistic
  one_through_one :discrepancy_adjustment

  def discrepant_object
    person_in_team_in_game
  end

  def statistic_type
    statistic ? statistic.statistic_type : nil
  end

  def statistic_type_code
    statistic ? statistic.statistic_type.code : 'N/A'
  end

  # TODO - The below three can be refactored elsewhere and removed
  def obj
    discrepant_object
  end

  def quantity
    discrepancy_adjustment == nil ? 'N/A' : discrepancy_adjustment.quantity
  end

  def quantity_should_be
    discrepancy_adjustment == nil ? 'N/A' : discrepancy_adjustment.quantity_should_be
  end
  # ---ENDTODO

  def resolve!
    raise "Abstract: Define in subclass"
  end

  def to_s
    "Discrepancy(#{cti_type}): #{discrepant_object.name}: #{statistic_type_code} {currently: #{quantity}, should_be: #{quantity_should_be}} => #{code_diff}.  Resolved: #{resolved}"
  end

  def code_diff
    return 'N/A' if statistic_type == nil
    # Anything in this list must offset (be taken from one player, added to another)
    must_offset = ['AST', 'BLK', 'STL', 'OREB', 'DREB', 'TOV']
    # So should anything worth points
    counts_for = must_offset.include?(statistic_type.code) ? 1 : statistic_type.points_per
    [statistic_type.code, (quantity - quantity_should_be) * counts_for]
  end
end
