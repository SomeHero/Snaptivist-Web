@app.factory "CommentServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

    get_comments: (petition_id, offset) ->
            console.log "Fetch comments for Petition: ", petition_id

            deferred = $q.defer()
            $http.get('/api/petitions/' + petition_id + '/signatures?offset=' + offset)
                    .success (response) ->
                        deferred.resolve(response)
                    .error (response) ->
                        deferred.reject(response)

            deferred.promise
]