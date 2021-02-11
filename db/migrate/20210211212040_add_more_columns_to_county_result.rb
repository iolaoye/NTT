class AddMoreColumnsToCountyResult < ActiveRecord::Migration[5.2]
  def change
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :scenario_id)
    	add_column :county_results, :scenario_id, :integer
	  end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :orgn_ci)
      add_column :county_results, :orgn_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :qn_ci)
      add_column :county_results, :qn_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :no3_ci)
      add_column :county_results, :no3_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :qdrn_ci)
      add_column :county_results, :qdrn_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :po4_ci)
      add_column :county_results, :po4_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :qdrp_ci)
      add_column :county_results, :qdrp_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :surface_flow_ci)
      add_column :county_results, :surface_flow_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :flow_ci)
      add_column :county_results, :flow_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :qdr_ci)
      add_column :county_results, :qdr_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :irri_ci)
      add_column :county_results, :irri_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :dprk_ci)
      add_column :county_results, :dprk_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :sed_ci)
      add_column :county_results, :sed_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :ymnu_ci)
      add_column :county_results, :ymnu_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :co2_ci)
      add_column :county_results, :co2_ci, :float
    end
    if !ActiveRecord::Base.connection.column_exists?(:county_results, :n2o_ci)
      add_column :county_results, :n2o_ci, :float
    end
  end
end
