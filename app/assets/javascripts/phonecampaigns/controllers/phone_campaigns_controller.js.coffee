@PhoneCampaignsController = ($scope, PhoneCampaignServices, $http, Util, $rootScope) ->

  $scope.phonecampaign = phonecampaign
  $scope.isCollapsed = true
  $scope.summary_more_text = "More"
  $scope.tweet = $scope.phonecampaign.call_results_count + ' demand @' + $scope.phonecampaign.target.twitter_handle + ': ' + $scope.phonecampaign.title + '. Join us: ' + $scope.phonecampaign.short_url
  
  $scope.loading =
    show_spinner: false

  $scope.getWidth = ->
    $(window).width()

  $scope.$watch $scope.getWidth, (newValue, oldValue) ->
    console.log "browser width changed"

  window.onresize = ->
    $scope.$apply()

  window.scope = $scope

  $scope.has_header_image = ->
    if $scope.phonecampaign.image_full
      return true
    else
      return false

  $scope.show_signature_delivered = (signature) ->
    return signature.delivered

  $scope.tweet = $scope.phonecampaign.call_results_count + ' demand @' + $scope.phonecampaign.target.twitter_handle + ': ' + $scope.phonecampaign.title + '. Join us: ' + $scope.phonecampaign.short_url

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

  #need to refactor in comment controller too
  $scope.get_avatar_url = (user) ->
    if user.avatar_url 
      return user.avatar_url + "?type=large"
    else
      return '/assets/avatar.png'

  $scope.read_summary_click = ->
    $scope.isCollapsed = !$scope.isCollapsed
    if $scope.isCollapsed
      $scope.summary_more_text = "More"
    else
      $scope.summary_more_text = "Less"

  $scope.load_progress_marker()