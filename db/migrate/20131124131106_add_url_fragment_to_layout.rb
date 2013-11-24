class AddUrlFragmentToLayout < ActiveRecord::Migration
  def change
  	add_column :layouts, :url_fragment, :string
  end
end
