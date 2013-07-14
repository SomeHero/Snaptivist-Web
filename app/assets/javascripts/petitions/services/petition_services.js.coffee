@app.factory "PetitionServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_petition: (petition_id) ->
    console.log "Fetching petition details for petition: ", petition_id
    deferred = $q.defer()
    $http.get('/api/petitions', params: {id: petition_id}).success (response) ->
      if response.statusCode is 200
        deferred.resolve(response)
      else
        deferred.reject(response)
    deferred.promise
  
  sign_with_facebook: (auth, petition_id, comment) ->
    console.log "Petition Services: Signing with Facebook"

    data = {} 
    data = $.extend true, data, auth
    data = $.extend true, data, { 'comment': comment }

    $http.post("/api/petitions/" + petition_id + "/sign_with_facebook", data).success (response) ->
      if response.statusCode is 200
        success response
      else
        error response

  sign_with_email_address: (petition_id, signature) ->
    console.log "Petition Services: Signing with Email Address"

    $http.post("/api/petitions/" + petition_id + "/sign", signature).success (response) ->
      if response.StatusCode is 200
        success response
      else
        error response

  deliver_signature: (petition_id, signature_id, tweet) ->
    console.log "Delivering Signature: ", signature_id
    data =
      tweet: tweet
      signature_id: signature_id
   
    $http.post('/api/petitions/' + petition_id + '/share', data).success (response) ->
      if response.statusCode is 200
        success response
      else
        error response

  get_more_petitions: () ->
    console.log "getting some more petitions"

    deferred = $q.defer()
    $http.get('/api/petitions/more').then (response) ->
      if response.data.statusCode is 200
        deferred.resolve(response.data.result.petitions)
      else
        deferred.reject(response)
    deferred.promise

]
