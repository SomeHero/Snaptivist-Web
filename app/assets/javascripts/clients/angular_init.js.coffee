@app = angular.module 'clients', ['ngRoute', 'ui.bootstrap', 'toggle-switch']

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/petitions'
  $routeProvider.when('/home',
    templateUrl: '/clients/petitions'
    controller: PetitionController
    resolve: PetitionController.resolve
  ).when('/petitions',
    templateUrl: '/clients/petitions'
    controller: PetitionController
    resolve: PetitionController.resolve
  ).when('/crm_setup',
    templateUrl: 'clients/partials/crms/crm_list'
  ).when('/nation_builder',
    templateUrl: 'clients/partials/crms/nation_builder'
  ).when('/petitions/:petition_id',
    templateUrl: '/clients/petition_setup'
    controller: PetitionSetupController
    resolve: PetitionSetupController.resolve
  ).when('/petitions/:petition_id/dashboard',
    templateUrl: 'clients/petitions'
    controller: PetitionController
    resolve: PetitionController.resolve
  ).when('/petitions/:petition_id/signatures',
    templateUrl: 'clients/petition_signatures'
    controller: PetitionSignaturesController
    resolve: PetitionSignaturesController.resolve
  ).when('/petitions/:petition_id/shares',
    templateUrl: 'clients/petition_shares'
    controller: PetitionSharesController
    resolve: PetitionSharesController.resolve
  ).when('/petitions/:petition_id/deliveries',
    templateUrl: 'clients/petition_deliveries'
    controller: PetitionDeliveriesController
    resolve: PetitionDeliveriesController.resolve
  ).when('/petitions/:petition_id/premiums',
    templateUrl: 'clients/petition_premiums'
    controller: PetitionPremiumsController
    resolve: PetitionPremiumsController.resolve
  ).when('/petition_setup',
    templateUrl: 'clients/petition_setup'
    controller: PetitionSetupController
    resolve: PetitionSetupController.resolve
  ).when('/petition_pages',
    templateUrl: 'clients/pages'
  ).when('/supporters',
    templateUrl: 'clients/supporters'
    controller: SupportersController
    resolve: SupportersController.resolve
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
