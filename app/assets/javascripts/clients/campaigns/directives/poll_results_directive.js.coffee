@app.directive 'ngPollResults', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    page: '=page'
    isAdmin: '=isAdmin'
  }
  templateUrl: '/clients/campaigns/partials/poll_results_template'
  link: (scope, element, attrs) ->

  controller: ($scope, $attrs) ->

]