@PetitionDeliveriesController = ($scope, $route, $modal, $log, $rootScope, $location, $routeParams, $q, signatures, PetitionServices) ->
	
	petition_id = $routeParams.petition_id
    
	$scope.signatures = signatures.results
	$scope.totalItems = signatures.total

	$scope.currentPage = 1
	$scope.maxSize = 10

	$scope.change_page = (page) ->
		console.log "page changed"

		offset = (page-1)*$scope.maxSize
		deferred = $q.defer()

		PetitionServices.get_tweets(petition_id, offset).then (response) ->
			$scope.signatures = response.results
			$scope.totalItems = response.total
			
			$scope.currentPage = page

			deferred.resolve()

		deferred.promise

PetitionDeliveriesController.resolve =
  signatures: ['PetitionServices', '$q',  '$route', (PetitionServices, $q, $route) ->
    deferred = $q.defer()

    petition_id = $route.current.params.petition_id
    offset = 0

    PetitionServices.get_tweets(petition_id, offset).then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]