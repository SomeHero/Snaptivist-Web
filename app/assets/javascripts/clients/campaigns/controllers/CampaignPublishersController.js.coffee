@CampaignPublishersController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, CampaignFactory, Util) ->
	include_pages = ['/clients/campaigns/partials/includes/publish_snaptivist', '/clients/campaigns/partials/includes/publish_facebook']
	
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
			
CampaignPublishersController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'CampaignFactory', 'Util']