class AddColumnToAplcatParameters < ActiveRecord::Migration
  def change
    #add_column :aplcat_parameters, :abwrh, :float
    #add_column :aplcat_parameters, :nocrh, :integer
    #add_column :aplcat_parameters, :abc, :integer
    #add_column :aplcat_parameters, :forage_id, :integer
    add_column :aplcat_parameters, :jincrease, :integer
    add_column :aplcat_parameters, :stabilization, :integer
    add_column :aplcat_parameters, :decline, :integer
    add_column :aplcat_parameters, :opt4, :integer
    add_column :aplcat_parameters, :crude_low, :float
    add_column :aplcat_parameters, :crude_high, :float
    add_column :aplcat_parameters, :tdn_low, :float
    add_column :aplcat_parameters, :tdn_high, :float
    add_column :aplcat_parameters, :ndf_low, :float
    add_column :aplcat_parameters, :ndf_high, :float
    add_column :aplcat_parameters, :adf_low, :float
    add_column :aplcat_parameters, :adf_high, :float
    add_column :aplcat_parameters, :feed_low, :float
    add_column :aplcat_parameters, :feed_high, :float
    add_column :aplcat_parameters, :tripn, :integer
    add_column :aplcat_parameters, :freqtrip, :integer
    add_column :aplcat_parameters, :filedetails, :string
    add_column :aplcat_parameters, :cattlepro, :integer
    add_column :aplcat_parameters, :purpose, :string
    add_column :aplcat_parameters, :codepurpose, :integer
    add_column :aplcat_parameters, :mdogfc, :integer
    add_column :aplcat_parameters, :mxdogfc, :integer
    add_column :aplcat_parameters, :cwsoj, :integer
    add_column :aplcat_parameters, :cweoj, :integer
    add_column :aplcat_parameters, :ewc, :integer
    add_column :aplcat_parameters, :nodew, :integer
    add_column :aplcat_parameters, :byosm, :integer
    add_column :aplcat_parameters, :eyosm, :integer
    add_column :aplcat_parameters, :mrgauh, :float
    add_column :aplcat_parameters, :plac, :integer
    add_column :aplcat_parameters, :pcbb, :integer
    add_column :aplcat_parameters, :domd, :integer
    add_column :aplcat_parameters, :faueea, :float
    add_column :aplcat_parameters, :acim, :float
    add_column :aplcat_parameters, :mmppm, :float
    add_column :aplcat_parameters, :cffm, :float
    add_column :aplcat_parameters, :fnemm, :float
    add_column :aplcat_parameters, :effd, :float
    add_column :aplcat_parameters, :ptbd, :float
    add_column :aplcat_parameters, :pocib, :float
    add_column :aplcat_parameters, :bneap, :float
    add_column :aplcat_parameters, :cneap, :float
    add_column :aplcat_parameters, :hneap, :float
    add_column :aplcat_parameters, :pobw, :float
    add_column :aplcat_parameters, :posw, :float
    add_column :aplcat_parameters, :posb, :float
    add_column :aplcat_parameters, :poad, :float
    add_column :aplcat_parameters, :poada, :float
    add_column :aplcat_parameters, :cibo, :float
    add_column :aplcat_parameters, :drinkg, :float
    add_column :aplcat_parameters, :drinkl, :float
    add_column :aplcat_parameters, :drinkm, :float
    add_column :aplcat_parameters, :avgtm, :float
    add_column :aplcat_parameters, :avghm, :float
    add_column :aplcat_parameters, :rhae, :float
    add_column :aplcat_parameters, :tabo, :float
    add_column :aplcat_parameters, :mpism, :float
    add_column :aplcat_parameters, :spilm, :float
    add_column :aplcat_parameters, :pom, :float
    add_column :aplcat_parameters, :srinr, :float
    add_column :aplcat_parameters, :sriip, :float
    add_column :aplcat_parameters, :pogu, :float
    add_column :aplcat_parameters, :adoa, :float
    add_column :aplcat_parameters, :ape, :float
  end
end
