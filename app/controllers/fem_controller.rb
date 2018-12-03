class FemController < ApplicationController
  def list
    @feeds = FeedsAugmented.all
    @equipment = MachineAugmented.all
    @structure = FacilityAugmented.all
    @other = FarmGeneral.all
  end 

  def update
    #byebug
    feeds = params['feedsData']
    equip = params['equipData']
    other = params['otherData']

    #byebug

    for i in 0..feeds.size-1
        #byebug
        currentFeed = feeds[i.to_s]
        modifiedFeed = FeedsAugmented.where(:name => currentFeed['name'])[0]
        if modifiedFeed != nil
            modifiedFeed.name = currentFeed['name']
            modifiedFeed.selling_price = currentFeed['selling_price']
            modifiedFeed.purchase_price = currentFeed['purchase_price']
            modifiedFeed.concentrate = currentFeed['concentrate']
            modifiedFeed.forage = currentFeed['forage']
            modifiedFeed.grain = currentFeed['grain']
            modifiedFeed.pasture = currentFeed['pasture']
            modifiedFeed.silage = currentFeed['silage']
            modifiedFeed.supplement = currentFeed['supplement']

            modifiedFeed.save()
        end
    end
    for i in 0..equip.size-1
        #byebug
        currentEquip = equip[i.to_s]
        modifiedEquip = MachineAugmented.where(:name => currentEquip['name'])[0]
        if modifiedEquip != nil
            modifiedEquip.name = currentEquip['name']
            modifiedEquip.lease_rate = currentEquip['lease_rate']
            modifiedEquip.new_price = currentEquip['new_price']
            modifiedEquip.new_hours = currentEquip['new_hours']
            modifiedEquip.current_price = currentEquip['current_price']
            modifiedEquip.hours_remaining = currentEquip['hours_remaining']
            modifiedEquip.width = currentEquip['width']
            modifiedEquip.speed = currentEquip['speed']
            modifiedEquip.field_efficiency = currentEquip['field_efficiency']
            modifiedEquip.horse_power = currentEquip['horse_power']
            modifiedEquip.rf1 = currentEquip['rf1']
            modifiedEquip.rf2 = currentEquip['rf2']
            modifiedEquip.ir_loan = currentEquip['ir_loan']
            modifiedEquip.ir_equity = currentEquip['ir_equity']
            modifiedEquip.p_debt = currentEquip['p_debt']
            modifiedEquip.year = currentEquip['year']
            modifiedEquip.rv1 = currentEquip['rv1']
            modifiedEquip.rv2 = currentEquip['rv2']
            modifiedEquip.save()
        end
    end
    for i in 0..other.size - 1
        #byebug
        currentOther = other[i.to_s]
        #byebug
        modifiedOther = FarmGeneral.where(:name => currentOther['name'])[0]

        if modifiedOther != nil
            modifiedOther.name = currentOther['name']
            modifiedOther.save
        end
    end
  end

   respond_to do |format|
       format.html
   end 
end

