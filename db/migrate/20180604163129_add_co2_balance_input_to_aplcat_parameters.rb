class AddCo2BalanceInputToAplcatParameters < ActiveRecord::Migration
  def change
    add_column :aplcat_parameters, :n_tfa, :integer
    add_column :aplcat_parameters, :n_sr, :float
    add_column :aplcat_parameters, :n_arnfa, :integer
    add_column :aplcat_parameters, :n_arpfa, :integer
    add_column :aplcat_parameters, :n_nfar, :float
    add_column :aplcat_parameters, :n_npfar, :integer
    add_column :aplcat_parameters, :n_co2enfa, :float
    add_column :aplcat_parameters, :n_co2epfp, :integer
    add_column :aplcat_parameters, :n_co2enfp, :float
    add_column :aplcat_parameters, :n_lamf, :integer
    add_column :aplcat_parameters, :n_lan2of, :integer
    add_column :aplcat_parameters, :n_laco2f, :float
    add_column :aplcat_parameters, :n_socc, :integer
    add_column :aplcat_parameters, :i_tfa, :integer
    add_column :aplcat_parameters, :i_sr, :float
    add_column :aplcat_parameters, :i_arnfa, :integer
    add_column :aplcat_parameters, :i_arpfa, :integer
    add_column :aplcat_parameters, :i_nfar, :float
    add_column :aplcat_parameters, :i_npfar, :integer
    add_column :aplcat_parameters, :i_co2enfa, :float
    add_column :aplcat_parameters, :i_co2epfp, :integer
    add_column :aplcat_parameters, :i_co2enfp, :float
    add_column :aplcat_parameters, :i_lamf, :integer
    add_column :aplcat_parameters, :i_lan2of, :integer
    add_column :aplcat_parameters, :i_laco2f, :float
    add_column :aplcat_parameters, :i_socc, :integer
  end
end
