@app.directive 'ngTweet', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    segment: '=segment'
    content: '='
    action: '='
    isAdmin: '='
  }
  templateUrl: '/clients/campaigns/partials/tweet_template'
  link: (scope, element, attrs) ->
    console.log "tweet setup"

  controller: ($scope, $attrs) ->

]