@SupportersController = ($scope, $route, $modal, $log, $rootScope, $location, $q, SupporterServices, supporters) ->
	
	$scope.supporters = supporters.results
	$scope.totalItems = supporters.total

	$scope.currentPage = 1
	$scope.maxSize = 10

	$scope.change_page = (page) ->
		console.log "page changed"

		offset = (page-1)*$scope.maxSize
		deferred = $q.defer()

		SupporterServices.get_supporters($scope.client.client_id, offset).then (response) ->
			$scope.supporters = response.results
			$scope.totalItems = response.total
			
			$scope.currentPage = page

			deferred.resolve()

		deferred.promise


	$scope.get_avatar_url = (user) ->

		if user.avatar_url 
			{
				'background-image': 'url(' + user.avatar_url + '?type=large)',
				'width': '128px',
				'height': '123px',
				'background-size': 'cover',
				'background-repeat': 'no-repeat',
				'background-position': '50% 50%'
			}
		else
			{
				'background-image': 'url(/assets/jcc_avatar_logo.png)',
				'width': '128px',
				'height': '123px',
				'background-size': 'cover',
				'background-repeat': 'no-repeat',
				'background-position': '50% 50%'
			}

SupportersController.resolve =
  supporters: ['SupporterServices', '$q', (SupporterServices, $q) ->
    deferred = $q.defer()

    SupporterServices.get_supporters(client.client_id, 0).then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]