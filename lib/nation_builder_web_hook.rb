#see http://nationbuilder.com/webhooks
module CrmWebHook

  require 'nationbuilder.rb'
  
  class NationBuilderCrmWebHook
  	
  	def create_or_update_user payload
  		Rails.logger.debug "Processing Nation Builder User Created Web Hook"
      
  		external_user = payload.signup
  		external_id = user.nationbuilder_id

  		user = User.find_by_external_id(external_id)

  		if !user
  			user = User.create!(
				email: external_user.email1,
				password: "password",
				first_name: exteranl_user.first_name,
				last_name: external_user.last_name,
				organization_name: "",
				zip_code: external_user.address.zip,
				external_id: external_id
			)
		else
			user.email = external_user.email1,
			user.first_name = external_user.first_name,
			user.last_name = external_user.last_name,
			user.zip_code = external_user.address.zip
  		end

  		Redis.set("user-" + user.id, external_user)
  	end

  	def create_or_update_donation payload
  		Rails.logger.debug "Processing Nation Builder Donation Success Web Hook"

  		external_donation = payload.donation
  		donation_external_id = external_donation.donation_nationbuilder_id

  		external_user = external_donation.signup	
  		user_external_id = external_user.nationbuilder_id

  		user = User.find_by_external_id(user_external_id)

  		if !user
  			user = User.create!(
				email: user.email1,
				password: "password",
				first_name: user.first_name,
				last_name: user.last_name,
				organization_name: "",
				zip_code: "23221",
				external_id: external_id
			)
  		else
			user.email = external_user.email1,
			user.first_name = external_user.first_name,
			user.last_name = external_user.last_name,
			user.zip_code = external_user.address.zip
  		end

  		donation = Donation.find_by_external_id(donation_external_id)

  		if !donation
	  		donation = Donation.create!(
	  				external_id: external_id.donation_nationbuilder_id,
	  				amount: external_donation.amount,
	  				user: user,
	  				source: "NationBuilder",
	  				submitted_date: external_donation.created_at,
	  				donation_status: "Complete",
	  			)
	  	else
	  		donation.amount = external_donation.amount
	  	end
      
        Redis.set("donation-" + donation.id, external_donation)
  	end

  end

end