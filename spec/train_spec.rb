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
end
