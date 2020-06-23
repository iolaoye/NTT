class AddColumnStateAbbreviationToState < ActiveRecord::Migration[5.2]
  def change
    add_column :states, :state_abbreviation, :string
  end
end
