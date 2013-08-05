@PetitionController = ($scope, PetitionServices, $http, Util, $rootScope, $interpolate) ->

  Util.push_ga_event("Petition", "Load", "Sign")
   
  $scope.show = {
    signature: true
    deliver: false
    more_actions: false
  }
  $scope.templates = {
    sign_url: '/client_views/sign'
    deliver_url: '/client_views/deliver'
    more_actions_url: '/client_views/more'
  }
  $scope.get_call_to_action_button_copy = ->
    if $scope.show.more_actions
      return "Take More Actions"
    else if $scope.show.deliver
      return "Deliver Your Signature"
    else
     return scope.petition.call_to_action_button_text || "Sign Petition"

  $scope.petition = petition
  $scope.signature = {}

  $scope.deliver = {
    tweet: $interpolate($scope.petition.default_tweet_text || "")($scope)
  }
  $scope.comments = {
    offset: 0
    total: 0
    items: []
  }
  $scope.more_actions = []
  $scope.isCollapsed = true
  $scope.summary_more_text = "More"

  $scope.loading =
    show_spinner: false

  $scope.getWidth = ->
    $(window).width()

  $scope.getSignaturePanelHeight = ->
    $("#sign-panel").height()

  $scope.getDeliverPanelHeight = ->
    $("#deliver-panel").height()

  $scope.$watch $scope.getWidth, (newValue, oldValue) ->
    console.log "browser width changed"

  $scope.$watch $scope.getSignaturePanelHeight, (newValue, oldValue) ->
    console.log "signature panel height changed"

    $("#action-slider").height($("#sign-panel").height())
    $("#actions-container").height($("#sign-panel").height())

    $("#deliver-panel").css("top", $("#sign-panel").height())

  $scope.$watch $scope.getDeliverPanelHeight, (newValue, oldValue) ->
    console.log "deliver panel height changed"

    $("#more-actions-panel").css("top", $("#deliver-panel").position().top + $("#deliver-panel").height())

  window.onresize = ->
    $scope.$apply()

  window.scope = $scope

  $scope.has_header_image = ->
    if $scope.petition.image_full
      return true
    else
      return false

  $scope.show_action_click = ->
    if $scope.show.more_actions
      Util.push_ga_event("Petition", "Action Button Clicked", "More Actions")
    else if $scope.show.deliver
      Util.push_ga_event("Petition", "Action Button Clicked", "Deliver")
    else
      Util.push_ga_event("Petition", "Action Button Clicked", "Signature")

    $scope.scroll_to_signature()

  $scope.scroll_to_signature = ->
    $('body,html').animate
      scrollTop: $("#actions-container").offset().top

  $scope.scroll_to_deliver = ->
    $('#action-slider').animate {
      top: $("#action-slider").position().top - $("#sign-panel").height()
    }, 500, "linear", -> $('#actions-container').animate {
      height: $("#deliver-panel").height()
    }, 300, "linear", -> $('body,html').animate
      scrollTop: $("#actions-container").offset().top

  $scope.scroll_to_more_actions= ->
    $('#action-slider').animate {
      top: $("#action-slider").position().top - $("#deliver-panel").height()
    }, 500, "linear", -> $('#actions-container').animate {
      height: $("#more-actions-panel").height()
    }, 300, "linear", -> $('body,html').animate
      scrollTop: $("#actions-container").offset().top

  $scope.$on 'signedPetition', (event, signature) ->
    console.log 'petition signed'

    $scope.signature = signature
    $scope.loading.show_spinner = false
    $scope.show.deliver = true

    $scope.scroll_to_deliver()

  $scope.$on 'signedPetitionWithFacebook', (event, signature) ->
    console.log 'petition signed with facebook'

    $scope.$apply ->
      if(signature.shared)
        PetitionServices.share_with_facebook($scope.petition.petition_id, signature.signature_id)
        
      $scope.signature = signature
      $scope.loading.show_spinner = false
      $scope.show.deliver = true

    $scope.scroll_to_deliver()

  $scope.$on 'signedPetitionWithFacebookFailed', (event) ->
    console.log 'petition signed with facebook failed'

    $scope.$apply ->
      $scope.loading.show_spinner = false


  $scope.$on 'deliveredPetition', ->
    console.log 'petition delivered'

    PetitionServices.get_more_petitions().then (petitions) ->
      console.log "got some other actions"

      $scope.more_actions = petitions
    
      $scope.loading.show_spinner = false
      $scope.show.more_actions = true

      $scope.scroll_to_more_actions()

  $scope.$on 'skipDelivery', ->

    PetitionServices.get_more_petitions().then (petitions) ->
      console.log "got some other actions"

      $scope.more_actions = petitions
      $scope.show.more_actions = true

      $scope.loading.show_spinner = false
      $scope.scroll_to_more_actions()

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

  $scope.read_summary_click = ->
    $scope.isCollapsed = !$scope.isCollapsed
    if $scope.isCollapsed
      $scope.summary_more_text = "More"
    else
      $scope.summary_more_text = "Less"

  $scope.has_sponsor = ->
    return $scope.petition.client

  $scope.$on '$viewContentLoaded', ->
    console.log 'view loaded'

  $scope.$on 'handleFacebookAuth', (event, source) ->
    console.log "Facebook Login Success"


  $scope.load_progress_marker()

  if signature
    $scope.signature = signature

    $scope.show.signature = false
    $scope.show.deliver = true

    $scope.scroll_to_deliver()
