# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
image_dir = File.expand_path("../images", __FILE__)

admin_user = AdminUser.create({email:'admin@snaptivist.com',password:'password'})

jcc_user = User.create!(
	id: 1,
	email: "james+100@snaptivist.com",
	password: "Sn@p424#",
	first_name: "Test",
	last_name: "User 1",
	organization_name: "John Cornyn Campaign",
	zip_code: "23221"
)
#create some client users
jcc = Client.create!(
	name: 'John Cornyn Campaign',
	avatar: File.open(File.join(image_dir, 'jcc_campaign_logo.png')),

)
#seeding in layout, pages and themes
jcc_layout = Layout.create!(
	name: "JCC Layout",
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
	default_tweet_text: 'Hey @BarackObama stop killing people with flying robots! Sign the petition: http://sign.ru/p232a',
	action_tags: '#petition-1',
	tweet_cta_button_text: 'Tweet',
	active: true,
	unsponsored: false,
	client: jcc,
	user: jcc_user,
	layout: jcc_layout,
	theme: theme_a
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
	client: jcc,
	user: jcc_user,
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

