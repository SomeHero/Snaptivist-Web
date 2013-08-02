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
  
  sign_with_facebook: (auth, petition_id, signature) ->
    console.log "Petition Services: Signing with Facebook"

    data = {} 
    data = $.extend true, data, auth
    data = $.extend true, data, signature

    $http.post("/api/petitions/" + petition_id + "/sign_with_facebook", data)

  sign_with_email_address: (petition_id, signature) ->
    console.log "Petition Services: Signing with Email Address"

    $http.post("/api/petitions/" + petition_id + "/sign", signature)

  sign_another: (petition_id, signature) ->
    console.log "Petition Services: Signing Another Petition"

    $http.post("/api/petitions/" + petition_id + "/sign_another", signature)

  check_twitter_connect: () ->
    deferred = $q.defer()
    
    $http.get("/auth/check/twitter").success (response) ->
      if response.authed
        deferred.resolve(response)
      else
        deferred.reject(response)
    deferred.promise

  share_with_facebook: (petition_id, signature_id) ->
    console.log "Signature Shared! ", signature_id
    
    data = {} 
    data = $.extend true, data, { 'signature_id': signature_id }
   
    $http.post("/api/petitions/" + petition_id + "/share_with_facebook", data)

  deliver_signature: (petition_id, signature_id, tweet) ->
    console.log "Delivering Signature: ", signature_id
    
    data = {} 
    data = $.extend true, data, { 'tweet': tweet }
    data = $.extend true, data, { 'signature_id': signature_id }
   
    $http.post("/api/petitions/" + petition_id + "/share", data)

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
