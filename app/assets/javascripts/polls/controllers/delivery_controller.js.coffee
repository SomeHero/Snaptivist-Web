@DeliveryController = ($scope, PetitionServices, $http, $q, Util, $rootScope) ->

  Util.push_ga_event("Petition", "Load", "Delivery")
   
  window.scope = $scope

  $scope.deliver_action = ->
    console.log("delivering signature")

    $scope.loading.show_spinner = true

    params = 'location=0,status=0,width=800,height=600'
    twitter_window = window.open '/users/auth/twitter', 'twitterWindow', params
    
    interval = window.setInterval((->
      if twitter_window.closed
        window.clearInterval interval
        
        $scope.$apply ->
          PetitionServices.deliver_signature($scope.petition.petition_id, $scope.signature.signature_id, $scope.tweet).success (response) ->
            console.log "signature delivered"

            Util.push_ga_event("Petition", "Deliver Signature", "Success")

            $scope.loading.show_spinner = false

            Util.navigate "/complete"
          .error (response) ->
            console.log "delivery failed"

            Util.push_ga_event("Petition", "Deliver Signature", "Failed")
            
            Util.navigate "/complete"
    ), 1000)

  $scope.skip_delivery = ->
    console.log("skipping delivery")
    
    Util.push_ga_event("Petition", "Deliver Signature", "Skipped")
            
    $scope.loading.show_spinner = true

    Util.navigate "/complete"

