class AddStateRelationshipToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :state_information_id, :integer
  end
end
