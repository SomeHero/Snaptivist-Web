@PetitionController = ($scope, $route, $modal, $log, $rootScope, $location, petitions, ClientFactory, Util) ->
	window.scope = $scope
	$scope.petitions = petitions

	ClientFactory.petitions = petitions

	$scope.edit_petition = (petition) ->
		ClientFactory.petition = petition

		Util.navigate('/petition_setup')

PetitionController.resolve =
  petitions: ['PetitionServices', '$q', (PetitionServices, $q) ->
    deferred = $q.defer()

    PetitionServices.get(1).then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]
