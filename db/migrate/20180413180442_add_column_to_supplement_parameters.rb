class AddColumnToSupplementParameters < ActiveRecord::Migration[5.2]
  def change
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :dmi_rheifers)) 
        add_column :supplement_parameters, :dmi_rheifers, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :starting_julian_day)) 
        add_column :supplement_parameters, :starting_julian_day, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :ending_julian_day)) 
        add_column :supplement_parameters, :ending_julian_day, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :for_dmi_cows)) 
        add_column :supplement_parameters, :for_dmi_cows, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :for_dmi_bulls)) 
        add_column :supplement_parameters, :for_dmi_bulls, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :for_dmi_calves)) 
        add_column :supplement_parameters, :for_dmi_calves, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :for_dmi_heifers)) 
        add_column :supplement_parameters, :for_dmi_heifers, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :for_dmi_rheifers)) 
        add_column :supplement_parameters, :for_dmi_rheifers, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :green_water_footprint_supplement)) 
        add_column :supplement_parameters, :green_water_footprint_supplement, :float
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :for_button)) 
        add_column :supplement_parameters, :for_button, :integer
    end
    if !(ActiveRecord::Base.connection.column_exists?(:supplement_parameters, :supplement_button)) 
        add_column :supplement_parameters, :supplement_button, :integer
    end
  end
end

