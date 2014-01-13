@PremiumController = ($scope, PetitionServices, PetitionFactory, $http, $q, Util, $rootScope, $interpolate, $timeout) ->

  Util.push_ga_event("Petition", "Load", "Premium")
   
  window.scope = $scope

  $scope.premium_registration = {
    'first_name': 'James'
    'last_name': 'Rhodes'
    'street_address_1': '424 Roseneath Rd'
    'street_address_2': ''
    'city': 'Richmond'
    'state': 'VA'
    'zip_code': '23221'
    'phone_number': '804-387-9693'
    'email_address': 'james@somehero.com'
  }

  $scope.premium_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.premium_image_full_url + ')'
    }

  $scope.premium_submit_clicked = (form) ->
    console.log("premium button clicked")

    $scope.loading.show_spinner = true

    if form.$valid
      Util.push_ga_event("Petition", "Send Premium", "Clicked")
 
      petition_id = $scope.petition.petition_id

      PetitionServices.send_premium(petition_id, "", $scope.premium_registration).success (response) ->
        console.log "send premium complete"
        
        Util.push_ga_event("Premium", "Send Premium", "Success")
   
      $scope.loading.show_spinner = false

    else
      $scope.loading.show_spinner = false

      $scope.clear_errors()

  $scope.skip_delivery = ->
    console.log("skipping delivery")
    
    Util.push_ga_event("Petition", "Deliver Signature", "Skipped")
            
    $scope.loading.show_spinner = true

    $rootScope.$broadcast('skipDelivery')


  remove_errors = () ->
    $scope.error_messages.deliver_tweet = ""

  $scope.clear_errors = () ->
    $timeout(remove_errors, 4000);

