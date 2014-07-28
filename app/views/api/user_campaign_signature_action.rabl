object @user_campaign_action
attributes :id,
	:created_at,
	:updated_at
	node :type do
		"Signature"
	end

child :user do |user|
	attributes :id,
		:first_name,
		:last_name,
		:avatar_url,
		:zip_code
end