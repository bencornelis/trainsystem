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
    #create and assign an id
  end

  def self.all
    #list and read trains
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
