class City
  attr_reader :name, :id

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def ==(other_city)
    same_name = @name.eql?(other_city.name)
    same_id = @id.eql?(other_city.id)
    same_name.&(same_id)
  end

  def save
    result = DB.exec("INSERT INTO cities (name) VALUES ('#{@name}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def self.all
    cities = []
    results = DB.exec("SELECT * FROM cities;")
    results.each() do |result|
      name = result.fetch("name")
      id = result.fetch("id").to_i
      city = City.new({:name => name, :id => id})
      cities.push(city)
    end
    cities
  end

  def update(attributes)
    @name = attributes.fetch(:name)
    DB.exec("UPDATE cities SET name = '#{@name}' WHERE id = #{@id};")
  end


  def delete
    DB.exec("DELETE FROM cities WHERE id = #{@id};")
  end

  def self.find(city_id)
    result = DB.exec("SELECT * FROM cities WHERE id = #{city_id};")
    name = result.first.fetch("name")
    id = result.first.fetch("id").to_i
    City.new({:name => name, :id => id})
  end

  def add_stop(train_id, time)
    DB.exec("INSERT INTO stops (city_id, train_id, time) VALUES (#{@id}, #{train_id}, '#{time}');")
  end

  def stops
    results = DB.exec("SELECT * FROM stops WHERE city_id = #{@id};")
    stops = []
    results.each() do |result|
      train_id = result.fetch("train_id").to_i
      train = Train.find(train_id)
      time = result.fetch("time")
      stops.push({:train => train, :time => time})
    end
    stops
  end
end
