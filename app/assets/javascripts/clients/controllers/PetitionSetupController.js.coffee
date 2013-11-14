@PetitionSetupController = ($scope, $route, $rootScope, $location, fileReader, layouts) ->
	window.scope = $scope

	$scope.is_admin = true
	$scope.layouts = layouts

	if $location.hash()
		$scope.step = parseInt($location.hash())
	else
		$scope.step = 1

	$scope.petition = {
		client: $scope.client,
		name: '',
		title: '',
		sub_heading: '',
		summary: '',
		sign_with_facebook_cta_button_text: '',
		sign_with_email_cta_button_text: '',
		target_count: '',
		more_signers_button_text: '',
		redemption_url: '',
		default_tweet_text: 'Hey @Barack'
		delivery: {
			headline: 'Thanks for Signing!',
			sub_headline: 'Delivery Sub Heading',
			tweet_call_to_action_text: 'Send Tweet Call to Action',
			tweet_skip_text: 'Skip Text',
			more_tweets_button_text: 'More Tweets Button Text'
		}
	}

	$scope.content_template_urls = () ->
		if $scope.step == 5
			return "clients/partials/email_config"
		else if $scope.step == 4
			return "clients/partials/pages"
		else if $scope.step == 3
			return "clients/partials/theme"
		else if $scope.step == 2
			return "clients/partials/layout"
		else
			return "clients/partials/configure"

	$scope.sidebar_template_urls = () ->
		if $scope.step == 5
			return "clients/partials/email_config_sidebar"
		else if $scope.step == 4
			return "clients/partials/pages_sidebar"
		else if $scope.step == 3
			return "clients/partials/theme_sidebar"
		else if $scope.step == 2
			return "clients/partials/layout_sidebar"
		else
			return "clients/partials/configure_sidebar"

	$scope.next_step_clicked = () ->
		console.log("next clicked")
		$scope.step = parseInt($scope.step) + 1
		
		$location.hash($scope.step)

	$scope.goto_step_clicked = (step) ->
		console.log("step clicked")
		$scope.step = step

		$location.hash($scope.step)

	lastRoute = $route.current
	$scope.$on "$locationChangeSuccess", (event) ->
	  $route.current = lastRoute
	
	PetitionSetupController.$inject = ['$scope', '$route', '$rootScope', '$location', 'fileReader', 'layouts']

PetitionSetupController.resolve =
  layouts: ['LayoutServices', '$q', (LayoutServices, $q) ->
    deferred = $q.defer()

    LayoutServices.get_layouts().then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]

