@app.directive "facebook", ($http, Util, $q, $location, $parse) ->
  restrict: "A"
  scope: true
  controller: ($scope, $attrs) ->
    
    # Load the SDK Asynchronously
    login = ->

      FB.login ((response) ->
        if response.authResponse
          console.log "FB.login connected"
          Util.push_ga_event("Petition", "Facebook Login", "Connected")
   
          if(scope.page.action.type == 'Petition')
            scope.sign_with_facebook(response.authResponse)
          else if(scope.page.action.type == 'Poll')
            scope.vote_with_facebook(response.authResponse)

        else
          console.log "FB.login cancelled"

          Util.push_ga_event("Petition", "Facebook Login", "Cancelled")

          scope.sign_with_facebook_cancelled()
   
      ),
        scope: "email"

    fetch = ->

      console.log "Signing with Facebook"

      scope.sign_with_facebook($scope.auth)
      #scope.vote_with_facebook($scope.auth)


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
      Util.push_ga_event("Petition", "Sign With Facebook", "Clicked")
   
      #$scope.loading.show_spinner = true

      if $scope.login_status is "connected"
        console.log "fetch"
        Util.push_ga_event("Petition", "Sign With Facebook", "Fetching (Already Logged In)")
   
        fetch()
      else
        Util.push_ga_event("Petition", "Sign With Facebook", "Logging In")
   
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
        console.log "Response Status is " + response.status
        if response.status is "connected"
          
          Util.push_ga_event("Petition", "Facebook Status", "Connected")
   
          # connected
          scope.auth = response.authResponse
        else if response.status is "not_authorized"
          Util.push_ga_event("Petition", "Facebook Status", "Not Authorized")
        
        # not_authorized
        else
          Util.push_ga_event("Petition", "Facebook Status", "Not Logged In")
        
          # not_logged_in
        scope.login_status = response.status
        scope.$apply()

      FB.Event.subscribe "edge.create", (response) ->
        window.top.location.href = "url"

      return null
    return null