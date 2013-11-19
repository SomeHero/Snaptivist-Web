@app.factory "CommentServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

	get_comments: (petition_id, offset) ->
		console.log "Fetch comments for Petition: ", petition_id

		deferred = $q.defer()
		$http.get('/api/endpoint/')
			.success (response) ->
			  if response.statusCode is 200
			    deferred.resolve(response)
			  else
			    deferred.reject(response)
			.error (response) ->
				deferred.reject(response)

		deferred.promise
]
