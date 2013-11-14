@app.factory "LayoutServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_layouts: () ->
    console.log "Getting Layouts"
    deferred = $q.defer()
    $http.get('/api/layouts').success (response) ->
      deferred.resolve(response)

    deferred.promise

  
]
