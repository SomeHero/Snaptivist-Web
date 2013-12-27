class AddJccClientAndUser < ActiveRecord::Migration
  def up
  	image_dir = File.expand_path("../../images", __FILE__)

	jcc = Client.create!(
		name: 'John Cornyn Campaign',
		avatar: File.open(File.join(image_dir, 'jcc_campaign_logo.png')),
		email: "josh@johncornyn.com",
		password: "Sn@p424#",
	).tap { |c| 
		c.nation_builder_crm_authentication = NationBuilderCrmAuthentication.create!(
			nation_name: "johncornyn",
			client_app_id: "68901bc276106d14b291cc51f0cb94f2f3833cf6abf83928de4645fe7d50493f",
			client_secret: "ac99fcc17e84b365ac0becc6a7396295f1079ff5c950c68176338844c2e128fc",
			access_token: "68d3371a7b2729d4ce115a3d5e131cf37fb18cbed94e25f1ea7da742e87d9a4f",
			redirect_uri: "http://www.snaptivist.org/oauth_callback"
		)


		c.save!
	}		
	User.create!(
		email: "josh@johncornyn.com",
		password: "Sn@p424#",
		first_name: "Josh",
		last_name: "Eboch",
		organization_name: "John Cornyn Campaign",
		zip_code: "23221"
	)
  end

  def down
  end
end
