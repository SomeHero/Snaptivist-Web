@PetitionController = ($scope, PetitionServices, $http, Util, PetitionFactory, $rootScope, $interpolate) ->

  Util.push_ga_event("Petition", "Load", "Sign")
   
  $scope.is_admin = false
  $scope.layout = 'layout2'
  $scope.theme = 'standard'

  $scope.petition = petition
  $scope.signature = {}

  $scope.deliver = {
    tweet: $interpolate($scope.petition.default_tweet_text || "")($scope)
  }
  $scope.signature = {
    first_name: ''
    last_name: ''
    email_address: ''
    zip_code: ''
    opt_in: true
    comment: ''
  }
  $scope.comments = {
    offset: 0
    total: 0
    items: []
  }
  $scope.tweets = {
    offset: 0
    total: 0
    items: []
  }
  
  $scope.stylesheet_list = 
    [{
      href: '/assets/layouts/' + $scope.layout + '.css'
    },
    {
      href: '/assets/layouts/' + $scope.layout + '-responsive.css'
    },
    {
      href: '/assets/themes/' + $scope.layout + '_' + $scope.theme + '.css'
    }]

  $scope.stylesheets = () ->
    return $scope.stylesheet_list

  $scope.page_index = 1
  $scope.page_list =  
    [{
      title: 'Signature Page',
      url: '/client_views/' + $scope.layout + '/signature_template',
      route: '/sign'
    }, {
      title: 'Delivery Page',
      url: '/client_views/' + $scope.layout + '/delivery_template',
      route: '/deliver'
    }, {
      title: 'Donation Page',
      url: $scope.petition.donation_page_url,
      route: ''
    }, {
      title: 'Premium Page',
      url: '/client_views/' + $scope.layout + '/premium_template',
      route: '/premium'
    }]

  $scope.pages = () ->
    return $scope.page_list

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

  $scope.more_actions = []
  $scope.isCollapsed = true

  $scope.loading =
    show_spinner: false

  window.scope = $scope

  $scope.change_page = () ->
    page = $scope.page_list[$scope.page_index++]

    if page.route.length > 0
      Util.navigate page.route
    else
      Util.navigate_absolute page.url, "", false


  $scope.$on 'signedPetition', (event, signature) ->
    console.log 'petition signed'

    PetitionFactory.signature = signature

    $scope.change_page()

  $scope.$on 'signedPetitionWithFacebook', (event, signature) ->
    console.log 'petition signed with facebook'

    $scope.$apply ->
      if(signature.shared)
        PetitionServices.share_with_facebook($scope.petition.petition_id, signature.signature_id)
        
      PetitionFactory.signature = signature
      $scope.loading.show_spinner = false
      
      $scope.change_page()

  $scope.$on 'signedPetitionWithFacebookFailed', (event) ->
    console.log 'petition signed with facebook failed'

    unless $scope.$$phase
      $scope.$apply ->
        $scope.loading.show_spinner = false
    else
      $scope.loading.show_spinner = false


  $scope.$on 'deliveredPetition', ->
    console.log 'petition delivered'

    $scope.change_page()

  $scope.$on 'skipDelivery', ->

    PetitionServices.get_more_petitions().then (petitions) ->
      console.log "got some other actions"

    $scope.change_page()

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

  $scope.client_image_url = () ->
    $scope.petition.client.image_large

  if signature
    $scope.signature = signature

    $scope.show.signature = false
    $scope.show.deliver = true

    $scope.scroll_to_deliver()
