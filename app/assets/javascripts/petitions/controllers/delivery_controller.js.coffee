@DeliveryController = ($scope, PetitionServices, PetitionFactory, $http, $q, Util, $rootScope, $interpolate) ->

  window.scope = $scope

  $scope.signature = PetitionFactory.signature
  $scope.tweet = {
    message: $interpolate($scope.petition.default_tweet_text|| "")($scope)
  }
  
  $scope.get_avatar_url = (signature) ->
    if !signature.user
      return '/assets/avatar.png'

    if signature.user.avatar_url 
      return signature.user.avatar_url + "?type=large"
    else
      return '/assets/avatar.png'

  $scope.display_location = (signature) ->
    if signature.city && signature.state
      return "in " + signature.city + ", " + signature.state
    else
      return ""

  $scope.show_signature_delivered = (signature) ->
    return signature.delivered

  $scope.deliver_action = (form) ->
    console.log("delivering signature")

    $scope.loading.show_spinner = true

    params = 'location=0,status=0,width=800,height=600'
    twitter_window = window.open '/users/auth/twitter', 'twitterWindow', params
    
    interval = window.setInterval((->
      if twitter_window.closed
        window.clearInterval interval
        
        $scope.$apply ->
          PetitionServices.check_twitter_connect().then (response) ->
            PetitionServices.deliver_signature($scope.petition.petition_id, $scope.signature.signature_id, $scope.tweet.message).success (response) ->
              console.log "signature delivered"

              Util.push_ga_event("Petition", "Deliver Signature", "Success")

              $scope.loading.show_spinner = false

              $rootScope.$broadcast('deliveredPetition')
          
            .error (response) ->
              console.log "delivery failed"

              Util.push_ga_event("Petition", "Deliver Signature", "Failed")
            
              $rootScope.$broadcast('skipDelivery')

          , (response) ->
            console.log "failed check for twitter credentials"

            Util.push_ga_event("Petition", "Deliver Signature", "Skipped (No Auth)")
          
            $rootScope.$broadcast('skipDelivery')    
    ), 1000)

  $scope.skip_delivery = ->
    console.log("skipping delivery")
    
    Util.push_ga_event("Petition", "Deliver Signature", "Skipped")
            
    $scope.loading.show_spinner = true

    $rootScope.$broadcast('skipDelivery')
        
  $scope.signature_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.image_full_url + ')'
    }

  $scope.premium_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.premium_image_full_url + ')'
    }
  $scope.get_tweet_message_length = () ->
    $scope.tweet.message.length

  $scope.get_number_of_tweets = ->
    $scope.tweets.total

  $scope.calculate_petition_tweet_percentage = ->
    $scope.tweets.total/$scope.petition.target_count*100

