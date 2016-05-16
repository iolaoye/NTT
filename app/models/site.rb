class Site < ActiveRecord::Base
  attr_accessible :apm, :co2x, :cqnx, :elev, :fir0, :rfnx, :unr, :upr, :xlog, :ylat
  #Associations
    belongs_to :field
end
