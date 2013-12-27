#
#* Checks every $digest for height changes
# 
@app.directive "emHeightSource", ["$timeout", ($timeout) ->
  link: (scope, elem, attrs) ->
    scope.$watch ->
      scope.__height = elem.height()

]
@app.directive "sizeColumn", ->
  (scope, element, attrs) ->
    attrs.$observe "equaliseHeightsDir", (value) ->
      items = angular.element(value)

    equaliseHeight = () ->
      element.parent().children().css "height", element.closest(".row").height()
    
    equaliseHeight();

    angular.element(window).resize(equaliseHeight);