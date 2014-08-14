@app.directive 'ngPoll', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    page: '=page'
    action: '=action'
    isAdmin: '=isAdmin'
  }
  templateUrl: '/campaigns/partials/poll_template'
  link: (scope, element, attrs) ->
    scope.remove_poll_choice_clicked = (poll_choice) ->
      console.log "number of options " + scope.page.action.poll_choices.length

      scope.page.action.poll_choices.splice(scope.page.action.poll_choices.indexOf(poll_choice), 1) 
  controller: ($scope, $attrs) ->
    $scope.action.selected_poll_choice = $scope.action.poll_choices_attributes[0]

    $scope.poll_choice_clicked = (poll_choice) ->
      console.log "poll choice clicked"

      $scope.action.selected_poll_choice = poll_choice

    $scope.set_poll_choice_icon = (poll_choice) ->
      if(poll_choice == $scope.action.selected_poll_choice)
        return "fa-circle"
      else
        return "fa-circle-o"
]
