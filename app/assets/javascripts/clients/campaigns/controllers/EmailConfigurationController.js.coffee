@EmailConfigurationController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, CampaignFactory, Util) ->
	$scope.navigation.selected = 'emails'

	$scope.client = ClientFactory.client
	$scope.campaign = CampaignFactory.campaign

EmailConfigurationController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'CampaignFactory', 'Util']