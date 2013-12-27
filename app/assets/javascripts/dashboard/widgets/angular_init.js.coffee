@app = angular.module('widgets', ['ui.bootstrap'])
	.value('$anchorScroll', angular.noop)

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/create'
  $routeProvider.when('/create',
    templateUrl: '/client_views/standard'
    controller: WidgetController 
  ).otherwise redirectTo: base_page_url
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]
