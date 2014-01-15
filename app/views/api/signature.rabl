object @signature
attributes :id,
	:comment,
	:city,
	:state,
	:zip_code,
	:created_at,
	:updated_at,
	:signature_method

child :user do |user|
	attributes :id,
		:first_name,
		:email,
		:zip_code
	node :last_name do
		if user && user.last_name
			user.last_name[0,1]
		else
			""
		end
	end

end
