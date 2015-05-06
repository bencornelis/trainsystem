class Train
  attr_reader :line, :id

  def initialize(attributes)
    @line = attributes.fetch(:line)
    @id = attributes.fetch(:id)
  end

  def ==(other_train)
    same_line = @line.eql?(other_train.line)
    same_id = @id.eql?(other_train.id)
    same_line.&(same_id)
  end

  def save
    result = DB.exec("INSERT INTO trains (line) VALUES ('#{@line}') RETURNING id;")
    @id = result.first.fetch("id").to_i
  end

  def self.all
    trains = []
    results = DB.exec("SELECT * FROM trains;")
    results.each() do |result|
      line = result.fetch("line")
      id = result.fetch("id").to_i
      train = Train.new({:line => line, :id => id})
      trains.push(train)
    end
    trains
  end

  def update(attributes)
    @line = attributes.fetch(:line)
    DB.exec("UPDATE trains SET line = '#{@line}' WHERE id = #{@id};")
  end

  def delete
    DB.exec("DELETE FROM trains WHERE id = #{@id};")
  end

  def self.find(train_id)
    result = DB.exec("SELECT * FROM trains WHERE id = #{train_id};")
    line = result.first.fetch("line")
    id = result.first.fetch("id").to_i
    Train.new({:line => line, :id => id})
  end

  def add_stop(city_id)
    DB.exec("INSERT INTO stops (city_id, train_id) VALUES (#{city_id}, #{@id});")
  end

  def stops
    city_ids = DB.exec("SELECT (city_id) FROM stops WHERE train_id = #{@id};")
    cities = []
    city_ids.each() do |city_id|
      city_id = city_id.fetch("city_id").to_i
      city = City.find(city_id)
      cities.push(city)
    end
    cities
  end
end
