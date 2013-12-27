@PetitionController = ($scope, PetitionServices, $http, Util, $rootScope) ->

  window.scope = $scope

  $scope.petition =
  	image_full: "/assets/header_images/header_petition_01.png"
  	title: "What's the title (State What Your Want)"
  	target_headline_text: "Headline (State your Target)"
  	call_to_action_button_copy: "Sign Petition"
  	summary: "Summarize your demand"
  	signature_count: 0
  	target_count: 100

  $scope.show =
  	signature: true

  $scope.templates = {
    sign_url: '/client_views/sign'
    deliver_url: '/client_views/deliver'
    more_actions_url: '/client_views/more'
  }