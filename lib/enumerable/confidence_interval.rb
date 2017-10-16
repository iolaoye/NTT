module Enumerable
	def confidence_interval
    #self.standard_deviation / Math.sqrt(self.length - 1) * T_STATISTIC_EVALUATED
    self.standard_deviation / Math.sqrt(self.length) * T_STATISTIC_EVALUATED    # according to Edward dive by average no average-1
	end

	def standard_deviation
       Math.sqrt(self.sample_variance)
    end

	def sample_variance
       m = self.mean
       sum = self.inject(0){|accum, i| accum +(i-m)**2 }
       sum/(self.length - 1).to_f
    end

	def mean
       self.sum/self.length.to_f
    end

	def sum
       self.inject(0){|accum, i| accum + i }
    end

end