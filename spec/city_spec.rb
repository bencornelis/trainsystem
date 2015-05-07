require "spec_helper"


describe(City) do
  describe("#==") do
    it("returns true for objects that have same name and id") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city2 = City.new({:name => 'Portland', :id => nil})
      expect(city1.==(city2)).to(eq(true))
    end
  end

  describe("#save") do
    it("add the city to the cities table") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      expect(City.all()).to(eq([city1]))
    end
  end

  describe(".find") do
    it("returns a city with the given id") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      expect(City.find(city1.id)).to(eq(city1))
    end
  end

  describe("#delete") do
    it("deletes a city from the cities table") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      city2 = City.new({:name => 'red', :id => nil})
      city2.save()
      city1.delete()
      expect(City.all()).to(eq([city2]))
    end
  end

  describe("#update") do
    it("updates the city object's name") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      city1.update({:name => 'Pdx'})
      expect(city1.name()).to(eq('Pdx'))
    end

    it("updates the city in the database") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      city1.update({:name => 'Pdx'})
      updated_city1 = City.find(city1.id)
      expect(updated_city1.name).to(eq('Pdx'))
    end
  end

  describe("#add_stop") do
    it("adds a train at a given time to a city's stops") do
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      city1.add_stop(train1.id, "12:30:00")
      expect(city1.stops()).to(eq([{:train => train1, :time => "12:30:00"}]))
    end
  end

  describe("#stops_by_train") do
    it("returns an array of hashs each containing a train and the times the train stops in this city") do
      city = City.new({:name => 'Berkeley', :id => nil})
      city.save()
      train1 = Train.new({:line => 'Yellow line', :id => nil})
      train1.save()
      train2 = Train.new({:line => 'MAX', :id => nil})
      train2.save()
      city.add_stop(train2.id, "12:31:13")
      city.add_stop(train2.id, "23:13:00")
      expect(city.stops_by_train()).to(eq({train2.id => ["12:31:13", "23:13:00"]}))
    end
  end

end
