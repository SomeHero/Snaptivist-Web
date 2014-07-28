@app.factory "CampaignServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  get_campaigns: (client_id) ->
    console.log "Getting Campaigns for client"
    deferred = $q.defer()
    $http.get('/api/clients/' + client_id + '/campaigns').success (response) ->
      deferred.resolve(response)

    deferred.promise

  get_campaign: (client_id, campaign_id) ->
    console.log "Getting Campaign"
    deferred = $q.defer()
    $http.get('/api/clients/' + client_id + '/campaigns/' + campaign_id).success (response) ->
      deferred.resolve(response)

    deferred.promise

  get_polls: (client_id) ->
    console.log "Getting Polls for client"
    deferred = $q.defer()
    $http.get('/api/clients/' + client_id + '/polls').success (response) ->
      deferred.resolve(response)

    deferred.promise

  get_poll: (client_id, poll_id) ->
    console.log "Getting Poll for client"
    deferred = $q.defer()
    $http.get('/api/clients/' + client_id + '/polls/' + poll_id).success (response) ->
      deferred.resolve(response)

    deferred.promise

  get_actions: (campaign_id, offset) ->
    console.log "Get Actions"

    deferred = $q.defer()
    $http.get('/api/campaigns/' + campaign_id + '/actions?offset=' + offset).success (response) ->
      deferred.resolve(response)

    deferred.promise


  create: (client_id, title, subdomain) ->

    data = {}
    data = $.extend true, data, { 'title': title, 'subdomain': subdomain }

    $http({
      method: 'POST'
      url: '/api/clients/' + client_id + '/campaigns'

      data: data
    })

  save: (client_id, campaign, layout_id, theme_id) ->

    data = campaign
    data = $.extend true, data, { 'layout_id': layout_id, 'theme_id': theme_id }

    $http({
      method: 'PUT'
      url: '/api/clients/' + client_id + '/campaigns/' + campaign.id

      data: data
    })

  delete: (client_id, campaign_id) ->
    $http({
      method: 'DELETE'
      url: '/api/clients/' + client_id + '/campaigns/' + campaign_id
    })
]
