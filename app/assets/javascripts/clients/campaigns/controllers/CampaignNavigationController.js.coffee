@CampaignNavigationController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, ClientFactory, CampaignFactory, ngDialog) ->

	$scope.navigation = ""
	$scope.action_tags = {
    	new_tag: ""
    	list: []
	}

	$scope.client_id = ClientFactory.client.client_id
	$scope.campaign_id = CampaignFactory.campaign.id

	$scope.set_tab_state = (tab) ->
		if $scope.navigation.selected == tab
			return "active"
		else
			return ""

	$scope.add_action_tag = () ->
	    new_tag = $scope.action_tags.new_tag
	    $scope.action_tags.list.push({
	      name: new_tag
	    })
	    if CampaignFactory.campaign.action_tags
	      CampaignFactory.campaign.action_tags += "," + new_tag  
	    else
	      CampaignFactory.campaign.action_tags = new_tag
	    $scope.action_tags.new_tag = ""

	$scope.configuration_clicked = () ->
    	ngDialog.open({ 
    		template: '/clients/campaigns/partials/configuration',
    		scope: $scope
    	});
     
    $scope.email_setup_clicked = () ->
    	ngDialog.open({ template: '/clients/campaigns/partials/email_setup' });
     
	$scope.publishers_clicked = () ->
    	ngDialog.open({ template: '/clients/campaigns/partials/publishers' });

    $scope.activity_clicked = () ->
    	ngDialog.open({ template: '/clients/campaigns/partials/activity' });


CampaignNavigationController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'ClientFactory', 'CampaignFactory', 'ngDialog']