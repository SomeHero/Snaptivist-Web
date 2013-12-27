@app.factory "ThemeServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_themes: (layout_id) ->
    console.log "Getting Themes"
    deferred = $q.defer()
    $http.get('/api/themes?layout_id=' + layout_id).success (response) ->
      deferred.resolve(response)

    deferred.promise
]
