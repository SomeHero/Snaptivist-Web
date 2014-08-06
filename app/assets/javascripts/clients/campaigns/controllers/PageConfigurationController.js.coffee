@PageConfigurationController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, CampaignServices, ClientFactory, Util, cssInjector, ngDialog) ->

	$scope.new_page = {
		page_config: {}
		action: {}
	}

	if($scope.page && $scope.page.content && $scope.page.content.config)
		$scope.new_page.page_config = $scope.page.content.config
	if($scope.page && $scope.page.content && $scope.page.content.action)
		$scope.new_page.action.type = $scope.page.content.action.type

	$scope.set_segment_selected = (type_name) ->
		if $scope.new_page.action.type == type_name
			return 'selected'

	$scope.set_segment_type = (type_name) ->
        console.log 'setting segment type'

        $scope.new_page.action.type = type_name

	$scope.ok = () ->
		page = $scope.new_page

		if !$scope.campaign.campaign_pages
			$scope.campaign.campaign_pages = []

		$scope.campaign.campaign_pages.push({
			page: page
			page_id: page.id
			position: $scope.campaign.campaign_pages.length + 1
			content: {}
			expanded: true
		})
		if(page.action= "poll_action")
			$scope.campaign.campaign_pages[$scope.campaign.campaign_pages.length-1].action = {
				name: ''
				type: 'Poll'
				poll_choices: [{
					label: ""
					position: 1
				}, {
					label: ""
					position: 2
				}, {
					label: ""
					position: 3
				}]
			}
		if(page.action == "signature_action")
			$scope.campaign.campaign_pages[$scope.campaign.campaign_pages.length-1].action = {
				name: ''
				type: 'Petition'
			}

		ngDialog.close()

	$scope.cancel = () ->
		ngDialog.dismiss()

PageConfigurationController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', 'CampaignServices', 'ClientFactory', 'Util', 'cssInjector', 'ngDialog']
