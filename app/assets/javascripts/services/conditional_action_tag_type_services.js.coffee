@app.factory "ConditionalActionTagTypeServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_conditional_action_tag_types: () ->
    console.log "Getting Conditional Action Tag Types"
    deferred = $q.defer()
    $http.get('/api/conditional_action_tag_types').success (response) ->
      deferred.resolve(response)

    deferred.promise


]
