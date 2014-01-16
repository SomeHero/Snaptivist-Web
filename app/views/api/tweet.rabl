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
		:email,
		:zip_code,
		:avatar_url

	node :first_name do
		if user && user.first_name
			user.first_name
		else
			"Anonymous"
		end
	end

	node :last_name do
		if user && user.last_name
			user.last_name[0,1]
		else
			""
		end
	end

end

child :tweet do
	attributes :id,
		:message,
		:created_at,
		:updated_at
end