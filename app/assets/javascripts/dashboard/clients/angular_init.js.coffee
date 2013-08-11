@app = angular.module('clients', ['ui.bootstrap'])
	.value('$anchorScroll', angular.noop)

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/sign'
  $routeProvider.when('/sign',
    templateUrl: '/client_views/sign'
    controller: SignatureController 
  ).when('/deliver',
    templateUrl: '/client_views/deliver'
    controller: DeliveryController 
  ).when('/complete',
    templateUrl: '/client_views/more'
    controller: MoreActionController 
    resolve: MoreActionController.resolve
  ).otherwise redirectTo: base_page_url
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]
@app.filter "fromNow", ->
  (dateString) ->
    moment(new Date(dateString)).fromNow()