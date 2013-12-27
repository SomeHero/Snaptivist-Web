class AddDefaultSubjectToEmailTypes < ActiveRecord::Migration
  def change
  	add_column :email_types, :default_subject, :string
  end
end
