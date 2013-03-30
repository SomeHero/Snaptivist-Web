ActiveAdmin.register Petition do
  	index do
		selectable_column
		column :id
		column :title
		column :short_url
		column :rewrite_url_key
		column :created_at
		column :updated_at
		column :signatures_count
	end

end
