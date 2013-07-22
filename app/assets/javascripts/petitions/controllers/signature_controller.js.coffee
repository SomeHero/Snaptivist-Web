@SignatureController = ($scope, PetitionServices, $http, Util, $rootScope) ->

  window.scope = $scope

  $scope.signature_form = {
    first_name: ''
    last_name: ''
    email_address: ''
    zip_code: ''
    opt_in: true
    comment: ''
  }

  $scope.sign_with_email_address = (form) ->
    console.log("signing petition with email address")

    form.submitted = true
    if form.$valid
    
      $scope.loading.show_spinner = true

      petition_id = $scope.petition.petition_id

      PetitionServices.sign_with_email_address(petition_id, $scope.signature_form).success (response) ->
        console.log "signature complete"

        $scope.loading.show_spinner = false

        result = response.result
        $rootScope.petition = result.petition
        $rootScope.signature = result.signature

        $rootScope.$broadcast('signedPetition', $scope.signature)

        Util.navigate "/deliver"

      .error ->
        console.log "signature failed"

        $scope.loading.show_spinner = false

  $scope.set_action_background = (action) ->
    {
      'background-image': 'url(assets/avatar.png)'
    }

  $scope.$on 'handleFacebookAuth', (event, source) ->
    console.log "Facebook Login Success"

    PetitionServices.sign_with_facebook($scope.auth, $scope.petition.petition_id, $scope.signature_form).success (response) ->
        if response.statusCode is 200
          console.log "signature complete; trying to Share via FB"
          
          result = response.result
          $rootScope.signature = result.signature

          $rootScope.$broadcast('signedPetition', $scope.signature)

          fb_message_obj =
            method: 'feed'
            redirect_uri: 'YOUR URL HERE'
            link: $scope.petition.short_url
            name: 'I just signed a petition on Snaptivist'
            caption: $scope.petition.title
            description: $scope.petition.summary,

          if scope.petition.image_square
            $.extend true, fb_message_obj, { picture: $scope.petition.image_square }
          else  
            $.extend true, fb_message_obj, { picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png' }
          
          scroll = $(window).scrollTop()

          FB.ui fb_message_obj, (response) ->
            $(window).scrollTop scroll
            
            if response
              console.log "share complete"
              
              $scope.$apply -> 
                Util.navigate "/deliver"
            else
              console.log "error sharing"
              
              $scope.$apply ->
                Util.navigate "/deliver"
        else
          console.log "error: " + response
      .error (response) ->
        console.log "signature failed: " + response