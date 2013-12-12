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
#   EmailType
#       id
#       name
#       description
#       default_email_template
#
#   EmailConfiguration
# 		email_type
#		petition_id (action_id)
#       from_name
#       from_address
#       subject
#       email_template
#       last_id_sent
#