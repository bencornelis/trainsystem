class Stop
  attr_reader :time, :city_id, :train_id

  def initialize(attributes)
    @time = attributes.fetch(:time)
    @city_id = attributes.fetch(:city_id)
    @train_id = attributes.fetch(:train_id)
  end
end
