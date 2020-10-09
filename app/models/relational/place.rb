class Place < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_through_one :parent,  left_key:  :child_id, right_key:  :parent_id, join_table: :places_in_places, class: self
  many_to_many :children,   right_key: :child_id, left_key:   :parent_id, join_table: :places_in_places, class: self
  one_to_many  :stadia
  many_to_many :team_in_seasons
  many_to_many :teams
  many_to_one  :place_type

  def to_s
    name
  end

  def sett_names
    arr = [name]
    arr += parent.sett_names if parent
    arr
  end

  def all_parents
    [self.name] + parent.all_parents
  end

  def onmt_h
    h = PlaceType.map{ |pt| [pt.name.upcase, 'N/A'] }.to_h
    current_place = self
    while current_place do
      h[current_place.place_type.name.upcase] = current_place.name
      current_place = current_place.parent
    end
    h
  end

  def onmt_name
    name
  end

  def self.all_named_entities
    Place.map{|place| place.name }
  end
end
