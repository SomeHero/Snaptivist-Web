@app.factory "PetitionServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get: (client_id) ->
    console.log "Getting Petitions for client"
    deferred = $q.defer()
    $http.get('/api/clients/' + client_id + '/petitions').success (response) ->
      deferred.resolve(response)

    deferred.promise

  get_petition: (petition_id) ->
    console.log "Getting Petition"
    deferred = $q.defer()
    $http.get('/api/petitions/' + petition_id).success (response) ->
      deferred.resolve(response)

    deferred.promise

  create: (client_id, petition, content, header_image, footer_image, signature_image, delivery_image, premium_image) ->

    data = {}
    data = $.extend true, data, { 'petition': petition, 'content': content }

    files = []

    if header_image
      files.push({
        name: 'header_image'
        file: header_image
      })
    if footer_image
      files.push({
        name: 'footer_image'
        file: footer_image
      })
    if signature_image
      files.push({
        name: 'image'
        file: signature_image
      })
    if delivery_image
      files.push({
        name: 'delivery_image'
        file: delivery_image
      })
    if premium_image
      files.push({
        name: 'premium_image'
        file: premium_image
      })

    $http({
      method: 'POST'
      url: '/api/clients/' + client_id + '/petitions'
      headers: 
      	"Content-Type": false
      transformRequest: (data) ->
        formData = new FormData()
        formData.append "petition", angular.toJson(data.model.petition)

        i = 0
        while i < data.files.length
          formData.append "file_" + data.files[i].name, data.files[i].file
          i++
        return formData

      data:
        model: {
          'petition': petition
        },
        files: files

    })

  update: (client_id, petition, content, header_image, footer_image, signature_image, delivery_image, premium_image) ->

    data = {}
    data = $.extend true, data, { 'petition': petition, 'content': content }

    files = []

    if header_image
      files.push({
        name: 'header_image'
        file: header_image
      })
    if footer_image
      files.push({
        name: 'footer_image'
        file: footer_image
      })
    if signature_image
      files.push({
        name: 'image'
        file: signature_image
      })
    if delivery_image
      files.push({
        name: 'delivery_image'
        file: delivery_image
      })
    if premium_image
      files.push({
        name: 'premium_image'
        file: premium_image
      })

    $http({
      method: 'PUT'
      url: '/api/clients/' + client_id + '/petitions/' + petition.id
      headers: 
        "Content-Type": false
      transformRequest: (data) ->
        formData = new FormData()
        formData.append "petition", angular.toJson(data.model.petition)
        formData.append("content", angular.toJson(data.model.content));
              
        i = 0
        while i < data.files.length
          formData.append "file_" + data.files[i].name, data.files[i].file
          i++
        return formData

      data:
        model: {
          'petition': petition,
          'content': content
        },
        files: files

    })

  get_signatures: (petition_id, offset) ->
    console.log "Fetch premiums for petition: ", petition_id

    deferred = $q.defer()
    $http.get('/api/petitions/' + petition_id + '/signatures?offset=' + offset)
        .success (response) ->
          deferred.resolve(response)
        .error (response) ->
            deferred.reject(response)

    deferred.promise

  get_shares: (petition_id, offset) ->
    console.log "Fetch share for petition: ", petition_id

    deferred = $q.defer()
    $http.get('/api/petitions/' + petition_id + '/shares?offset=' + offset)
        .success (response) ->
          deferred.resolve(response)
        .error (response) ->
            deferred.reject(response)

    deferred.promise

  get_tweets: (petition_id, offset) ->
    console.log "Fetch premiums for petition: ", petition_id

    deferred = $q.defer()
    $http.get('/api/petitions/' + petition_id + '/tweets?offset=' + offset)
        .success (response) ->
          deferred.resolve(response)
        .error (response) ->
            deferred.reject(response)

    deferred.promise

  get_premiums: (petition_id, offset) ->
    console.log "Fetch premiums for petition: ", petition_id

    deferred = $q.defer()
    $http.get('/api/petitions/' + petition_id + '/premiums?offset=' + offset)
        .success (response) ->
          deferred.resolve(response)
        .error (response) ->
            deferred.reject(response)

    deferred.promise
]
