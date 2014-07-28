@app.directive 'panel', ['$timeout', '$window', ($timeout, $window) ->
  restrict: 'EA'
  templateUrl: '/clients/partials/panel'
  replace: false
  scope: {
    petition: '='
  }
  link: postLink = (scope, element, attrs) ->

    #Assign icon values
    element.find('i').addClass(attrs.icon).addClass(attrs.color)

    #Assign the title
    element.find('.title').text attrs.title

    #Assign the value
    set_value = ->
      element.find('.value').text scope.$eval(attrs.panel) || 0

    scope.$watch 'give_flow', ->
      set_value()
]


