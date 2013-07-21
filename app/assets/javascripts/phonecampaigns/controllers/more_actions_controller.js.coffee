@MoreActionController = ($scope, PhoneCampaignServices, $http, Util, $rootScope, more_actions) ->
  
  $scope.more_actions = more_actions
  $scope.loading.show_spinner = false

  $scope.sign_another = (phonecampaign) ->

    $scope.loading.show_spinner = true

    PhoneCamapginServices.sign_another(phonecampaign.phonecampaign_id).success (response) ->
      if response.statusCode is 200
        console.log "signature complete; trying to Share via FB"
        
        $scope.loading.show_spinner = false

        result = response.result
        $rootScope.signature = result.signature

        fb_message_obj =
          method: 'feed'
          redirect_uri: 'YOUR URL HERE'
          link: phonecampaign.short_url
          name: 'I just joined a phone campaign on Snaptivist'
          caption: phonecampaign.title
          description: phonecampaign.summary,

        if scope.phonecampaign.image_square
          $.extend true, fb_message_obj, { picture: $scope.phonecampaign.image_square }
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

        $scope.loading.show_spinner = false


  $scope.read_more = (phonecampaign) ->
    Util.navigate_absolute "http://#{phonecampaign.subdomain}." + window.location.hostname.split('.').slice(2  - window.location.hostname.split('.').length - 1).join('.') + ":" + (if window.location.port then window.location.port else ""), null, false

  window.scope = $scope

MoreActionController.resolve =
  more_actions: ['PhoneCampaignServices', '$q', '$rootScope', (PhoneCampaignServices, $q, $rootScope) ->
    deferred = $q.defer()
    PhoneCampaignServices.get_more_actions().then (actions) ->
      console.log "got some other actions"

      deferred.resolve actions
    
    deferred.promise
  ]