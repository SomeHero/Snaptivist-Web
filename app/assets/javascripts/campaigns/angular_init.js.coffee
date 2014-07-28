@app = angular.module 'campaign', ['ngRoute',  'contenteditable', 'angular.css.injector']

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/'
  $routeProvider.when('/',
    templateUrl: '/campaigns/partials/page'
    controller: CampaignController
  ).when('/:page_id',
    templateUrl: '/campaigns/partials/page'
    controller: CampaignController
  ).otherwise(redirectTo: base_page_url)
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = false 
]
@app.filter "fromNow", ->
  (dateString) ->
    moment(new Date(dateString)).fromNow()

@app.run ['$q', '$rootScope', ($q, $rootScope) ->
]
