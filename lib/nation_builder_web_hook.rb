#see http://nationbuilder.com/webhooks
module CrmWebHook

  require 'nationbuilder.rb'
  
  class NationBuilderCrmWebHook
  	
  	def create_or_update_user(payload, client)
  		Rails.logger.debug "Processing Nation Builder User Created Web Hook"
      
  # 		external_user = payload.signup
  # 		external_id = external_user.nationbuilder_id.to_s

  # 		user = User.find_by_external_id(external_id)

  # 		if !user
  # 			user = User.create!(
		# 		email: external_user.email1,
		# 		password: "password",
		# 		first_name: external_user.first_name,
		# 		last_name: external_user.last_name,
		# 		organization_name: "",
		# 		#zip_code: external_user.address.zip,
		# 		external_id: external_id
		# 	)

		# 	client.supporters << user

		# else
		# 	user.email = external_user.email1
		# 	user.first_name = external_user.first_name
		# 	user.last_name = external_user.last_name
		# 	#user.zip_code = external_user.address.zip

		# 	#we need to check that the user supports client
		# 	user.save
  # 		end

  		#REDIS.set("user-" + user.id.to_s, payload.to_json	)
  	end

  	def create_or_update_donation(payload, client)
  		Rails.logger.debug "Processing Nation Builder Donation Success Web Hook"

  		external_donation = payload.donation
  		donation_external_id = external_donation.donation_nationbuilder_id.to_s

  		external_user = external_donation.signup	
  		user_external_id = external_user.nationbuilder_id.to_s

  		user = User.find_by_external_id(user_external_id)

  		if !user
  			user = User.find_by_email(external_user.email1)

  			if !user
	  			user = User.create!(
					email: external_user.email1,
					password: "password",
					first_name: external_user.first_name,
					last_name: external_user.last_name,
					organization_name: "",
					#zip_code: "23221",
					external_id: user_external_id
				)
			else
				user.external_id = user_external_id

				user.save
			end
  		else
			user.email = external_user.email1
			user.first_name = external_user.first_name
			user.last_name = external_user.last_name
			#user.zip_code = external_user.address.zip

			user.save
  		end

  		donation = Donation.find_by_external_id(donation_external_id)

  		if !donation
	  		donation = Donation.create!(
	  				external_id: donation_external_id,
	  				amount: external_donation.amount,
	  				user: user,
	  				source: "NationBuilder",
	  				submitted_date: external_donation.created_at,
	  				donation_status: "Complete"
	  			)
	  	else
	  		donation.amount = external_donation.amount

	  		donation.save
	  	end
      
        REDIS.set("donation-" + donation.id.to_s, external_donation)
  	end

  end

end