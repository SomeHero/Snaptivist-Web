ActiveAdmin.register Poll do
	index do
		selectable_column
		column :question
		column 'Choices' do |poll|
			poll.choices.map { |choice|
				link_to choice.choice, admin_choice_path(choice)
				}.join("<br/>").html_safe
			end
		column :rewrite_url_key
		column :short_url

		 default_actions

		end

	end
