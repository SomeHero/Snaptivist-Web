@app.directive 'ngSignature', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    segment: '=segment'
    content: '='
    action: '='
    isAdmin: '='
  }
  templateUrl: '/clients/campaigns/partials/signature_template'
  link: (scope, element, attrs) ->

  controller: ($scope, $attrs) ->

]