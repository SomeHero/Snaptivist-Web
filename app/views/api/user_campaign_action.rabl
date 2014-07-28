object @user_campaign_action


node do |a|

	if a.type == "UserCampaignSignatureAction"
	    partial "user_campaign_signature_action", :object => a
	 elsif a.type == "UserCampaignVoteAction"
	    partial "user_campaign_vote_action", :object => a
	 else
	    partial "user_campaign_base_action", :object => a
	 end

end
