@PetitionSetupController = ($scope, $rootScope) ->
  window.scope = $scope

  $scope.step = 1

  $scope.petition = {
    name: 'New Campaign Name',
    title: 'Petition Headline',
    sub_heading: 'Sub-Headline Text',
    summary: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum.<br /><br />Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.',
    sign_with_facebook_cta_button_text: 'Sign with Facebook',
    sign_with_email_cta_button_text: 'Add My Name',
    target_count: 1000,
    more_signers_button_text: 'More Signers Button Text',
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
  	else if $scope.step == 1
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
  	else if $scope.step == 1
  		return "clients/partials/configure_sidebar"

  $scope.next_step_clicked = () ->
  	console.log("next clicked")
  	$scope.step += 1

PetitionSetupController.$inject = ['$scope', '$rootScope']
