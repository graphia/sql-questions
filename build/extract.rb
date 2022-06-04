require "csv"
require "pry"

output = []

Q = Struct.new(:raw_value, :quotable) do
  def value
    raw_value == 'NA' ? 'null' : raw_value
  end

  def quotable?
    quotable
  end
end

class Insertable
  def data
    "(" + quoted_values.join(", ") + ")"
  end
  
  def quoted_values
    values.map do |qv|
      if qv.value == 'null'
        'null'
      elsif qv.quotable
        %($$#{qv.value}$$)
      else
        qv.value
      end
    end
  end
end

class Country < Insertable
  attr_reader :code, :name, :alternative_name

  def initialize(code, name, alternative_name)
    @code, @name, @alternative_name = code, name, alternative_name
  end

  def values
    [
      Q.new(code, true),
      Q.new(name, true),
      (
        if alternative_name
          Q.new(alternative_name, true)
        else
          Q.new("null", false)
        end
      )
    ].compact
  end
end

class Athlete < Insertable
  attr_reader :id, :name, :sex, :height, :weight

  def initialize(id, name, sex, height, weight)
    @id     = id
    @name   = name
    @sex    = sex
    @height = height
    @weight = weight
  end

  def values
    [Q.new(id, false), Q.new(name, true), Q.new(sex, true), Q.new(height, false), Q.new(weight, false)]
  end
end

class Games < Insertable
  attr_reader :code, :name, :year, :season, :city

  def initialize(code, name, year, season, city)
    @code   = code
    @name   = name
    @year   = year
    @season = season
    @city   = city
  end

  def values
    [Q.new(code, true), Q.new(name, true), Q.new(year, false), Q.new(season, true), Q.new(city, true)]
  end
end

class Sport < Insertable
  attr_reader :id, :name

  def initialize(id, name)
    @id   = id
    @name = name
  end

  def values
    [Q.new(id, false), Q.new(name, true)]
  end
end

class Event < Insertable
  attr_reader :id, :sport_id, :name

  def initialize(id, sport_id, name)
    @id       = id
    @sport_id = sport_id
    @name     = name
  end

  def values
    [Q.new(id, false), Q.new(sport_id, false), Q.new(name, true)]
  end
end

class Appearance < Insertable
  attr_reader :athlete_id, :country_code, :games_code, :event_id, :age, :medal

  def initialize(athlete_id, country_code, games_code, event_id, age, medal)
    @athlete_id   = athlete_id
    @country_code = country_code
    @games_code   = games_code
    @event_id     = event_id
    @age          = age
    @medal        = medal
  end

  def values
    [Q.new(athlete_id, false), Q.new(country_code, true), Q.new(games_code, true), Q.new(event_id, false), Q.new(age, false), Q.new(medal, true)]
  end
end

def prepare(values)
  values.map(&:data).join(",\n")
end

def create_insert(statement, values)
  [statement, values, ";"].join("\n")
end

def extract_sex(v)
  if v == 'M'
    'Male'
  elsif v == 'F'
    'Female'
  end
end

def games_code(year, season)
  "#{year.to_s}-#{season.chars.first}"
end

data = CSV.read("./raw/athlete_events.csv", headers: true)

countries = CSV
  .read("./raw/noc_regions.csv", headers: true)
  .map { |c| Country.new(c["NOC"], c["region"], c["notes"]) }

output << create_insert(<<~SQL.strip, prepare(countries))
  insert into country (code, name, alternative_name) values
SQL

athletes = data
  .map { |r| [r['ID'], r['Name'], extract_sex(r['Sex']), r['Height'], r['Weight']] }
  .uniq
  .map { |r| Athlete.new(*r) }

output << create_insert(<<~SQL.strip, prepare(athletes))
  insert into athlete (id, name, sex, height, weight) values
SQL

sports = data.map { |r| r['Sport'] }.uniq.map.with_index(1) { |s, i| [i, s] }.map { |r| Sport.new(*r) }

output << create_insert(<<~SQL.strip, prepare(sports))
  insert into sport (id, name) values
SQL

sports_lookup = sports.each.with_object({}) { |s, h| h[s.name] = s.id }

events = data
  .map { |r| [r['Sport'], r['Event']] }
  .uniq
  .map
  .with_index(1) { |e, i| [i, sports_lookup[e[0]], e[1]] }
  .map { |r| Event.new(*r) }

output << create_insert(<<~SQL.strip, prepare(events))
  insert into event (id, sport_id, name) values
SQL

events_lookup = events.each.with_object({}) { |e, h| h[e.name] = e.id }

games = data
  .map { |r| [games_code(r['Year'], r['Season']), [r['Year'], r['City']].join(" - "), r['Year'], r['Season'], r['City']] }
  .uniq { |r| [r[0]] }
  .map { |r| Games.new(*r) }

output << create_insert(<<~SQL.strip, prepare(games))
  insert into games (code, name, year, season, city) values
SQL

appearances = data
  .map { |r| [r['ID'], r['NOC'], games_code(r['Year'], r['Season']), events_lookup[r['Event']], r['Age'], r['Medal']] }
  .uniq
  .map { |r| Appearance.new(*r) }

output << create_insert(<<~SQL.strip, prepare(appearances))
  insert into appearance (athlete_id, country_code, games_code, event_id, age, medal) values
SQL

File.write("./dml/insert_data.sql", output.join("\n\n"))
