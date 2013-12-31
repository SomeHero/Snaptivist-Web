@PetitionSharesController = ($scope, $route, $modal, $log, $rootScope, $location, $routeParams, $q, shares, PetitionServices) ->
	
	petition_id = $routeParams.petition_id
    
	$scope.shares = shares.results
	$scope.totalItems = shares.total

	$scope.currentPage = 1
	$scope.maxSize = 10

	$scope.change_page = (page) ->
		console.log "page changed"

		offset = (page-1)*$scope.maxSize
		deferred = $q.defer()

		PetitionServices.get_shares(petition_id, offset).then (response) ->
			$scope.shares = response.results
			$scope.totalItems = response.total
			
			$scope.currentPage = page

			deferred.resolve()

		deferred.promise

PetitionSharesController.resolve =
  shares: ['PetitionServices', '$q',  '$route', (PetitionServices, $q, $route) ->
    deferred = $q.defer()

    petition_id = $route.current.params.petition_id
    offset = 0

    PetitionServices.get_shares(petition_id, offset).then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]