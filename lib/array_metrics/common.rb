NaN = 0.0/0

class Array
  def mean
    return 0.0 if size==0
    self.inject(0.0){|sum,e| sum+e}.to_f/self.size
  end

  def -@
    self.map{ |e| if e.nil? then e else -e end }
  end
end
