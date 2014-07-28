class RemoveDeviseFromClients < ActiveRecord::Migration
  def up
  	remove_column :clients, :email
  	remove_column :clients, :encrypted_password
  	remove_column :clients, :reset_password_token
  	remove_column :clients, :reset_password_sent_at 
  	remove_column :clients, :remember_created_at
  	remove_column :clients, :sign_in_count
  	remove_column :clients, :current_sign_in_at
  	remove_column :clients, :last_sign_in_at 
  	remove_column :clients, :current_sign_in_ip
  	remove_column :clients, :last_sign_in_ip
  end

  def down
  	add_column :clients, :email
  	add_column :clients, :encrypted_password
  	add_column :clients, :reset_password_token
  	add_column :clients, :reset_password_sent_at 
  	add_column :clients, :remember_created_at
  	add_column :clients, :sign_in_count
  	add_column :clients, :current_sign_in_at
  	add_column :clients, :last_sign_in_at 
  	add_column :clients, :current_sign_in_ip
  	add_column :clients, :last_sign_in_ip
  end
end
