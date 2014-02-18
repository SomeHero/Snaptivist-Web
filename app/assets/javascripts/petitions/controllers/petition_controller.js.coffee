@PetitionController = ($scope, PetitionServices, $http, Util, PetitionFactory, $rootScope, $interpolate) ->

  $scope.is_admin = false
  $scope.disable_forms = false

  $scope.layout = 'layout1'
  $scope.theme = 'standard'

  $scope.loading = 
    show_spinner: false

  $scope.petition = petition
  $scope.content = content

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
      href: '/assets/layouts/' + $scope.petition.layout.url_fragment + '.css'
    },
    {
      href: '/assets/layouts/' + $scope.petition.layout.url_fragment + '-responsive.css'
    },
    {
      href: '/assets/themes/' + $scope.petition.layout.url_fragment + '/' + $scope.petition.theme.url_fragment + '/style.css'
    }, {
      href: '/assets/themes/' + $scope.petition.layout.url_fragment + '/' + $scope.petition.theme.url_fragment + '/style-responsive.css'
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

  window.scope = $scope

  $scope.has_header_image = ->
    return $scope.petition.header_image_full_url

  $scope.header_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.header_image_full_url + ')'
      'background-repeat': 'no-repeat'
      'background-position': '50% 50%'
    }

  $scope.has_footer_image = ->
    return $scope.petition.footer_image_full_url

  $scope.footer_image_styling = ->
    {
      'background-image': 'url(' + $scope.petition.footer_image_full_url + ')'
      'background-repeat': 'no-repeat'
      'background-position': '50% 50%'
    }

  $scope.change_page = () ->
    page= $scope.petition.pages[$scope.page_index++]

    $scope.loading.show_spinner = false

    if !page
      return

    if page.url_redirect
      Util.navigate_absolute $scope.petition[page.url_redirect_property], "", false
    else
      Util.navigate page.url_fragment

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

    $scope.change_page()

  $scope.$on 'premiumComplete', ->
    console.log 'premium Complete'

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

  $scope.load_progress_marker()

  $scope.client_image_url = () ->
    $scope.petition.client.image_large

  if signature
    $scope.signature = signature

    $scope.show.signature = false
    $scope.show.deliver = true

    $scope.scroll_to_deliver()
