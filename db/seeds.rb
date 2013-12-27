# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
image_dir = File.expand_path("../images", __FILE__)

admin_user = AdminUser.create({email:'admin@snaptivist.com',password:'password'})

snaptivist_user = User.create!(
	id: 1,
	email: "james@snaptivist.com",
	password: "Sn@p424#",
	first_name: "James",
	last_name: "Rhodes",
	organization_name: "Snaptivist",
	zip_code: "23221"
)
jcc_user = User.create!(
	id: 2,
	email: "josh@johncornyn.com",
	password: "Sn@p424#",
	first_name: "Josh",
	last_name: "Eboch",
	organization_name: "John Cornyn Campaign",
	zip_code: "23221"
)
#create some client users
snaptivist = Client.create!(
	name: 'Snaptivist',
	avatar: File.open(File.join(image_dir, 'jcc_campaign_logo.png')),
	email: "james@snaptivist.com",
	password: "Sebastian10s",
).tap { |c| 
	c.nation_builder_crm_authentication = NationBuilderCrmAuthentication.create!(
		nation_name: "rva",
		client_app_id: "fca8f40ae0dba84cb81e8f4975b4759b4debeb4424c54e204105096a36d50a86",
		client_secret: "22760ba29c759804929487f4fa935ac7744aa698700398a622fdb1d4edc0af14",
		access_token: "ce97fd95b4a8a3b2003c00f5c30ccdcdb0710486509ea2b8acac0fd7f2336a2c",
		redirect_uri: "http://www.snaptivist.org/oauth_callback"
	)

	c.save!
}
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
#seeding in layout, pages and themes
standard_layout = Layout.create!(
	id: 1,
	name: "Snaptivist Standard",
	url_fragment: 'layout1',
	description: "Standard Layout for Petitions"
)
jcc_layout = Layout.create!(
	id: 2,
	name: "JCC Layout",
	url_fragment: 'layout2',
	description: "Seeded layout for JCC campaign",
).tap { |p|
	p.pages.create!(
		name: "Signature Page",
		description: "seeded signature page for JCC layout",
		template_name: "signature_template"
	)
	p.pages.create!(
		name: "Tweet Page",
		description: "seeded tweet delivery page for JCC layout",
		template_name: "tweet_template"
	)
	p.pages.create!(
		name: "Premium Page",
		description: "seeded premium page for JCC layout",
		template_name: "premium_template"
	)
	p.pages.create!(
		name: "Donation Page",
		description: "seeded donation page for JCC layout",
		template_name: "donation_template"
	)
}
theme_a = Theme.create!(
	name: "Lazy Rain",
	description: "Seeded theme",
	css_file: "lazy_rain.css"
)

#let's import targets
exe_target_group = TargetGroup.create({id:1, name:'Executive'})
congress_target_group = TargetGroup.create({id:2, name:'State'})
state_target_group = TargetGroup.create({id:3, name: 'Congress'})

Rake::Task['import_executive_targets'].invoke
Rake::Task['import_legislators'].invoke
Rake::Task['import_state_targets'].invoke
Rake::Task['import_state_hashtags'].invoke

#let's seed in a few petitions
#Stop  the Drone Assassinations
Petition.create!(
	id: 1,
	title: 'Tell President Obama: Stop the Drone Assassinations of American Citizens',
	headline_primary: 'Tell President Obama',
	headline_secondary: 'Stop the Drone Assassinations of American Citizens',
	subheadline: 'Demand Your Right Due Process',
	signature_more_signers_button_text: 'More Signers',
	header_image: File.open(File.join(image_dir, 'obama_drone.jpg')),
	summary: 'The IRS has been targeting Americans for their political beliefs and using their power to intimidate law-abiding citizens and chill their freedom of speech. It is time to get rid of this corrupt agency and start over again with a flat or fair tax system.',
	target: Target.first,
	target_count: 1000,
	subdomain: 'petition-1',
	target_headline_text: 'Tell President Obama',
	call_to_action_button_text: 'Sign the Petition',
	signature_comment_placeholder_text: 'Tell Obama what you think',
	sign_with_facebook_cta_button_text: 'Sign with Facebook',
	sign_with_email_cta_button_text: 'Sign with Email Address',
	delivery_headline_primary: 'Thanks for Signing',
	delivery_headline_secondary: '',
	delivery_subheadline: '',
	delivery_call_to_action_text: 'Please Tweet Your Signature to Help Us Reach Our Goal',
	delivery_call_to_action_button_text: 'Tweet My Signature',
	delivery_skip_button_text: 'I Don\'t Use Twitter',
	delivery_more_tweets_button_text: 'More Tweets',
	premium_headline_primary: 'Thanks for Signing',
	premium_headline_secondary: 'Complete the Form below to Request Your Free Bumper Magnet',
	premium_subheadline: '',
	premium_call_to_action_text: '',
	premium_call_to_action_button_text: 'Send My Magnet',
	premium_skip_button_text: '',
	default_tweet_text: 'Hey @BarackObama stop killing people with flying robots! Sign the petition: http://sign.ru/p232a',
	action_tags: '#petition-1',
	tweet_cta_button_text: 'Tweet',
	active: true,
	unsponsored: false,
	client: snaptivist,
	user: snaptivist_user,
	layout: jcc_layout,
	theme: theme_a,
	donation_page_url: "https://johncornyn.nationbuilder.com/donation_landing_page"
).tap { |p| 
	#seed in some signers
	20.times do |index|
		p.signatures.create!(
			user: User.create!(
				id: (index+20)*0+index+1,
				email: "james+#{(index+20)*0 + index + 1}@snaptivist.com",
				password: "password#{(index+20)*0+index+1}",
				first_name: "Signer",
				last_name: "User #{(index+20)*0 +index+1}",
				organization_name: "",
				zip_code: "23221"
		),
		comment: "This practice needs to stop now #{(index+20)*0 +index+1}"
	).tap { |sig|
		if [true, false].sample
			sig.tweet = Tweet.create!(
				message: "Hey @BarackObama stop killing people with flying robots! Sign the petition: http://sign.ru/p232a"
			)
			sig.save!
		end
	}
	p.premium_offer = PremiumOffer.create!(
		name: "Bumper Magnet",
		headline_text: "Thanks for 	Signing! Complete the Form below to Request Your Free Bumper Magnet",
		call_to_action_button_text: "Send My Magnet"
	)

	p.save!

	end
}
#Fire Holder
Petition.create!(
	id: 2,
	title: 'Tell President Obama: Fire Eric Holder',
	headline_primary: 'Fire Eric Holder',
	headline_secondary: 'Tell President Obama that America Deserves Better',
	subheadline: 'It’s Time for Eric Holder to Go',
	header_image: File.open(File.join(image_dir, 'holder_fired_petition.png')),
	summary: 'From the Fast and Furious gun-walking scandal that resulted in the death of a U.S. Border Patrol Agent, to attacks on the First Amendment by targeting journalists for retribution, Eric Holder\'s Justice Department has abused its power and failed to carry out its duty to enforce the laws of the United States.<br /><br />Therefore, we demand that President Obama fire Eric Holder immediately and replace him with an Attorney General who will uphold the law and honor his or her oath to the U.S. Constitution.',
	target: Target.first,
	target_count: 1000,
	subdomain: 'fire-holder',
	target_headline_text: 'Tell President Obama',
	call_to_action_button_text: 'Sign the Petition',
	signature_comment_placeholder_text: 'Tell Obama what you think',
	sign_with_facebook_cta_button_text: 'Sign Using Facebook',
	sign_with_email_cta_button_text: 'Add Your Voice',
	default_tweet_text: 'Hey @BarackObama America Deserves Better.  Fire Eric Holder. ! Sign the petition: http://sign.ru/p232a',
	action_tags: '#fire-eric-holder',
	tweet_cta_button_text: 'Tweet',
	active: true,
	unsponsored: false,
	client: snaptivist,
	user: snaptivist_user,
	layout: jcc_layout,
	theme: theme_a
).tap { |p| 
	#seed in some signers
	20.times do |index|
		p.signatures.create!(
			user: User.create!(
				id: (index+20)*1+1,
				email: "james+#{(index+20)*1 +index+1}@snaptivist.com",
				password: "password#{(index+20)*1+index+1}",
				first_name: "Signer",
				last_name: "User #{(index+20)*1+index+1}",
				organization_name: "",
				zip_code: "23221"
		),
		comment: "This practice needs to stop now #{(index+20)*1+index+1}"
	).tap { |sig|
		if [true, false].sample
			sig.tweet = Tweet.create!(
				message: 'Hey @BarackObama America Deserves Better.  Fire Eric Holder. ! Sign the petition: http://sign.ru/p232a'
			)
			sig.save!
		end
	}
	p.premium_offer = PremiumOffer.create!(
		name: "Bumper Magnet",
		headline_text: "Thanks for 	Signing! Complete the Form below to Request Your Free Bumper Magnet",
		call_to_action_button_text: "Send My Magnet"
	)

	p.save!

	end
}

