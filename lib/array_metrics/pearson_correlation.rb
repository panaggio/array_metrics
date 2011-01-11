module ArrayMetrics
  # Calculates the Constraint Pearson Correlation between Arrays x and y.
  # See Shardanand and Maes 1995 for more details.
  #
  # Shardanand, U. and Maes, P. Social information filtering: algorithms for
  # automating "word of mouth". In Proceedings of the SIGCHI conference on
  # Human factors in computing systems (CHI '95). ACM Press/Addison-Wesley
  # Publishing Co., New York, NY, USA, 210-217.
  # DOI=10.1145/223904.223931 http://dx.doi.org/10.1145/223904.223931
  def self.constraint_pearson_correlation(x, y, m)
    raise "array sizes don't match" if x.size != y.size

    cx, cy = [], []
    x.each_with_index do |xi, i|
      next if xi.nil? or y[i].nil?
      cx << xi
      cy << y[i]
    end

    return NaN if cx.size == 0

    s = sx = sy = 0.0
    if m.nil?
      cx_ = cx.mean
      cy_ = cy.mean
    else
      cx_ = cy_ = m
    end

    cx.each_with_index do |cxi,i|
      px = cxi-cx_
      py = cy[i]-cy_
      s  += px*py
      sx += px*px
      sy += py*py
    end

    s/Math.sqrt(sx*sy)
  end

  # Calculates the Pearson Correlation between the Arrays x and x.
  # See https://secure.wikimedia.org/wikipedia/en/wiki/Pearson_correlation
  # for more details.
  def self.pearson_correlation(x,y)
    self.constraint_pearson_correlation(x,y,nil)
  end
end
