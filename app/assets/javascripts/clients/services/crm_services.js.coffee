@app.factory "CrmServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

  save_nation_builder_oauth_credentials: (client_id, nation_builder_oauth_credentials) ->
    console.log "saving nation builder credentials"
    
    
    data = {} 
    data = $.extend true, data, nation_builder_oauth_credentials

    $http.post("/api/clients/" + client_id + "/nation_builder_oauth_credentials", data)
]