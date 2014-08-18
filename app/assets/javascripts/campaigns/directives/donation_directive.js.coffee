@app.directive 'ngDonation', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    segment: '=segment'
    content: '='
    action: '='
    isAdmin: '='
  }
  templateUrl: '/client_views/layout1/templates/donation_template'
  link: (scope, element, attrs) ->

  controller: ($scope, $attrs) ->

]