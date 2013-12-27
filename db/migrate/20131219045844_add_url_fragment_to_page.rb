class AddUrlFragmentToPage < ActiveRecord::Migration
  def change
  	add_column :pages, :url_fragment, :string
  end
end
