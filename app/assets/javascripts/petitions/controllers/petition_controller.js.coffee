@PetitionController = ($scope, PetitionServices, $http, Util, $rootScope) ->

  $scope.petition = petition
  $scope.isCollapsed = true
  $scope.summary_more_text = "More"

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
    if $scope.petition.image_full
      return true
    else
      return false

  $scope.show_signature_delivered = (signature) ->
    return signature.delivered

  $scope.tweet = $scope.petition.signature_count + ' demand @' + $scope.petition.target.twitter_handle + ': ' + $scope.petition.title + '. Join us: ' + $scope.petition.short_url

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

  $scope.$on '$viewContentLoaded', ->
    console.log 'view loaded'

    new_height = $(".view-enter#loaded-view").height()
    if $(".with-rs-slider").length
      new_height += 420 

    $("#view-container").animate({
      height: new_height
    }, 1000)

  $scope.load_progress_marker()