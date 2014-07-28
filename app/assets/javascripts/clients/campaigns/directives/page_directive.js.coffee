@app.directive 'ngPage', ['$http', '$templateCache', '$compile', '$timeout', '$window', ($http, $templateCache, $compile, $timeout, $window) ->
  getTemplate = (layout) ->
    baseUrl = "/client_views/" + layout.url_fragment + "/"

    templateUrl = baseUrl + 'page_template.html'
    $http.get(templateUrl,
      cache: $templateCache
    )
  
  loadTemplate = (scope, element, attrs) ->
    getTemplate(scope.layout).success((html) ->
        element.html ""
      ).then((response) ->
        element.append angular.element($compile(response.data)(scope))
      )

  linker = (scope, element, attrs) ->
    scope.$watch 'layout', ((newValue, oldValue) ->
      if(newValue == oldValue) 
        return;
        
      console.log "layout changed"
      loadTemplate(scope, element, attrs)
    ), true

    loadTemplate(scope, element, attrs)

  return (
    restrict: 'EA'
    replace: false
    transclude: true
    scope: {
      page: '=page'
      layout: '=layout'
      isAdmin: '=isAdmin'
    }
    link: linker
  )
]


