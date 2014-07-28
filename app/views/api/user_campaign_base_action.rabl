object @user_campaign_action
attributes :id,
	:type,
	:created_at,
	:updated_at

child :user do |user|
	attributes :id,
		:first_name,
		:last_name,
		:zip_code
end