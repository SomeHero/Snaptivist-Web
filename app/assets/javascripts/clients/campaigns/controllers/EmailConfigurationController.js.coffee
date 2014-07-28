@EmailConfigurationController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, CampaignFactory, Util) ->
	selected_index = 0
	$scope.selected_email_type = $scope.email_types[selected_index]

	$scope.client = ClientFactory.client
	$scope.campaign = CampaignFactory.campaign

	$scope.set_selected_email_type = (index) ->
		selected_index = index
		$scope.selected_email_type = $scope.email_types[selected_index]

	$scope.set_style = (index) ->
		if index == selected_index
			"active"
			
EmailConfigurationController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'CampaignFactory', 'Util']