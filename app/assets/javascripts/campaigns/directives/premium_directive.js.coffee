@app.directive 'ngPremium', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    segment: '=segment'
    content: '='
    action: '='
    isAdmin: '='
  }
  templateUrl: '/clients/campaigns/partials/premium_template'
  link: (scope, element, attrs) ->

  controller: ($scope, $attrs) ->

]