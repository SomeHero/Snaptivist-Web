@app.factory "ActionServices", ['$http', '$q', '$rootScope', ($http, $q, $rootScope) ->

	create: (campaign, action, action_response) ->
		console.log "saving action response"

		$http.post("/api/campaigns/" + campaign.id + "/actions/" + action.id, action_response)

	get_responses: (campaign, action) ->
		console.log "saving action response"

		$http.get("/api/campaigns/" + campaign.id + "/actions/" + action.id + "/responses")
]
		
	