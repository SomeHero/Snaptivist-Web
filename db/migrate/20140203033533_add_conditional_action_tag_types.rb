class AddConditionalActionTagTypes < ActiveRecord::Migration
  def up
	petition_facebook_signature_conditional_action_tag = ConditionalActionTagType.create!(
		name: "Sign With Facebook Conditional Action",
		label: "Add the following action tags to an action taker when they sign my petition with Facebook",
		event_trigger: "signature_method == 'Facebook'"
	)
	petition_email_signature_conditional_action_tag = ConditionalActionTagType.create!(
		name: "Sign With Email Address Conditional Action",
		label: "Add the following action tags to an action taker when they sign my petition with an email address",
		event_trigger: "signature_method == 'Email'"
	)

  end

  def down
  	EmailType.delete_all
  end
end
