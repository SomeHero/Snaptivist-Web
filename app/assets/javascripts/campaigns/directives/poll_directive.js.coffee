@app.directive 'ngPoll', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    page: '=page'
    isAdmin: '=isAdmin'
  }
  templateUrl: '/campaigns/partials/poll_template'
  link: (scope, element, attrs) ->
    scope.remove_poll_choice_clicked = (poll_choice) ->
      console.log "number of options " + scope.page.action.poll_choices.length

      scope.page.action.poll_choices.splice(scope.page.action.poll_choices.indexOf(poll_choice), 1) 
  controller: ($scope, $attrs) ->
    $scope.page.action.selected_poll_choice = $scope.page.action.poll_choices[0]

    $scope.poll_choice_clicked = (poll_choice) ->
      console.log "poll choice clicked"

      $scope.page.action.selected_poll_choice = poll_choice

    $scope.set_poll_choice_icon = (poll_choice) ->
      if(poll_choice == $scope.page.action.selected_poll_choice)
        return "fa-circle"
      else
        return "fa-circle-o"
]
