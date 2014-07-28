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
    
          add_page_tab()
          
        else
          console.log "FB.login cancelled"

          Util.push_ga_event("Petition", "Facebook Login", "Cancelled")

          scope.sign_with_facebook_cancelled()
   
      ),
        scope: "email,manage_pages"

    fetch = ->

      console.log "Signing with Facebook"

      add_page_tab()

    add_page_tab = ->
      FB.ui
        method: "pagetab"
        redirect_uri: "YOUR_URL"
      , (response) ->
        console.log response

        page_id = Object.keys(response.tabs_added)[0]
        FB.api(
          "/" + page_id + "/tabs/app_" + $scope.appId,
          "POST",
          {
            "object": {
              "custom_name": "Hey"
            }
          }, (response) ->
            if (response && !response.error) 
              console.log response
        )
          

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
    scope.appId = attrs.facebook

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