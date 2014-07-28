object false

node :total	do
	@total
end

node :results do |s|
	partial('user_campaign_action', :object => @user_campaign_actions)
end
	
