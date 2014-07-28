@app.factory "ThemeServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_themes: () ->
    console.log "Getting Themes"
    deferred = $q.defer()
    $http.get('/api/themes').success (response) ->
      deferred.resolve(response)

    deferred.promise
]
