@app = angular.module 'client_campaigns', ['ngRoute', 'angularFileUpload', 'ui.bootstrap', 'toggle-switch', 'angular.css.injector', 'ngDialog']

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/'
  $routeProvider.when('/',
    templateUrl: '/clients/campaigns/campaigns'
    controller: CampaignsController
    resolve: CampaignsController.resolve
  ).when('/campaigns/:campaign_id',
    templateUrl: '/clients/campaigns/campaign'
    controller: CampaignController
    resolve: CampaignController.resolve
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
