@app.factory "PetitionServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get: (client_id) ->
    console.log "Getting Petitions for client"
    deferred = $q.defer()
    $http.get('/api/clients/' + client_id + '/petitions').success (response) ->
      deferred.resolve(response)

    deferred.promise

  create: (client_id, petition, signature_image, premium_image) ->

    data = {}
    data = $.extend true, data, { 'petition': petition }

    files = []

    if signature_image
      files.push({
        name: 'image'
        file: signature_image
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

  update: (client_id, petition, signature_image, premium_image) ->

    data = {}
    data = $.extend true, data, { 'petition': petition }

    files = []

    if signature_image
      files.push({
        name: 'image'
        file: signature_image
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
]
