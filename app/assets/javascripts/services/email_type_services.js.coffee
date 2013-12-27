@app.factory "EmailTypeServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_email_types: () ->
    console.log "Getting Email Types"
    deferred = $q.defer()
    $http.get('/api/email_types').success (response) ->
      deferred.resolve(response)

    deferred.promise

  
]
