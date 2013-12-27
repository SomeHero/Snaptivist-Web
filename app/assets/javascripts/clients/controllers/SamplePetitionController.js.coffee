@SamplePetitionController = ($scope, $rootScope) ->

	$scope.is_admin = false
	
	$scope.petition = {
		headline_primary: 'Tell Barack Obama'
		headline_secondary: 'Stop the Drone Assassinations of American Citizens'
		subheadline: 'Demand Your Right to Due Process'
		sign_with_facebook_cta_button_text: 'Sign with Facebook'
		sign_with_email_cta_button_text: 'Sign with Email Address'
		target_count: 1000
		signature_count: 345
		signature_more_signers_button_text: 'More Signers'
		summary: 'The IRS has been targeting Americans for their political beliefs and using their power to intimidate law-abiding citizens and chill their freedom of speech. It is time to get rid of this corrupt agency and start over again with a flat or fair tax system.'
		disclaimer_text: 'Paid for by Texans for John Cornyn'
	}
	$scope.sample_page_template = ->
		return "/client_views/" + $scope.settings.layout.url_fragment + "/signature_template"
