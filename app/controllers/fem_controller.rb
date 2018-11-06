class FemController < ApplicationController
  def list
    @feeds = FeedsAugmented.all
    @equipment = MachineAugmented.all
    @structure = FacilityAugmented.all
    @other = FarmGeneral.all
  end 
end

