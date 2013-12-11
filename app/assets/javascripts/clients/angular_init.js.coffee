@app = angular.module 'clients', ['contenteditable', 'angularFileUpload', 'ui.bootstrap']

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/home'
  $routeProvider
    .when('/home',
    templateUrl: 'clients/home'
  ).when('/petitions',
    templateUrl: 'clients/petitions'
    controller: PetitionController
    resolve: PetitionController.resolve
  ).when('/crm_setup',
    templateUrl: 'clients/partials/crms/nation_builder'
    controller: PetitionSetupController
    resolve: PetitionSetupController.resolve
  ).when('/petition_setup',
    templateUrl: 'clients/petition_setup'
    controller: PetitionSetupController
    resolve: PetitionSetupController.resolve
  ).when('/petition_pages',
    templateUrl: 'clients/pages'
  ).when('/supporters',
    templateUrl: 'clients/customers'
  ).otherwise(redirectTo: base_page_url)
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]
@app.filter "fromNow", ->
  (dateString) ->
    moment(new Date(dateString)).fromNow()


@app.run ['$q', '$rootScope', ($q, $rootScope) ->
]
