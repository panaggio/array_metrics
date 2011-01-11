require File.join(File.dirname(__FILE__), "../spec_helper.rb")

describe ArrayMetrics do
  arrays = [[1,2,3], [1,0,-1,nil,1000]]
  opposite_pairs = [
    [[1,2,3],[3,2,1]], [[1,2,3],[7,5,3]],
    [[1,10,1,10,1],[-3,-30,-3,-30,-3]] ]
  non_correlated_pairs = [ [[1,2,3],[1,2,1]] ]
  generic_cases = [
    [[1,2,3], [1,2,6],    5.0/Math.sqrt(2*14), 2,   5.0/Math.sqrt(2*17)],
    [[1,2,3], [1,6,-1],  -2.0/Math.sqrt(2*26), 2,  -2.0/Math.sqrt(2*26)],
    [[1,2,6], [1,6,-1], -11.0/Math.sqrt(14*26),3, -11.0/Math.sqrt(14*29)] ]

  describe "#pearson_correlation" do
    it "should return NaN when arrays have size less or equal to one" do
      result = ArrayMetrics.pearson_correlation([],[])
      result.should be_nan

      result = ArrayMetrics.pearson_correlation([5],[1])
      result.should be_nan
    end

    it "should return NaN when arrays have size less or equal to one, even after removing nils" do
      result = ArrayMetrics.pearson_correlation([nil],[nil])
      result.should be_nan

      result = ArrayMetrics.pearson_correlation([nil,nil],[nil,nil])
      result.should be_nan

      result = ArrayMetrics.pearson_correlation([nil,1],[nil,5])
      result.should be_nan
    end

    it "should return NaN when one of the arrays it homogeneous" do
      result = ArrayMetrics.pearson_correlation([1,2,3],[1,1,1])
      result.should be_nan
    end

    it "should raise an error when arrays size don't match" do
      lambda do
        ArrayMetrics.pearson_correlation([1,2],[1])
      end.should raise_error(RuntimeError, "array sizes don't match")

      lambda do
        ArrayMetrics.pearson_correlation([1],[1,2])
      end.should raise_error(RuntimeError, "array sizes don't match")
    end

    it "should return 1 when arrays are the same" do
      arrays.each do |arr|
        result = ArrayMetrics.pearson_correlation(arr,arr)
        result.should == 1.0
      end
    end

    it "should return -1 when arrays are the opposite from each other" do
      arrays.each do |arr|
        result = ArrayMetrics.pearson_correlation(arr,-arr)
        result.should == -1.0
      end

      opposite_pairs.each do |arr1, arr2|
        result = ArrayMetrics.pearson_correlation(arr1,arr2)
        result.should == -1.0
      end
    end

    it "should return 0 if arrays are not correlated" do
      non_correlated_pairs.each do |arr1, arr2|
        result = ArrayMetrics.pearson_correlation(arr1,arr2)
        result.should == 0.0
      end
    end

    it "should calculate generic cases correctly" do
      generic_cases.each do |arr1, arr2, response, _, _|
        result = ArrayMetrics.pearson_correlation(arr1,arr2)
        result.should be_within(0.0001).of(response)
      end
    end

    it "should return the same value if arrays are switched (commutative property)" do
      generic_cases.each do |arr1, arr2, response, _, _|
        result = ArrayMetrics.pearson_correlation(arr2,arr1)
        result.should be_within(0.0001).of(response)
      end
    end

    it "should return the same value if a constant is added to the arrays" do
      generic_cases.each do |arr1, arr2, response, _, _|
        result = ArrayMetrics.pearson_correlation(
          arr1.map{|e| e+1},arr2.map{|e| e+1})
          result.should be_within(0.0001).of(response)
      end
    end

    it "should use only positions that are both not nil in both arrays" do
      r1 = ArrayMetrics.pearson_correlation([1,2,nil,5,nil,4], [1,nil,3,4,nil,3])
      r2 = ArrayMetrics.pearson_correlation([1,5,4], [1,4,3])
      r1.should be_within(0.0001).of(r2)
    end
  end

  describe "#constraint_pearson_correlation" do
    it "should return NaN when arrays have size equal to zero" do
      result = ArrayMetrics.constraint_pearson_correlation([],[],3)
      result.should be_nan
    end

    it "should return only 1, -1 or NaN when arrays have size equal to one" do
      result = ArrayMetrics.constraint_pearson_correlation([5],[1],3)
      result.should == -1.0

      result = ArrayMetrics.constraint_pearson_correlation([1],[2],3)
      result.should == 1.0

      result = ArrayMetrics.constraint_pearson_correlation([2],[2],2)
      result.should be_nan
    end

    it "should return NaN when arrays have size equal to one, even after removing nils" do
      result = ArrayMetrics.constraint_pearson_correlation([nil],[nil],2)
      result.should be_nan

      result = ArrayMetrics.constraint_pearson_correlation([nil,nil],[nil,nil],3)
      result.should be_nan
    end

    it "should return NaN when one of the arrays is homogeneous and its mean equals to m" do
      result = ArrayMetrics.constraint_pearson_correlation([1,2,3],[1,1,1],1)
      result.should be_nan
    end

    it "should raise an error when arrays size don't match" do
      lambda do
        ArrayMetrics.constraint_pearson_correlation([1,2],[1],3)
      end.should raise_error(RuntimeError, "array sizes don't match")

      lambda do
        ArrayMetrics.constraint_pearson_correlation([1],[1,2],3)
      end.should raise_error(RuntimeError, "array sizes don't match")
    end

    it "should return 1 when arrays are the same, even with different m's" do
      arrays.each do |arr|
        (0..10).to_a.each do |m|
          result = ArrayMetrics.constraint_pearson_correlation(arr,arr,m)
          result.should == 1.0
        end
      end
    end

    it "should return -1 when arrays are the opposite from each, using m as the mean" do
      result = ArrayMetrics.constraint_pearson_correlation([1,2,3],[3,2,1],2)
      result.should == -1.0
    end

    it "should return 0 if arrays are not correlated" do
      result = ArrayMetrics.constraint_pearson_correlation([1,2,3],[1,2,1],2)
      result.should == 0.0
    end

    it "should calculate generic cases correctly" do
      generic_cases.each do |arr1, arr2, _, m, response|
        result = ArrayMetrics.constraint_pearson_correlation(arr1,arr2,m)
        result.should be_within(0.0001).of(response)
      end
    end

    it "should return the same value if arrays are switched (commutative property)" do
      generic_cases.each do |arr1, arr2, _, m, response|
        result = ArrayMetrics.constraint_pearson_correlation(arr2,arr1,m)
        result.should be_within(0.0001).of(response)
      end
    end

    it "should return the same value if a constant is added to the arrays" do
      generic_cases.each do |arr1, arr2, _, m, response|
        result = ArrayMetrics.constraint_pearson_correlation(
          arr1.map{|e| e+1},arr2.map{|e| e+1},m+1)
          result.should be_within(0.0001).of(response)
      end
    end

    it "should use only positions that are both not nil in both arrays" do
      r1 = ArrayMetrics.constraint_pearson_correlation(
        [1,2,nil,5,nil,4], [1,nil,3,4,nil,3],3)
      r2 = ArrayMetrics.constraint_pearson_correlation(
        [1,5,4], [1,4,3],3)
      r1.should be_within(0.0001).of(r2)
    end
  end
end

