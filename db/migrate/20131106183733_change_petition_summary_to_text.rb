class ChangePetitionSummaryToText < ActiveRecord::Migration
  def up
  	change_column :petitions, :summary, :text
  end

  def down
  	change_column :petitions, :summary, :string
  end
end
