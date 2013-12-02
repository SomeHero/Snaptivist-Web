@SignatureController = ($scope, PetitionServices, $http, Util, $rootScope, $timeout) ->

  window.scope = $scope
  $scope.form_submitted = false
  $scope.show_errors = false

  $scope.sign_with_email_address = (form) ->
    console.log("signing petition with email address")

    Util.push_ga_event("Petition", "Sign With Email", "Clicked (Pre Form Validation)")
   
    form.submitted = true
    $scope.form_submitted = true

    if form.$valid
    
      Util.push_ga_event("Petition", "Sign With Email", "Clicked (Post Form Validation)")
   
      $scope.show_errors = false
      $scope.loading.show_spinner = true

      petition_id = $scope.petition.petition_id

      PetitionServices.sign_with_email_address(petition_id, $scope.signature).success (response) ->
        console.log "signature complete"
        Util.push_ga_event("Petition", "Sign With Email", "Success")
   
        $scope.loading.show_spinner = false

        result = response.result

        $rootScope.$broadcast('signedPetition', result.signature)
 
      .error ->
        console.log "signature failed"

        Util.push_ga_event("Petition", "Sign With Email", "Failed")
   
        $scope.loading.show_spinner = false
    else
      $scope.show_errors = true

  $scope.sign_with_facebook = (auth)->
    console.log "Facebook Login Success"

    $scope.auth = auth

    $scope.$apply ->
      PetitionServices.sign_with_facebook($scope.auth, $scope.petition.petition_id, $scope.signature).success (response) ->
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

          $rootScope.$broadcast('signedPetitionWithFacebookFailed')

  $scope.sign_with_facebook_cancelled = ->
      Util.push_ga_event("Petition", "Sign With Facebook", "Cancelled")
            
      $rootScope.$broadcast('signedPetitionWithFacebookFailed')

  $scope.signature_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.image_full_url + ')'
    }

  $scope.get_number_of_signatures = () ->
    $scope.petition.signature_count || 0
  
  $scope.calulate_petition_signature_percentage = ->
    return $scope.petition.signature_count/$scope.petition.target_count*100

  remove_errors = () ->
    $scope.show_errors = false

  $scope.display_error_popover = () ->
    if $scope.show_errors
      $timeout(remove_errors, 2000);
    $scope.show_errors

  $scope.form_styling = ->
    if $scope.form_submitted
      return "submitted"
    return ""



