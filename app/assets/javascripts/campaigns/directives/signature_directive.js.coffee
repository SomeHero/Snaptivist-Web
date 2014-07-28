@app.directive 'signature', ['$timeout', '$window', 'Util', 'ActionServices', ($timeout, $window, Util, ActionServices) ->
  restrict: "A"
  scope: true
  controller: ($scope, $attrs) ->
    remove_errors = () ->
      $scope.error_messages.deliver_tweet = ""

    $scope.clear_errors = () ->
      $timeout(remove_errors, 4000);

    $scope.sign_with_email_address = (form) ->
      console.log("signing campaign action with email address")

      Util.push_ga_event("Action", "Sign With Email", "Clicked (Pre Form Validation)")
   
      #$scope.loading.show_spinner = true

      $scope.form_submitted = true

      if form.$valid
    
        Util.push_ga_event("Action", "Sign With Email", "Clicked (Post Form Validation)")

        ActionServices.sign_with_email(scope.page.action.id, $scope.signature).success (response) ->

          console.log "signature complete"
          Util.push_ga_event("Actions", "Sign With Email", "Success")
   
          #$scope.loading.show_spinner = false

          #result = response.result

          #$rootScope.$broadcast('signedPetition', result)

          scope.change_page()
 
        .error (response) ->
          console.log "signature failed: " + response

          Util.push_ga_event("Action", "Sign With Email", "Failed")
   
          $scope.loading.show_spinner = false

          scope.error_messages.sign_with_email_address = "We're sorry.  We are unable to collect your signature at this time.  Please try again later."
          $scope.clear_errors()

      else
        #$scope.loading.show_spinner = false

        Util.push_ga_event("Action", "Sign With Email", "Clicked (Form Invalid)")
     
        if form.EmailAddress.$error['email']
          scope.error_messages.sign_with_email_address = "The email address is invalid.  Please type your email again."
        else
          scope.error_messages.sign_with_email_address = "All fields are required."
        $scope.clear_errors()
]