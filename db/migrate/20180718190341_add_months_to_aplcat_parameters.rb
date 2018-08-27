class AddMonthsToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :tjan, :float
    add_column :aplcat_parameters, :tfeb, :float
    add_column :aplcat_parameters, :tmar, :float
    add_column :aplcat_parameters, :tapr, :float
    add_column :aplcat_parameters, :tmay, :float
    add_column :aplcat_parameters, :tjun, :float
    add_column :aplcat_parameters, :tjul, :float
    add_column :aplcat_parameters, :taug, :float
    add_column :aplcat_parameters, :tsep, :float
    add_column :aplcat_parameters, :toct, :float
    add_column :aplcat_parameters, :tnov, :float
    add_column :aplcat_parameters, :tdec, :float
    add_column :aplcat_parameters, :hjan, :float
    add_column :aplcat_parameters, :hfeb, :float
    add_column :aplcat_parameters, :hmar, :float
    add_column :aplcat_parameters, :hapr, :float
    add_column :aplcat_parameters, :hjun, :float
    add_column :aplcat_parameters, :hmay, :float
    add_column :aplcat_parameters, :hjul, :float
    add_column :aplcat_parameters, :haug, :float
    add_column :aplcat_parameters, :hsep, :float
    add_column :aplcat_parameters, :hoct, :float
    add_column :aplcat_parameters, :hnov, :float
    add_column :aplcat_parameters, :hdec, :float
  end
end
