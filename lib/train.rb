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
    #update/edit
  end

  def delete
    #delete
  end

  def self.find(train_id)
    #find train to change info
  end
end
