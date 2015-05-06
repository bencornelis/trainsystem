require "spec_helper"

describe(Train) do
  describe("#==") do
    it("returns true for objects that have same line and id") do
      train1 = Train.new({:line => 'blue', :id => nil})
      train2 = Train.new({:line => 'blue', :id => nil})
      expect(train1.==(train2)).to(eq(true))
    end
  end
end
