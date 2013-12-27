class AddLayouts < ActiveRecord::Migration
  def up
  	binding.pry
  	#seeding in layout, pages and themes
	standard_layout = Layout.create!(
		id: 1,
		name: "Snaptivist Standard",
		url_fragment: 'layout1',
		description: "Standard Layout for Petitions"
	)
	standard_sign_page = standard_layout.pages.create!(
		name: "Signature Page",
		description: "seeded signature page for JCC layout",
		template_name: "signature_template",
		url_fragment: "/sign",
		position: 1
	)
	standard_deliver_page = standard_layout.pages.create!(
		name: "Tweet Page",
		description: "seeded tweet delivery page for JCC layout",
		template_name: "tweet_template",
		url_fragment: "/deliver",
		position: 2
	)
	standard_premium_page = standard_layout.pages.create!(
		name: "Premium Page",
		description: "seeded premium page for JCC layout",
		template_name: "premium_template",
		url_fragment: "/premium",
		position: 3
	)
	standard_donate_page = standard_layout.pages.create!(
		name: "Donation Page",
		description: "seeded donation page for JCC layout",
		template_name: "donation_template",
		url_fragment: "/donate",
		position: 4
	)

		jcc_layout = Layout.create!(
			id: 2,
			name: "JCC Layout",
			url_fragment: 'layout2',
			description: "Seeded layout for JCC campaign",
		)
		jcc_sign_page = jcc_layout.pages.create!(
			name: "Signature Page",
			description: "seeded signature page for JCC layout",
			template_name: "signature_template",
			url_fragment: "/sign",
			position: 1
		)
		jcc_deliver_page = jcc_layout.pages.create!(
			name: "Tweet Page",
			description: "seeded tweet delivery page for JCC layout",
			template_name: "delivery_template",
			url_fragment: "/deliver",
			position: 2
		)
		jcc_premium_page = jcc_layout.pages.create!(
			name: "Premium Page",
			description: "seeded premium page for JCC layout",
			template_name: "premium_template",
			url_fragment: "/premium",
			position: 3
		)
		jcc_donation_page = jcc_layout.pages.create!(
			name: "Donation Page",
			description: "seeded donation page for JCC layout",
			template_name: "donation_redirect_template",
			url_fragment: "",
			url_redirect: true,
			url_redirect_property: "donation_page_url",
			position: 4
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
  end

  def down
  	Page.delete_all
  	Theme.delete_all
  	Layout.delete_all
  end
end
