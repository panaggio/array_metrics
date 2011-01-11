require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe Array do
  describe "#mean" do
    it "should return 0 when the array is empty" do
      [].mean.should == 0.0
    end

    it "should calculate then mean value correctly" do
      [1,2,3].mean.should == 2.0
      [1,2,3,4,5].mean.should == 3.0
      arr = [0.5,1.3,4.0/3,1.7/3.12]
      arr.mean.should be_within(0.0001).of(arr.inject(0.0){|s,e| s+e}/arr.size)
    end
  end

  describe "#-@" do
    it "should return the same array when there are only nil's" do
      arr = [nil,nil,nil,nil,nil]
      (-arr).should == arr
    end

    it "should return inverted numeric values" do
      (-[1,2,3,-1,-2,-3]).should == [-1,-2,-3,1,2,3]
      (-[1.0,nil,0.0,-1.0]).should == [-1.0,nil,0.0,1.0]
    end
  end
end

