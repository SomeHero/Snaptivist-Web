class AddTargetgroupIdToTargets < ActiveRecord::Migration
  def change
    add_column :targets, :targetgroup_id, :integer
    Target.reset_column_information
    Target.all.each do |t|
      t.update_attribute :targetgroup_id, 2
    end
  end
end
