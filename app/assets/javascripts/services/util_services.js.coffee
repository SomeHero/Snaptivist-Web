@app.factory "Util", ['$location', '$window', '$http', '$q', ($location, $window, $http, $q) ->
  data = {}
  data.is_mobile = false

  data: -> data

  set_data: (hash) ->
    data = $.extend true, data, hash

  # True if it is a screen that the mobile CSS would be active
  mobile_screen: ->
    $(window).width() < 959

  # Returns boolean based on if we believe the device has a native email client
  non_desktop: ->
    /Android|Mobile|webOS/.test navigator.userAgent

  navigate_home: -> $window.location.href = '/'

  navigate_back: -> $window.history.back()

  navigate_absolute: (url, hash) ->
    $window.location.hash = hash
    $window.location.pathname = url

  navigate: (url, query_params) ->
    #console.log "navigating to: " url
    $location.path(url)
    for k,v of query_params
      $location.search k, String(v).replace(" ", "+")

  hide_iframe: ->
    parent.hideIframe()

  browser_supports_flash: ->
    (typeof navigator.plugins isnt "undefined" and typeof navigator.plugins["Shockwave Flash"] is "object") or
      (window.ActiveXObject and (new ActiveXObject("ShockwaveFlash.ShockwaveFlash")) isnt false)

  log_error: (params) ->
    console.log "ERROR: #{params.event_data}"
    params.client_id = (if data.is_mobile then 2 else 1)
    params.event_id = '13'
    $http.get('/api/log/event', params: params).success (response) ->
      console.log "Error message successful submitted to backend"

  query_params_obj:  ->
    if $window.location.search
      window_params = JSON.parse('{"' +
        decodeURI($window.location.search.replace(/^\?/,"").replace(/&/g, "\",\"").
        replace(/\=/g,"\":\"")) + '"}')
    else
      window_params = {}
    $.extend(window_params, $location.$$search) #extend with ng params

  create_iframe: (src, passed_params) ->
    params = $.extend(this.query_params_obj(), passed_params)
    if params
      src = "#{src}?#{$.param(params)}"
    console.log "tracking iframe url: ", src if _test_env
    $("<iframe />",
      width: "1"
      height: "1"
      frameborder: "0"
      scrolling: "no"
      style: "position:absolute;left : -9000px;top:-1000px"
      src: src
    ).appendTo "body"

  marketing_pixel: (event, params) ->
    console.log("Attempting to create tracking pixel iframes for event: ", event) if _test_env
    switch event
      when 'Authed'
        this.create_iframe('/tracking/authed', params)
      when 'Accepted_offer'
        this.create_iframe('/tracking/landing', params)
      when 'Purchase'
        this.create_iframe('/tracking/treated', params)

  push_ga_event: (category, action, label, value) ->
    try
      console.log("Adding GA event for: ", action) if _test_env
      _gaq.push ["_trackEvent", category, action, label, value]
    catch e
      console.log "Failed to track event with GA: ", e.message

  terms_of_service: ->
    deferred = $q.defer()
    $http.get('/api/texts/ts_and_cs').success (response) ->
      deferred.resolve(response.result.text) if response.statusCode is 200
    deferred.promise

  track_event: (category, action, label, value, params) ->
    this.push_ga_event(category, action, label, value)
    this.marketing_pixel(category, params)

  # This function searches through query string and returns the key's value
  # both in the base URL but also in the angular's query string (query string after
  # the hash)
  # In the event that there are two query strings with the same name, it will default
  # to the first one, and defaults to base URL's version over angular's
  get_parameter: (param) ->
    url = location.search
    url = url.substring(url.indexOf("?") + 1, (if url.indexOf("\n#") > -1 then url.indexOf("#") else url.length))
    params = url.split("&")
    i = 0
    len = params.length

    while i < len
      tmp = params[i].split("=")
      return tmp[1]  if param is tmp[0]
      i++

    if $location.$$search[param] then $location.$$search[param] else null
]


