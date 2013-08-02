@SignatureController = ($scope, petition, PetitionServices, $http, Util, $rootScope) ->

  $scope.petition = petition

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
        Util.push_ga_event("Petition", "Sign With Email", "Success")
   
        $scope.loading.show_spinner = false

        result = response.result

        $rootScope.$broadcast('signedPetition', result.signature)
        
      .error ->
        console.log "signature failed"

        Util.push_ga_event("Petition", "Sign With Email", "Failed")
   
        $scope.loading.show_spinner = false

  $scope.sign_with_facebook = (auth)->
    console.log "Facebook Login Success 2"

    $scope.auth = auth

    $scope.$apply ->
      PetitionServices.sign_with_facebook($scope.auth, $scope.petition.petition_id, $scope.signature_form).success (response) ->
          if response.statusCode is 200
            console.log "signature complete; trying to Share via FB"
          
            Util.push_ga_event("Petition", "Sign With Facebook", "Success")
            
            result = response.result
            signature = result.signature

            fb_message_obj =
              method: 'feed'
              redirect_uri: 'YOUR URL HERE'
              link: $scope.petition.short_url
              name: 'Sign the Petition'
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

                Util.push_ga_event("Petition", "Facebook Share", "Success")

                signature.shared = true
                $rootScope.$broadcast('signedPetitionWithFacebook', signature)
          
              else
                console.log "error sharing"

                Util.push_ga_event("Petition", "Facebook Share", "Failed")
                
                signature.shared = false
                $rootScope.$broadcast('signedPetitionWithFacebook', signature)
          
          else
            console.log "error: " + response

            Util.push_ga_event("Petition", "Sign With Facebook", "Failed")

        .error (response) ->
          console.log "signature failed: " + response

          Util.push_ga_event("Petition", "Sign With Facebook", "Failed")

SignatureController.resolve =
  petition: ['PetitionServices', '$q', '$rootScope', (PetitionServices, $q, $rootScope) ->
    deferred = $q.defer()

    script_tag = document.getElementById('snaptivist-widget')
    petition_id = script_tag.getAttribute("petition-id");
    
    PetitionServices.get_petition(petition_id).then (response) ->
      console.log "got petition"

      deferred.resolve response.result
    
    deferred.promise
  ]
