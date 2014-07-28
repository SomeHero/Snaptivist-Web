@CampaignActivityController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, CampaignFactory, Util) ->
	
	include_pages = ['/clients/campaigns/partials/includes/traffic_information', '/clients/campaigns/partials/includes/mobile_usage', '/clients/campaigns/partials/includes/referrers', '/clients/campaigns/partials/includes/action_takers']
	
	selected_index = 0

	$scope.client = ClientFactory.client
	$scope.campaign = CampaignFactory.campaign

	$scope.get_template = () ->
		include_pages[selected_index]

	$scope.set_style = (index) ->
		if index == selected_index
			"active"

	$scope.set_selected_index = (index) ->
		selected_index = index
			
CampaignActivityController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'CampaignFactory', 'Util']