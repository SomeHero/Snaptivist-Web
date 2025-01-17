ActiveAdmin.register Signature do
     config.filters = false
     menu :parent => "Petitions"

     csv do
     	column :id
     	column("First Name") { |signature| signature.user.first_name }
		column("Last Name") { |signature| signature.user.last_name }
		column("Email Address") { |signature| signature.user.email }
		column :signature_method
		column :comment
		column :shared
		column :shared_at
		column :delivered
		column :delivered_at
		column :latitude
		column :longitude
		column :city
		column :state
		column :zip_code
		column :country
		column :opt_in
		column("Tags") { |signature| signature.user.action_tags }
		column :created_at
		column :updated_at
		
	end
end
