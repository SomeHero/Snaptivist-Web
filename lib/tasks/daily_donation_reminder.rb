#this tasks sends out donation email 24 hours after a user has taken an action
#for the first implementation we will do the following
#  grab all actions (in this case signatures) in the last 24 hours (we should think about persisting the latest)
#	grab the client to pull the templateUrl
#	grab the action that was taken and pull the donation_url  
#	for each user 
#		call out to elastic to send the email
