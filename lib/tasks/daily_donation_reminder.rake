#this tasks sends out donation email 24 hours after a user has taken an action
#for the first implementation we will do the following
#  grab all actions (in this case signatures) in the last 24 hours (we should think about persisting the latest)
#   check to make sure this email is enabled for the action
#   then 
#   grab the templateUrl
#	grab the donation_url  
#	for each user 
#		call out to elastic to send the email
#
# Email Queue
#   id
#   signature_id
#   email_type_id
#   sent
#   sent_at

desc "Run daily donation email process"
task :daily_donation_reminder => [:environment] do

	emails = EmailQueue.includes(:email_type).includes(:signature).where(:email_types => { :id => 1 }, :sent => false)

	emails.each do |email|
		#send the eamil
		email.sent = true
		email.sent_at = Time.now

		email.save!
	end
end
