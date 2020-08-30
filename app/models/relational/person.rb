class Person < Sequel::Model
  plugin :timestamps, update_on_create: true
  one_through_one :team
  many_to_many :positions
  one_to_many :person_in_team_in_seasons

  include StatisticConcern

  def all_statistics
    person_in_team_in_seasons.map(&:all_statistics).flatten
  end

  def onmt_h
    {
      'FULL-NAME'   => name,
      'FIRST-NAME'  => first_name,
      'LAST-NAME'   => last_name,
    }.map{|k,v| [k,v.gsub(/\s+/,'_')] }.to_h
  end

  def onmt_name
    name
  end

  def self.all_named_entities
    Person.map{|person| [person.first_name, person.last_name] }.flatten
  end

  def self.format_name n
    return '' if n == nil
    ['Jr', 'Sr'].each { |suffix| n.gsub!(suffix, '') }
    
    arr = []
    n.split.each do |seg|
      seg.gsub!('.','')
      # TODO - Handle all roman numerals with regex
      arr << seg unless ['II', 'III'].include? seg 
    end
    I18n.transliterate(arr.join(' ')).strip
  end

  def self.split_person_name person_name
    person_names = person_name.split(',')
    return person_names[1], person_names[0]
  end

  def self.find_or_create_person person_name, url_seg
    first_name, last_name  = Person.split_person_name(person_name)
    n = "#{first_name} #{last_name}"
    person = Person.find(url_seg: url_seg)
    return person if person
    Person.create(url_seg: url_seg, name: n, first_name: first_name, last_name: last_name)
  end

  def to_s
    name
  end
end
