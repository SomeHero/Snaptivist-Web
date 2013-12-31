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
		:last_name,
		:email,
		:zip_code
end

child :tweet do
	attributes :id,
		:message,
		:created_at,
		:updated_at
end