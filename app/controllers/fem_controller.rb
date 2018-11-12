class FemController < ApplicationController
  def list
    @feeds = FeedsAugmented.order(:name)
    @equipment = MachineAugmented.order(:name)
    @structure = FacilityAugmented.order(:name)
    @other = FarmGeneral.order(:name)
  end 
end

