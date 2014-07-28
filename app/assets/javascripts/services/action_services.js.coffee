@app.factory "ActionServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

	sign_with_facebook: (action_id, auth, signature) ->
    	console.log "Signing with Facebook"

    	data = {} 
    	data = $.extend true, data, auth
    	data = $.extend true, data, signature

    	$http.post("/api/actions/" + action_id + "/sign_with_facebook", data)

    sign_with_email: (action_id, signature) ->
    	console.log "Signing with Email Address"

    	data = {} 
    	data = $.extend true, data, signature

    	$http.post("/api/actions/" + action_id + "/sign_with_email", data)

    vote_with_facebook: (action_id, poll_choice_id, auth) ->
    	console.log "Voting with Facebook"

    	data = {} 
    	data = $.extend true, data, {'poll_choice_id': poll_choice_id }
    	data = $.extend true, data, auth

    	$http.post("/api/actions/" + action_id + "/vote_with_facebook", data)

    vote_with_email: (action_id, signature) ->
    	console.log "Voting with Email Address"

    	data = {} 
    	data = $.extend true, data, signature

    	$http.post("/api/actions/" + action_id + "/vote_with_email", data)

 ]