@CampaignsController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, ClientFactory, CampaignServices, Util) ->
	
	window.scope = $scope

	$scope.campaigns = campaigns
	$scope.client = ClientFactory.client

	ClientFactory.campaigns = campaigns

	$scope.petition_url = (petition) ->
		port = $location.port()

		host = $location.host()
		host += ":" + port if port

		$location.protocol() + "://" + host + "/petitions/" + petition.id

	$scope.copy_project_clicked = () ->
		console.log "copy clicked"

	$scope.archive_project_clicked = () ->
		console.log "archive clicked"

	$scope.delete_project_clicked = (campaign_id) ->

		CampaignServices.delete($scope.client.client_id, campaign_id).then (response) ->
			deferred = $q.defer()
			CampaignServices.get_campaigns($scope.client.client_id).then (response) ->
				$scope.campaigns = response
			deferred.promise

	$scope.new_project_clicked = () ->

		#$scope.loading.show_spinner = false

		modalInstance = $modal.open(
			templateUrl: '/clients/campaigns/partials/new_petition',
			controller: NewCampaignController
		)
		modalInstance.result.then ((campaign) ->
			#$scope.loading.show_spinner = false
			
			if(!campaign)
				return
			
			Util.navigate_absolute('/clients/' + $scope.client.client_id + '/campaigns/' + campaign.id + '#/campaigns/' + campaign.id)

		), ->
			#$scope.loading.show_spinner = false

			console.log "Modal dismissed at: " + new Date()
	  
	$scope.edit_petition = (petition) ->
		ClientFactory.petition = petition

		$location.hash("")
		Util.navigate('/petition_setup')
	
	$scope.settings = {}
	$scope.styles = {
		stylesheet_list: []
	}

	$scope.update_stylesheet_list = () ->
		$scope.styles.stylesheet_list = []
		if $scope.settings.layout
			$scope.styles.stylesheet_list.push({
				href: '/assets/layouts/' + $scope.settings.layout.url_fragment + '.css'
			})
			$scope.styles.stylesheet_list.push({
				href: '/assets/layouts/' + $scope.settings.layout.url_fragment + '-responsive.css'
			})
		if $scope.settings.theme
			$scope.styles.stylesheet_list.push({
				href: '/assets/themes/' + $scope.settings.layout.url_fragment + '/' + $scope.settings.theme.url_fragment + '/style.css' 
			})
			$scope.styles.stylesheet_list.push({
				href: '/assets/themes/' + $scope.settings.layout.url_fragment + '/' + $scope.settings.theme.url_fragment + '/style-responsive.css'
			})
			
CampaignsController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', 'ClientFactory', 'CampaignServices', 'Util']

CampaignsController.resolve =
	campaigns: ['CampaignServices', '$q', (CampaignServices, $q) ->
	
		deferred = $q.defer()

		CampaignServices.get_campaigns(client.client_id).then (response) ->
			deferred.resolve(response)

		deferred.promise

	]