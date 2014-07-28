# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
image_dir = File.expand_path("../images", __FILE__)

admin_user = AdminUser.create({email:'admin@snaptivist.com',password:'password'})

signature_confirmation_email = EmailType.create!(
	id: 1,
	name: 'Signature Confirmation Email',
	description: 'The signature confirmation email is delivered to a petition signer immediately after the petition is signed. The signature confirmation email is sent to all signers.',
	default_email_template: 'Signature Confirmation Email',
	default_subject: 'Your Petition Signature',
	default_state: true,
	position: 1
)
donation_reminder_email = EmailType.create!(
	id: 2,
	name: 'Donation Reminder Email',
	description: 'The donation reminder email is sent daily to all petition signers in the previous 24 hours.',
	default_email_template: 'Donation Reminder Email',
	default_subject: 'Can You Help?',
	default_state: false,
	position: 2
)
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
	name: 'Snaptivist'
).tap { |c| 
	c.nation_builder_crm_authentication = NationBuilderCrmAuthentication.create!(
		nation_name: "rva",
		client_app_id: "fca8f40ae0dba84cb81e8f4975b4759b4debeb4424c54e204105096a36d50a86",
		client_secret: "22760ba29c759804929487f4fa935ac7744aa698700398a622fdb1d4edc0af14",
		access_token: "ce97fd95b4a8a3b2003c00f5c30ccdcdb0710486509ea2b8acac0fd7f2336a2c",
		redirect_uri: "http://www.snaptivist.org/oauth_callback"
	)
	c.admin_users << snaptivist_user

	c.save!
}
jcc = Client.create!(
	name: 'John Cornyn Campaign'
).tap { |c| 
	c.nation_builder_crm_authentication = NationBuilderCrmAuthentication.create!(
		nation_name: "johncornyn",
		client_app_id: "68901bc276106d14b291cc51f0cb94f2f3833cf6abf83928de4645fe7d50493f",
		client_secret: "ac99fcc17e84b365ac0becc6a7396295f1079ff5c950c68176338844c2e128fc",
		access_token: "68d3371a7b2729d4ce115a3d5e131cf37fb18cbed94e25f1ea7da742e87d9a4f",
		redirect_uri: "http://www.snaptivist.org/oauth_callback"
	)
	c.admin_users << jcc_user

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
)

theme_a_layout_1 = Theme.create!(
	layout: standard_layout,
	name: "Theme A",
	description: "Seeded theme A for standard layout",
	css_file: "layout1/theme-a.css",
	url_fragment: 'theme-a'
)
theme_b_layout_1 = Theme.create!(
	layout: standard_layout,
	name: "Theme B",
	description: "Seeded theme B for standard layout",
	css_file: "layout1/theme-b.css",
	url_fragment: 'theme-b'
)
theme_c_layout_1 = Theme.create!(
	layout: standard_layout,
	name: "Theme C",
	description: "Seeded theme C for standard layout",
	css_file: "layout1/theme-c.css",
	url_fragment: 'theme-c'
)

theme_a_layout_2 = Theme.create!(
	layout: jcc_layout,
	name: "Theme A",
	description: "Seeded theme A for jcc layout",
	css_file: "layout2/theme-a.css",
	url_fragment: 'theme-a'
)
theme_b_layout_2 = Theme.create!(
	layout: jcc_layout,
	name: "Theme B",
	description: "Seeded theme B for jcc layout",
	css_file: "layout2/theme-b.css",
	url_fragment: 'theme-b'
)
theme_c_layout_1 = Theme.create!(
	layout: jcc_layout,
	name: "Theme C",
	description: "Seeded theme C for jcc layout",
	css_file: "layout2/theme-c.css",
	url_fragment: 'theme-c'
)

#let's import targets
exe_target_group = TargetGroup.create({id:1, name:'Executive'})
congress_target_group = TargetGroup.create({id:2, name:'State'})
state_target_group = TargetGroup.create({id:3, name: 'Congress'})

Rake::Task['import_executive_targets'].invoke
Rake::Task['import_legislators'].invoke
Rake::Task['import_state_targets'].invoke
Rake::Task['import_state_hashtags'].invoke


