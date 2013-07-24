ActiveAdmin.register Signature do
     menu :parent => "Petitions"

     csv do
     	column("First Name") { |signature| signature.user.first_name }
		column("Last Name") { |signature| signature.user.last_name }
		column("Email Address") { |signature| signature.user.email }
		column :comment
		column :created_at
		column :updated_at
		column :delivered
		column :delivered_at
		column :latitude
		column :longitude
		column :city
		column :state
		column :zip_code
		column :country
		column :opt_in
	end
end
