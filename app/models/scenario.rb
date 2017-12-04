class Scenario < ActiveRecord::Base
  attr_accessible :name, :field_id
  #associations
	  has_many :operations, :dependent => :destroy
	  has_many :bmps, :dependent => :destroy
	  has_many :results, :dependent => :destroy
	  has_many :subareas, :dependent => :destroy
	  has_many :soil_operations, :dependent => :destroy
	  has_many :charts, :dependent => :destroy
	  has_many :aplcat_parameters, :dependent => :destroy
	  has_many :grazing_parameters, :dependent => :destroy
	  has_many :supplement_parameters, :dependent => :destroy
	  has_many :watershed_scenarios, :dependent => :destroy
	  belongs_to :field
  #validations
     validates_uniqueness_of :name, :scope => :field_id
	 validates_presence_of :name, :message => "Scenario Name needed"

	 def planting_operations(rotation)
	 	self.operations.where(:activity_id => 1, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	 def fertilizer_operations(rotation)
	 	self.operations.where(:activity_id => 2, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	 def tillage_operations(rotation)
	 	self.operations.where(:activity_id => 3, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	 def harvest_operations(rotation)
	 	self.operations.where(:activity_id => 4, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	 def kill_operations(rotation)
	 	self.operations.where(:activity_id => 5, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	 def irrigation_operations(rotation)
	 	self.operations.where(:activity_id => 6, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	def continuous_grazing_operations(rotation)
		self.operations.where(:activity_id => 7, :crop_id => rotation.crop_id, :rotation => rotation.rotation) + self.operations.where(:activity_id => 8, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	end

	def rotational_grazing_operations(rotation)
		self.operations.where(:activity_id => 9, :crop_id => rotation.crop_id, :rotation => rotation.rotation) + self.operations.where(:activity_id => 10, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	end

	 def burn_operations(rotation)
	 	self.operations.where(:activity_id => 11, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

	 def liming_operations(rotation)
	 	self.operations.where(:activity_id => 12, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

   #def cover_crop_id_operations(rotation)
     #self.operations.where(:activity_id => 13, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
   #end

   #Unused code. Remove method reference in /operations/index.html.erb?
	 def pesticide_operations(rotation)
 	  self.operations.where(:activity_id => 100, :crop_id => rotation.crop_id, :rotation => rotation.rotation)
	 end

end
