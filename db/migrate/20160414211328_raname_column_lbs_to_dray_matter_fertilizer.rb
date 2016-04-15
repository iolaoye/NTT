class RanameColumnLbsToDrayMatterFertilizer < ActiveRecord::Migration
  def change
	rename_column :fertilizers, :lbs, :dry_matter
  end
end
