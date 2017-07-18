class Drainage < ActiveRecord::Base
  attr_accessible :drainage_id, :name, :wtbl, :wtmn, :wtmx, :zqt, :ztk
  self.primary_key = "drainage_id"
end
