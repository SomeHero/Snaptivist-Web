@CampaignController = ($scope, $route, $routeParams, $log, $rootScope, $location, $timeout, CampaignServices, ActionServices, Util, cssInjector) ->
    window.scope = $scope

    $scope.campaign = campaign
    $scope.isAdmin = false

    page_index = 1
    if($routeParams.page_id)
      page_index = $routeParams.page_id

    $scope.page = campaign.campaign_pages[page_index-1]

    $scope.get_percentage_signed = (signatures, target) ->
      if (signatures * 100) / target > 100
        return 100
      else
        return (signatures * 100) / target

    $scope.load_progress_marker = (signatures, target) ->
      width = $("#progress-bar-wrapper").width()

      percentage = (signatures * 100) / target
      if (signatures * 100) / target > 100
        percentage = 100

      return (width*(percentage/100)) + $("#progress-marker").width()/2 + "px"

    $scope.error_messages =
      sign_with_facebook: ""
      sign_with_email_address: ""

    remove_errors = () ->
      $scope.error_messages.deliver_tweet = ""

    $scope.clear_errors = () ->
      $timeout(remove_errors, 4000);

    $scope.signature = {}

    cssInjector.add('/assets/layouts/' + $scope.campaign.layout.url_fragment + '.css')
    cssInjector.add('/assets/layouts/' + $scope.campaign.layout.url_fragment + '-responsive.css')

    cssInjector.add('/assets/themes/' + $scope.campaign.layout.url_fragment + '/' + $scope.campaign.theme.url_fragment + '/style.css')
    cssInjector.add('/assets/themes/' + $scope.campaign.layout.url_fragment + '/' + $scope.campaign.theme.url_fragment + '/style-responsive.css')

    $scope.change_page = () ->
      page= $scope.campaign.campaign_pages[page_index++]

      #$scope.loading.show_spinner = false

      if !page
        return

      if page.url_redirect
        Util.navigate_absolute $scope.petition[page.url_redirect_property], "", false
      else
        Util.navigate_absolute window.location.href + page_index

    $scope.sign_with_facebook = (auth)->
        console.log "Facebook Login Success"

        #$scope.loading.show_spinner = true

        $scope.auth = auth

        ActionServices.sign_with_facebook($scope.page.action.id, $scope.auth, $scope.signature).success (response) ->

            console.log "signature complete; trying to Share via FB"
            
            #$scope.loading.show_spinner = false

            Util.push_ga_event("Action", "Sign With Facebook", "Success")
              
            fb_message_obj =
              method: 'feed'
              redirect_uri: 'YOUR URL HERE'
              #link: $scope.petition.short_url
              name: 'Add Your Voice'
              caption: 'Test Campaign'
              description: 'Description'

            if $scope.campaign.signature_image_square_url
              $.extend true, fb_message_obj, { picture: $scope.petition.signature_image_square_url }
            else  
              $.extend true, fb_message_obj, { picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png' }
              
            FB.ui fb_message_obj, (response) ->

              if response
                console.log "share complete"

                Util.push_ga_event("Petition", "Facebook Share", "Success")

                #signature.shared = true
                $rootScope.$broadcast('signedPetitionWithFacebook', signature)
            
              else
                console.log "error sharing"

                Util.push_ga_event("Petition", "Facebook Share", "Cancelled")
                  
                #signature.shared = false
                #$rootScope.$broadcast('signedPetitionWithFacebook', signature)
            
                $scope.change_page()

          .error (response) ->
            console.log "signature failed: " + response

            $scope.loading.show_spinner = false

            Util.push_ga_event("Petition", "Sign With Facebook", "Failed")

            $scope.error_messages.sign_with_facebook = "We're sorry.  We are unable to collect your signature at this time.  Please try again later."
            $scope.clear_errors()

            #$rootScope.$broadcast('signedPetitionWithFacebookFailed')

    $scope.sign_with_facebook_cancelled = ->
          
        Util.push_ga_event("Petition", "Sign With Facebook", "Cancelled")
                
        $rootScope.$broadcast('signedPetitionWithFacebookFailed')
    
    $scope.sign_with_email_address = (form) ->
      console.log("signing campaign action with email address")

      Util.push_ga_event("Action", "Sign With Email", "Clicked (Pre Form Validation)")
   
      #$scope.loading.show_spinner = true

      $scope.form_submitted = true

      if form.$valid
    
        Util.push_ga_event("Action", "Sign With Email", "Clicked (Post Form Validation)")

        ActionServices.sign_with_email($scope.page.action.id, $scope.signature).success (response) ->

          console.log "signature complete"
          Util.push_ga_event("Actions", "Sign With Email", "Success")
   
          #$scope.loading.show_spinner = false

          #result = response.result

          #$rootScope.$broadcast('signedPetition', result)

          $scope.change_page()
 
        .error (response) ->
          console.log "signature failed: " + response

          Util.push_ga_event("Action", "Sign With Email", "Failed")
   
          $scope.loading.show_spinner = false

          $scope.error_messages.sign_with_email_address = "We're sorry.  We are unable to collect your signature at this time.  Please try again later."
          $scope.clear_errors()

      else
        #$scope.loading.show_spinner = false

        Util.push_ga_event("Action", "Sign With Email", "Clicked (Form Invalid)")
     
        if form.EmailAddress.$error['email']
          $scope.error_messages.sign_with_email_address = "The email address is invalid.  Please type your email again."
        else
          $scope.error_messages.sign_with_email_address = "All fields are required."
        $scope.clear_errors()

    $scope.vote_with_facebook = (auth) ->

      console.log "Facebook Login Success; Signing with Facebook"

      #$scope.loading.show_spinner = true

      $scope.auth = auth

      ActionServices.vote_with_facebook($scope.page.action.id, $scope.page.action.selected_poll_choice.id, $scope.auth).success (response) ->

        console.log "vote with facebook complete"

        #$scope.loading.show_spinner = false

        Util.push_ga_event("Action", "Sign With Facebook", "Success")
          
        fb_message_obj =
          method: 'feed'
          redirect_uri: 'YOUR URL HERE'
          #link: $scope.petition.short_url
          name: 'Add Your Voice'
          caption: 'Test Campaign'
          description: 'Description'

        if $scope.campaign.signature_image_square_url
          $.extend true, fb_message_obj, { picture: $scope.petition.signature_image_square_url }
        else  
          $.extend true, fb_message_obj, { picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png' }
          
        FB.ui fb_message_obj, (response) ->

          if response
            console.log "share complete"

            Util.push_ga_event("Petition", "Facebook Share", "Success")

            #signature.shared = true
            $rootScope.$broadcast('signedPetitionWithFacebook', signature)
        
          else
            console.log "error sharing"

            Util.push_ga_event("Petition", "Facebook Share", "Cancelled")
              
            #signature.shared = false
            #$rootScope.$broadcast('signedPetitionWithFacebook', signature)
        
            $scope.change_page()

      .error (response) ->

        console.log "vote with facebook failed: " + response

        #$scope.loading.show_spinner = false

        Util.push_ga_event("Petition", "Sign With Facebook", "Failed")

        $scope.error_messages.sign_with_facebook = "We're sorry.  We are unable to collect your signature at this time.  Please try again later."
        
        $scope.clear_errors()

        #$rootScope.$broadcast('signedPetitionWithFacebookFailed')

    $scope.onFileSelect = ($files) ->
  
        #$files: an array of files selected, each file has name, size, and type.
        i = 0

        while i < $files.length
          $file = $files[i]
          $scope.file = $file
          $scope.getFile()
          $scope.upload = $upload.upload(
            url: '/images',
            file: $file
          ).progress((evt) ->
            console.log('percent: ' + parseInt(100.0 * evt.loaded / evt.total));
          ).success((data, status, headers, config) ->
            console.log(data)
          )
          #upload.php script, node.js route, or servlet upload url
          # method: POST or PUT,
          # headers: {'headerKey': 'headerValue'}, withCredential: true,
          i++

      $scope.getFile = ->
        $scope.progress = 0
        fileReader.readAsDataUrl($scope.file, $scope).then (result) ->
          $scope[$scope.file.file_name + "_url"] = result
          $scope[$scope.file.file_name] = $scope.file

CampaignController.$inject = ['$scope', '$route', '$routeParams', '$log', '$rootScope', '$location', '$timeout', 'CampaignServices', 'ActionServices', 'Util', 'cssInjector']

