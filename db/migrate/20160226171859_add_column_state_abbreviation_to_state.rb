class AddColumnStateAbbreviationToState < ActiveRecord::Migration
  def change
    add_column :states, :state_abbreviation, :string
  end
end
