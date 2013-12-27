@app.factory "PageServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_pages: (layout_id) ->
    console.log "Getting Pages"
    deferred = $q.defer()
    $http.get('/api/pages?layout_id=' + layout_id).success (response) ->
      deferred.resolve(response)

    deferred.promise
]
