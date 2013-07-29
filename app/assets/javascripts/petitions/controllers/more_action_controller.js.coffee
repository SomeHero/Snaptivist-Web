@MoreActionController = ($scope, PetitionServices, $http, Util, $rootScope) ->
  
  Util.push_ga_event("Petition", "Load", "More Actions")
   
  $scope.sign_another = (petition, form) ->

    $scope.loading.show_spinner = true

    PetitionServices.sign_another(petition.petition_id).success (response) ->
      if response.statusCode is 200

        console.log "signature complete; trying to Share via FB"
        
        Util.push_ga_event("Petition", "Sign Another Petition", "Success")
   
        $scope.loading.show_spinner = false

        result = response.result
        $rootScope.signature = result.signature

        if $scope.auth
        
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

              Util.push_ga_event("Petition", "Facebook Share", "Success")
   
              
            else
              console.log "error sharing"

              Util.push_ga_event("Petition", "Facebook Share", "Failed")
   

      else
        console.log "error: " + response

        $scope.loading.show_spinner = false

        Util.push_ga_event("Petition", "Sign Another Petition", "Failed")
   


  $scope.read_more = (petition) ->

    Util.push_ga_event("Petition", "Read More", "Success")
   
    Util.navigate_absolute "http://#{petition.subdomain}." + window.location.hostname.split('.').slice(2  - window.location.hostname.split('.').length - 1).join('.') + ":" + (if window.location.port then window.location.port else ""), null, false

  window.scope = $scope


