@DeliveryController = ($scope, PetitionServices, PetitionFactory, $http, $q, Util, $rootScope, $interpolate, $timeout) ->

  Util.push_ga_event("Petition", "Load", "Delivery")
   
  window.delivery_scope = $scope

  $scope.signature = PetitionFactory.signature
  $scope.tweet = {
    message: $interpolate($scope.petition.default_tweet_text|| "")($scope)
  }
  $scope.error_messages = 
    deliver_tweet: ""

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

    if form.$valid
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
                
                $scope.loading.show_spinner = false

                  

            , (response) ->
              console.log "failed check for twitter credentials"

              Util.push_ga_event("Petition", "Deliver Signature", "Skipped (No Auth)")
            
              $scope.loading.show_spinner = false

              $scope.error_messages.deliver_tweet = "We're sorry. We're unable to deliver your signature. Please, try again later."
              $scope.clear_errors()
   
      ), 1000)
    else
      $scope.loading.show_spinner = false

      $scope.error_messages.deliver_tweet = "Enter a message to tweet above."
      $scope.clear_errors()

  $scope.skip_delivery = ->
    console.log("skipping delivery")
    
    Util.push_ga_event("Petition", "Deliver Signature", "Skipped")
            
    $scope.loading.show_spinner = true

    $rootScope.$broadcast('skipDelivery')
        
  $scope.delivery_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.delivery_image_original_url + ')'
    }

  $scope.get_tweet_message_length = () ->
    if $scope.tweet.message
      $scope.tweet.message.length
    else
      0

  $scope.set_content_width = () ->
    if $scope.has_delivery_image()
      return "col-md-6";
    else
      return "col-md-8 col-md-offset-2"

  $scope.has_delivery_image = ->
    return $scope.petition.delivery_image_full_url && $scope.petition.delivery_image_full_url.length > 0

  remove_errors = () ->
    $scope.error_messages.deliver_tweet = ""

  $scope.clear_errors = () ->
    $timeout(remove_errors, 4000);

  $scope.get_number_of_tweets = ->
    $scope.tweets.total

  $scope.calculate_petition_tweet_percentage = ->
    $scope.tweets.total/$scope.petition.target_count*100

