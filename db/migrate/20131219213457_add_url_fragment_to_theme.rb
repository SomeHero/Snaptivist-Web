class AddUrlFragmentToTheme < ActiveRecord::Migration
  def change
  	add_column :themes, :url_fragment, :string
  end
end
