@app.factory "TweetServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

	get_tweets: (petition_id, offset) ->
		console.log "Fetch comments for Petition: ", petition_id

		deferred = $q.defer()
		$http.get('/api/petitions/' + petition_id + '/tweets?offset=' + offset)
			.success (response) ->
			  if response.statusCode is 200
			    deferred.resolve(response)
			  else
			    deferred.reject(response)
			.error (response) ->
				deferred.reject(response)

		deferred.promise
]
