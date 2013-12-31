@PetitionPremiumsController = ($scope, $route, $modal, $log, $rootScope, $location, $routeParams, $q, premiums, PetitionServices) ->
	
	petition_id = $routeParams.petition_id
    
	$scope.premiums = premiums.results
	$scope.totalItems = premiums.total

	$scope.currentPage = 1
	$scope.maxSize = 10

	$scope.change_page = (page) ->
		console.log "page changed"

		offset = (page-1)*$scope.maxSize
		deferred = $q.defer()

		PetitionServices.get_premiums(petition_id, offset).then (response) ->
			$scope.premiums = response.results
			$scope.totalItems = response.total
			
			$scope.currentPage = page

			deferred.resolve()

		deferred.promise

PetitionPremiumsController.resolve =
  premiums: ['PetitionServices', '$q',  '$route', (PetitionServices, $q, $route) ->
    deferred = $q.defer()

    petition_id = $route.current.params.petition_id
    offset = 0

    PetitionServices.get_premiums(petition_id, offset).then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]