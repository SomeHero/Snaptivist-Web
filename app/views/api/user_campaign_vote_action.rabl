object @user_campaign_action
attributes :id,
	:created_at,
	:updated_at
	node :type do
		"Vote"
	end

child :user do |user|
	attributes :id,
		:first_name,
		:last_name,
		:avatar_url,
		:zip_code
end
child :poll_choice do |poll_choice|
	attributes :id,
	:label,
	:position,
	:created_at,
	:updated_at
end