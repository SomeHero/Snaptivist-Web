class AddOptInToSignature < ActiveRecord::Migration
  def change
  	add_column :signatures, :opt_in, :boolean
  end
end
