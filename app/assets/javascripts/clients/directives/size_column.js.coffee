#
#* Checks every $digest for height changes
# 
@app.directive "emHeightSource", ["$timeout", ($timeout) ->
  link: (scope, elem, attrs) ->
    scope.$watch ->
      scope.__height = elem.closest(".row").prop('scrollHeight')

]
@app.directive "sizeColumn", ->
  (scope, element, attrs) ->
    window.heightScope = scope

    scope.$watch (->
        w: element.closest(".row").prop('scrollWidth')
        h: element.closest(".row").prop('scrollHeight')
      ), ((newValue, oldValue) ->
        
        # Do something ...
        console.log newValue  if newValue.w isnt oldValue.w or newValue.h isnt oldValue.h
        equaliseHeight()
      ), true

    scope.height = () ->
      element.closest(".row").prop('scrollHeight')

    equaliseHeight = () ->
      element.parent().children().css "height", element.closest(".row").prop('scrollHeight')
    
    equaliseHeight()

    angular.element(window).resize(equaliseHeight);