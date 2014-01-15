object @signature
attributes :id,
	:comment,
	:city,
	:state,
	:zip_code,
	:created_at,
	:updated_at,
	:signature_method

child :user do
	attributes :id,
		:first_name,
		:email,
		:zip_code

	node :last_name do |user|
		user.last_name[0,1]
	end
end

child :tweet do
	attributes :id,
		:message,
		:created_at,
		:updated_at
end