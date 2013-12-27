class AddUrlRedirectUrlRedirectPropertyToPage < ActiveRecord::Migration
  def change
 	add_column :pages, :url_redirect, :boolean, :default => false
 	add_column :pages, :url_redirect_property, :string
  end
end
