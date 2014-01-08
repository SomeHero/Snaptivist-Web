@PetitionController = ($scope, $route, $modal, $log, $rootScope, $location, petitions, ClientFactory, Util) ->
	window.scope = $scope
	$scope.petitions = petitions

	ClientFactory.petitions = petitions

	$scope.petition_url = (petition) ->
		port = $location.port()

		host = $location.host()
		host += ":" + port if port

		$location.protocol() + "://" + host + "/petitions/" + petition.id

	$scope.edit_petition = (petition) ->
		ClientFactory.petition = petition

		$location.hash("")
		Util.navigate('/petition_setup')

PetitionController.resolve =
  petitions: ['PetitionServices', '$q', (PetitionServices, $q) ->
    
    deferred = $q.defer()

    PetitionServices.get(client.client_id).then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]
