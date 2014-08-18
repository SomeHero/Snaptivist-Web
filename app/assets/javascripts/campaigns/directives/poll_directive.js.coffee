@app.directive 'ngPoll', ['$timeout', '$window', 'ActionServices', 'Util', ($timeout, $window, ActionServices, Util) ->
  restrict: "A"
  replace: true
  scope: {
    page: '=page'
    action: '=action'
    content: '=content'
    isAdmin: '=isAdmin'
  }
  templateUrl: '/client_views/layout1/templates/poll_template'
  link: (scope, element, attrs) ->
    scope.remove_poll_choice_clicked = (poll_choice) ->
      console.log "number of options " + scope.page.action.poll_choices.length

      scope.page.action.poll_choices.splice(scope.page.action.poll_choices.indexOf(poll_choice), 1) 

    scope.set_poll_choice_style = (poll_choice) ->
      if(poll_choice == scope.action.selected_poll_choice)
        "fa fa-dot-circle-o"
      else
        "fa fa-circle-o"

    scope.set_selected_choice = (poll_choice) ->
      scope.action.selected_poll_choice = poll_choice
      
  controller: ($scope, $attrs) ->
    $scope.action_response = {
      action_id: $scope.action.id
      type: $scope.action.type
    }

    $scope.action.selected_poll_choice = $scope.action.poll_choices_attributes[0]

    $scope.poll_choice_clicked = (poll_choice) ->
      console.log "poll choice clicked"

      $scope.action.selected_poll_choice = poll_choice

    $scope.set_poll_choice_icon = (poll_choice) ->
      if(poll_choice == $scope.action.selected_poll_choice)
        return "fa-circle poll-choice poll-choice-selected"
      else
        return "fa-circle-o poll-choice"

    $scope.submit_action_with_facebook = (auth) ->
      console.log "Facebook Login Success"

      $scope.action_response.action_method = 'facebook'
      $scope.action_response.choice_id = $scope.action.poll_choices_attributes[0].id

      #$scope.loading.show_spinner = true

      $scope.action_response.auth = auth

      ActionServices.create(scope.campaign, $scope.action, $scope.action_response).success (response) ->

          console.log "signature complete; trying to Share via FB"
          
          #$scope.loading.show_spinner = false

          Util.push_ga_event("Action", "Sign With Facebook", "Success")
            
          fb_message_obj =
            method: 'feed'
            redirect_uri: 'YOUR URL HERE'
            #link: $scope.petition.short_url
            name: 'Add Your Voice'
            caption: 'Test Campaign'
            description: 'Description'

          if $scope.campaign.signature_image_square_url
            $.extend true, fb_message_obj, { picture: $scope.petition.signature_image_square_url }
          else  
            $.extend true, fb_message_obj, { picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png' }
            
          FB.ui fb_message_obj, (response) ->

            if response
              console.log "share complete"

              Util.push_ga_event("Petition", "Facebook Share", "Success")

              #signature.shared = true
              $rootScope.$broadcast('signedPetitionWithFacebook', signature)
          
            else
              console.log "error sharing"

              Util.push_ga_event("Petition", "Facebook Share", "Cancelled")
                
              #signature.shared = false
              #$rootScope.$broadcast('signedPetitionWithFacebook', signature)
          
              $scope.change_page()

        .error (response) ->
          console.log "signature failed: " + response

          $scope.loading.show_spinner = false

          Util.push_ga_event("Petition", "Sign With Facebook", "Failed")

          $scope.error_messages.sign_with_facebook = "We're sorry.  We are unable to collect your signature at this time.  Please try again later."
          $scope.clear_errors()

          #$rootScope.$broadcast('signedPetitionWithFacebookFailed')

    $scope.submit_action_with_email_address = (form) ->
      console.log("submitting vote")

      $scope.action_response.method = 'email'
      $scope.action_response.choice_id = $scope.action.poll_choices_attributes[0].id
    
      #Util.push_ga_event("Action", "Sign With Email", "Clicked (Pre Form Validation)")
   
      #$scope.loading.show_spinner = true

      form.submitted = true

      if form.$valid
    
        #Util.push_ga_event("Action", "Sign With Email", "Clicked (Post Form Validation)")

        ActionServices.create(scope.campaign, $scope.action, $scope.action_response).success (response) ->

          console.log "signature complete"
          #Util.push_ga_event("Actions", "Sign With Email", "Success")
   
          #$scope.loading.show_spinner = false

          #result = response.result

          #$rootScope.$broadcast('signedPetition', result)

          $scope.change_page()
 
        .error (response) ->
          console.log "signature failed: " + response

          #Util.push_ga_event("Action", "Sign With Email", "Failed")
   
          $scope.loading.show_spinner = false

          $scope.error_messages.sign_with_email_address = "We're sorry.  We are unable to collect your signature at this time.  Please try again later."
          $scope.clear_errors()

      else
        #$scope.loading.show_spinner = false

        #Util.push_ga_event("Action", "Sign With Email", "Clicked (Form Invalid)")
     
        
]
