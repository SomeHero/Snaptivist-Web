@app.directive "ngActionGuage", ->
    
    restrict: "A"
    replace: true
    scope: {
      page: '=page'
      action: '=action'
      content: '=content'
      isAdmin: '=isAdmin'
    }
    templateUrl: '/client_views/layout1/templates/action_guage_template'
  
    link: (scope, element, attr) ->

    controller: ($scope, $attrs) ->

      $scope.get_percentage_signed = () ->
        console.log "get percentage signed action.count, segment.target_count"
        
        if !$scope.action.count
          action_count = 10
        else 
          action_count = $scope.action.count
        
        if !$scope.content.target_count
          action_target = 100
        else
          action_target = parseInt($scope.content.target_count, 10)

        if (action_count * 100) / action_target > 100
          return 100
        else
          percentage = (action_count * 100) / action_target
          percentage.toFixed(1)

      $scope.load_progress_marker = () ->
        console.log "load progress marker action.count, segment.target_count"

        if !$scope.action.count
          action_count = 10
        else 
          action_count = $scope.action.count
        
        if !$scope.content.target_count
          action_target = 100
        else
          action_target = parseInt($scope.content.target_count, 10)

        width = $("#progress-bar-wrapper").width()

        percentage = (action_count * 100) / action_target
        if (action_count * 100) / action_target > 100
          percentage = 100

        return (width*(percentage/100)) + $("#progress-marker").width()/2 + "px"

