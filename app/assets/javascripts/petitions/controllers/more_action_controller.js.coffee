@MoreActionController = ($scope, PetitionServices, $http, Util, $rootScope, more_actions) ->
  
  $scope.more_actions = more_actions
  $scope.petition = petition
  $scope.isCollapsed = true
  $scope.summary_more_text = "More"
  $scope.loading = {
    show_spinner: false
  }

  $scope.sign_another = (petition) ->
    PetitionServices.sign_another(petition.petition_id).success (response) ->
      if response.statusCode is 200
        console.log "signature complete; trying to Share via FB"
        
        result = response.result
        $rootScope.signature = result.signature

        fb_message_obj =
          method: 'feed'
          redirect_uri: 'YOUR URL HERE'
          link: petition.short_url
          name: 'I just signed a petition on Snaptivist'
          caption: petition.title
          description: petition.summary,

        if scope.petition.image_square
          $.extend true, fb_message_obj, { picture: $scope.petition.image_square }
        else  
          $.extend true, fb_message_obj, { picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png' }
        
        scroll = $(window).scrollTop()

        FB.ui fb_message_obj, (response) ->
          $(window).scrollTop scroll
            
          if response
            console.log "share complete"
            
          else
            console.log "error sharing"
            
      else
        console.log "error: " + response

  $scope.read_more = (petition) ->
    Util.navigate_absolute "http://#{petition.subdomain}." + window.location.hostname.split('.').slice(2  - window.location.hostname.split('.').length).join('.') + ":" + (if window.location.port then window.location.port else ""), null, false

  window.scope = $scope

MoreActionController.resolve =
  more_actions: ['PetitionServices', '$q', '$rootScope', (PetitionServices, $q, $rootScope) ->
    deferred = $q.defer()
    PetitionServices.get_more_petitions().then (petitions) ->
      console.log "got some other actions"

      deferred.resolve petitions
    
    deferred.promise
  ]

