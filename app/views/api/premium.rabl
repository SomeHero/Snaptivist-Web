object @premium
attributes :id

child :user do
	attributes :id,
		:first_name,
		:last_name,
		:email
end
child :mailing_address do
	attributes :id,
		:fist_name,
		:last_name,
		:street_address_1,
		:street_address_2,
		:city,
		:state,
		:zip_code,
		:phone_number,
		:email_address
end