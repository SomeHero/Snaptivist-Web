@app.factory "SupporterServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

    get_supporters: (client_id, offset) ->
        console.log "Fetch supporters for client: ", client_id

        deferred = $q.defer()
        $http.get('/api/clients/' + client_id + '/supporters?offset=' + offset)
            .success (response) ->
              deferred.resolve(response)
            .error (response) ->
                deferred.reject(response)

        deferred.promise
]