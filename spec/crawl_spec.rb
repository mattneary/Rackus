require './crawl.rb'

describe Rackus, "Rackus#read" do
  it "reads basic strings" do
    Rackus.new(Const 'A').read('A').rest.should eq("")
  end
  it "matches a recursive chain" do
    Rackus.new(Chain 'A').read('AA').rest.should eq("")
  end
end

