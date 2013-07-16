@PetitionController = ($scope, PetitionServices, $http, Util, $rootScope) ->

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
  $scope.getWidth = ->
    $(window).width()

  $scope.$watch $scope.getWidth, (newValue, oldValue) ->
    console.log "browser width changed"

  window.onresize = ->
    $scope.$apply()

  window.scope = $scope

  $scope.has_header_image = ->
    if $scope.petition.image_full
      return true
    else
      return false

  $scope.show_signature_delivered = (signature) ->
    return signature.delivered

  $scope.tweet = $scope.petition.signature_count + ' demand @' + $scope.petition.target.twitter_handle + ': ' + $scope.petition.title + '. Join us: ' + $scope.petition.short_url

  $scope.get_percentage_signed = (signatures, target) ->
    if (signatures * 100) / target > 100
      return 100
    else
      return (signatures * 100) / target

  $scope.load_progress_marker = (signatures, target) ->
    width = $("#progress-bar-wrapper").width()

    percentage = (signatures * 100) / target
    if (signatures * 100) / target > 100
      percentage = 100

    return (width*(percentage/100)) + $("#progress-marker").width()/2 + "px"

  #need to refactor in comment controller too
  $scope.get_avatar_url = (user) ->
    if user.avatar_url 
      return user.avatar_url + "?type=large"
    else
      return '/assets/avatar.png'

  $scope.read_summary_click = ->
    $scope.isCollapsed = !$scope.isCollapsed
    if $scope.isCollapsed
      $scope.summary_more_text = "More"
    else
      $scope.summary_more_text = "Less"

  $scope.sign_with_facebook_click = ->
    $scope.loading.show_spinner = true

    Util.navigate "/petitions/Stop/deliver"

  $scope.sign_with_email_address = (form) ->
    console.log("signing petition with email address")

    form.submitted = true
    if form.$valid
    
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

  $scope.set_action_background = (action) ->
    {
      'background-image': 'url(assets/avatar.png)'
    }

  $scope.load_progress_marker()

