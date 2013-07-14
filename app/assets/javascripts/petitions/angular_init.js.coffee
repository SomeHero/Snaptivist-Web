@app = angular.module('petition', ['ui.bootstrap'])
	.value('$anchorScroll', angular.noop)

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/petitions'
  $routeProvider.when('/petitions',
    templateUrl: '/client_views/sign'
  ).when('/petitions/:key/sign',
    templateUrl: '/client_views/sign'
  ).when('/petitions/:key/deliver',
    templateUrl: '/client_views/deliver'
  ).when('/petitions/:key/complete',
    templateUrl: '/client_views/more'
  ).otherwise redirectTo: base_page_url
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]
@app.filter "fromNow", ->
  (dateString) ->
    moment(new Date(dateString)).fromNow()
@app.directive "facebook", ($http, Util, $q, $location, PetitionServices) ->
  restrict: "A"
  scope: true
  controller: ($scope, $attrs) ->
    
    # Load the SDK Asynchronously
    login = ->
      FB.login ((response) ->
        if response.authResponse
          console.log "FB.login connected"
          scope.auth = response.authResponse;
          scope.$apply ->
            fetch()
        else
          console.log "FB.login cancelled"
      ),
        scope: "email,publish_stream"

    fetch = ->

      console.log "Signing with Facebook"

      PetitionServices.sign_with_facebook($scope.auth, $scope.petition.petition_id, $scope.sign_comment).success (response) ->
        if response.statusCode is 200
          console.log "signature complete; trying to Share via FB"
          
          result = response.result
          scope.signature = result.signature
          fb_message_obj =
            method: 'feed'
            redirect_uri: 'YOUR URL HERE'
            link: scope.petition.short_url
            name: 'I just signed a petition on Snaptivist'
            caption: scope.petition.title
            description: scope.petition.summary,

          if scope.petition.image_square
            $.extend true, fb_message_obj, { picture: scope.petition.image_square }
          else  
            $.extend true, fb_message_obj, { picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png' }
          
          FB.ui fb_message_obj, (response) ->
            if response
              console.log "share complete"
              scope.$apply ->
                $location.path "/petitions/Stop/deliver"
            else
              console.log "error sharing"
              scope.$apply ->
                $location.path "/petitions/Stop/deliver"
        else
          console.log "error: " + response
      .error (response) ->
        console.log "signature failed: " + response


    ((d) ->
      js = undefined
      id = "facebook-jssdk"
      ref = d.getElementsByTagName("script")[0]
      return  if d.getElementById(id)
      js = d.createElement("script")
      js.id = id
      js.async = true
      js.src = "//connect.facebook.net/en_US/all.js"
      ref.parentNode.insertBefore js, ref
    ) document
    $scope.fetch = ->
      if $scope.login_status is "connected"
        console.log "fetch"
        fetch()
      else
        login()

  link: (scope, element, attrs, controller) ->
    
    # Additional JS functions here
    window.fbAsyncInit = ->
      FB.init
        appId: attrs.facebook # App ID
        channelUrl: "//localhost:3000/channel.html" # Channel File
        status: true # check login status
        cookie: true # enable cookies to allow the server to access the session
        xfbml: true # parse XFBML

      
      # Additional init code here
      FB.getLoginStatus (response) ->
        if response.status is "connected"
          
          # connected
          scope.auth = response.authResponse
        else if response.status is "not_authorized"

        
        # not_authorized
        else

        
        # not_logged_in
        scope.login_status = response.status
        scope.$apply()


# end of fbAsyncInit