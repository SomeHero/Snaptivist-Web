@ActivityController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, CampaignFactory, Util, actions) ->

	$scope.navigation.selected = 'activity'

	$scope.client = ClientFactory.client
	$scope.campaign = CampaignFactory.campaign

	$scope.actions = actions.results
	$scope.totalItems = actions.total

	$scope.maxSize = 10

	$scope.change_page = (page) ->
		deferred = $q.defer()

		client_id = $route.current.params["client_id"]
		campaign_id = $route.current.params["campaign_id"]

		offset = (page-1)*$scope.maxSize
		
		CampaignServices.get_actions($scope.campaign.id, offset).then (response) ->

			$scope.actions = response.results
			$scope.totalItems = response.total
			
			$scope.currentPage = page

			deferred.resolve()

		deferred.promise

ActivityController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'CampaignFactory', 'Util', 'actions']

ActivityController.resolve =

	actions: ['CampaignServices', 'CampaignFactory', '$q', '$route', (CampaignServices, CampaignFactory, $q, $route) ->
		deferred = $q.defer()

		client_id = client.client_id
		campaign_id = campaign.id

		CampaignServices.get_actions(campaign_id, 0).then (response) ->
			deferred.resolve(response)

		deferred.promise
	]