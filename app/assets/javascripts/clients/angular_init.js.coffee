@app = angular.module 'clients', ['contenteditable']

@app.config ['$routeProvider', ($routeProvider) ->
  base_page_url = '/home'
  $routeProvider
    .when('/home',
    templateUrl: 'clients/home'
  ).when('/petition_setup',
    templateUrl: 'clients/petition_setup'
  ).when('/petition_pages',
    templateUrl: 'clients/pages'
  ).when('/customers',
    templateUrl: 'clients/customers'
  ).otherwise(redirectTo: base_page_url)
]

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]


@app.run ['$q', '$rootScope', ($q, $rootScope) ->
]
