require "spec_helper"

describe(Train) do
  describe("#==") do
    it("returns true for objects that have same line and id") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train2 = Train.new({:line => 'blue', :id => nil})
      expect(train1.==(train2)).to(eq(true))
    end
  end

  describe("#save") do
    it("add the train to the trains table") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      expect(Train.all()).to(eq([train1]))
    end
  end

  describe(".find") do
    it("returns a train with the given id") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      expect(Train.find(train1.id)).to(eq(train1))
    end
  end

  describe("#delete") do
    it("deletes a train from the trains table") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      train2 = Train.new({:line => 'red', :id => nil})
      train2.save()
      train1.delete()
      expect(Train.all()).to(eq([train2]))
    end

    it("deletes all of the train's stops") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      train1.add_stop(city1.id, "12:30:00")
      train1.delete()
      expect(train1.stops()).to(eq([]))
    end
  end

  describe("#update") do
    it("updates the train object's line") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      train1.update({:line => 'red'})
      expect(train1.line()).to(eq('red'))
    end

    it("updates the train in the database") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      train1.update({:line => 'red'})
      updated_train1 = Train.find(train1.id)
      expect(updated_train1.line).to(eq('red'))
    end
  end

  describe("#add_stop") do
    it("adds a city at a given time to a trains stops") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train1.save()
      city1 = City.new({:name => 'Portland', :id => nil})
      city1.save()
      train1.add_stop(city1.id, "12:30:00")
      expect(train1.stops()).to(eq([{:city => city1, :time => "12:30:00"}]))
    end
  end
end
