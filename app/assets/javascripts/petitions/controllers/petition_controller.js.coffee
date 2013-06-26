@PetitionController = ($scope, PetitionServices, $http, Util, $rootScope) ->
	
  $scope.tweet = '79 demand somebody: Stop the drone assassinations of american citizens. Join us: http://bit.ly/ZFg2gl'
  $scope.petition = petition
  $scope.isCollapsed = true
  $scope.summary_more_text = "More"
  $scope.signature = {
    first_name: ''
    last_name: ''
    email_address: ''
    zip_code: ''
    opt_in: true
    comment: ''
  }
  $scope.loading = {
    show_spinner: false
  }

  window.scope = $scope

  $scope.read_summary_click = ->
    $scope.isCollapsed = !$scope.isCollapsed
    if $scope.isCollapsed
      $scope.summary_more_text = "More"
    else
      $scope.summary_more_text = "Less"

  $scope.sign_with_facebook_click = ->
    $scope.loading.show_spinner = true
    Util.navigate "/petitions/Stop/deliver"

  $scope.sign_with_email_address = ->
    console.log("signing petition with email address")
    
    $scope.loading.show_spinner = true

    petition_id = $scope.petition.petition_id

    PetitionServices.sign_with_email_address(petition_id, $scope.signature).success (response) ->
      console.log "signature complete"

      $scope.loading.show_spinner = false

      result = response.result
      $scope.petition = result.petition
      $scope.signature = result.signature

      $rootScope.$broadcast('signedPetition', $scope.signature)

      Util.navigate "/petitions/Stop/deliver"

    .error ->
      console.log "signature failed"

      $scope.loading.show_spinner = false

  $scope.deliver_signature = ->
    console.log("delivering signature")

    $scope.loading.show_spinner = true
    
    tweet = $scope.tweet
    console.log(tweet)

    params = 'location=0,status=0,width=800,height=600'
    twitter_window = window.open '/users/auth/twitter', 'twitterWindow', params
    
    interval = window.setInterval((->
      window.clearInterval interval
      PetitionServices.deliver_signature($scope.petition.petition_id, $scope.signature.signature_id, tweet).success(
        console.log "signature delivered"
        scope.$apply ->
            $scope.loading.show_spinner = false

            Util.navigate "/petitions/Stop/complete"
      )
    ), 1000)

  $scope.skip_delivery = ->
    console.log("skipping delivery")
    
    Util.navigate "/petitions/Stop/complete"

