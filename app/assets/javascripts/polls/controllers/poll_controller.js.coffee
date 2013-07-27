@PollController = ($scope, PetitionServices, $http, Util, $rootScope) ->

  $scope.poll = poll

  window.scopes = $scope

  $scope.loading =
    show_spinner: false

  $scope.getWidth = ->
    $(window).width()

  $scope.$watch $scope.getWidth, (newValue, oldValue) ->
    console.log "browser width changed"

  window.onresize = ->
    $scope.$apply()

  $scope.has_header_image = ->
    if $scope.poll.image_full
      return true
    else
      return false

  $scope.tweet = 'test'

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

  $scope.$on '$viewContentLoaded', ->
    console.log 'view loaded'

    new_height = $(".view-enter#loaded-view").height()
    if $(".with-rs-slider").length
      new_height += 450 

    $("#view-container").animate({
      height: new_height
    }, 1000, ->
      $scope.$apply ->
        $scope.loading.show_spinner = false
    )

  $scope.load_progress_marker()