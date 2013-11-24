@app.directive 'panel', ['$timeout', '$window', ($timeout, $window) ->
  restrict: 'EA'
  templateUrl: 'clients/partials/panel'
  replace: false
  scope: true
  link: postLink = (scope, element, attrs) ->

    #Assign icon values
    element.find('i').addClass(attrs.icon).addClass(attrs.color)

    #Assign the title
    element.find('.title').text attrs.title

    #Assign the value
    set_value = ->
      element.find('.value').text 1

    scope.$watch 'give_flow', ->
      set_value()
]


