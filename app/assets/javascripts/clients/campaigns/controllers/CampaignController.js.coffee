@CampaignController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, CampaignFactory, Util, cssInjector, campaign, pages, layouts, themes, email_types, ngDialog) ->
	window.scope = $scope

	$scope.is_admin = true
	
	#$scope.navigation.selected = 'pages'
	selected_page_index = 0

	CampaignFactory.campaign = campaign

	$scope.client = ClientFactory.client
	$scope.campaign = CampaignFactory.campaign

	$scope.campaign.layout = layouts[0]
	$scope.campaign.theme = themes[0]

	$scope.selected_page = $scope.campaign.campaign_pages[selected_page_index]

	$scope.system = {
		pages: pages
		layouts: layouts
		themes: themes
		email_types: email_types
	}
	$scope.settings = {}
	$scope.styles = {
		stylesheet_list: []
	}
	$scope.action_tags = {
		new_tag: ""
		list: []
	}
	$scope.stylesheets = () ->
		return $scope.styles.stylesheet_list

	$scope.petition_url = (petition) ->
		port = $location.port()

		host = $location.host()
		host += ":" + port if port

		$location.protocol() + "://" + host + "/petitions/" + petition.id

	$scope.edit_petition = (petition) ->
		ClientFactory.petition = petition

		$location.hash("")
		Util.navigate('/petition_setup')

	$scope.set_tab_state = (tab) ->
		if $scope.navigation.selected == tab
			return "active"
		else
			return ""

	$scope.set_selected_page_index = (index) ->
		selected_page_index = index
		$scope.selected_page = $scope.campaign.campaign_pages[selected_page_index]

	$scope.add_page_clicked = () ->
		$scope.page = {}
		dialog = ngDialog.open({ 
			template: '/clients/partials/page_config' 
			scope: $scope
		});

		dialog.closePromise.then (data) ->
  			console.log data.id + " has been dismissed."

	$scope.remove_page = (index) ->
		$scope.campaign.campaign_pages.splice(index, 1)	

	$scope.toggle_page = (page) ->
		page.expanded = !page.expanded

	$scope.update_stylesheet_list = () ->
		$scope.styles.stylesheet_list = []
		if $scope.settings.layout
			cssInjector.add('/assets/layouts/' + $scope.settings.layout.url_fragment + '.css')
			cssInjector.add('/assets/layouts/' + $scope.settings.layout.url_fragment + '-responsive.css')

		if $scope.settings.theme
			cssInjector.add('/assets/themes/' + $scope.settings.layout.url_fragment + '/' + $scope.settings.theme.url_fragment + '/style.css')
			cssInjector.add('/assets/themes/' + $scope.settings.layout.url_fragment + '/' + $scope.settings.theme.url_fragment + '/style-responsive.css')
	
	if $scope.campaign.layout
		$scope.settings.layout = $scope.campaign.layout
		$scope.update_stylesheet_list()

	if $scope.campaign.theme
		$scope.settings.theme = $scope.campaign.theme
		$scope.update_stylesheet_list()

	$scope.action_tags_clicked = () ->
		console.log "action tags clicked"
		modalInstance = $modal.open(
			templateUrl: '/clients/partials/configure'
			controller: ActionTagsController
			resolve: 
				campaign: ->
					$scope.campaign
		)

	$scope.change_layout_clicked = () ->
		console.log "change layout clicked"
		modalInstance = $modal.open(
			templateUrl: '/clients/partials/layout'
			controller: ChangeLayoutController
			resolve: 
				layouts: ->
					$scope.system.layouts
				settings: ->
					$scope.settings
		)
		modalInstance.result.then ((layout) ->
			$scope.settings.layout = layout
			cssInjector.removeAll()
			$scope.update_stylesheet_list()
		), ->
			console.log "Modal dismissed at: " + new Date()

	$scope.config_page_clicked = (page) ->
		console.log "change theme clicked"
		modalInstance = $modal.open(
			templateUrl: '/clients/partials/page_config',
			controller: PageConfigurationController
			resolve: 
				page: ->
					page
		)
		modalInstance.result.then ((new_page) ->
			page.content.config = new_page.page_config
			page.content.action.type = new_page.action.type
		), ->
			console.log "Modal dismissed at: " + new Date()

	$scope.change_theme_clicked = () ->
		console.log "change theme clicked"
		modalInstance = $modal.open(
			templateUrl: '/clients/partials/theme',
			controller: ChangeThemeController
			resolve: 
				themes: ->
					$scope.system.themes
		)
		modalInstance.result.then ((theme) ->
			$scope.settings.theme = theme
			cssInjector.removeAll()
			$scope.update_stylesheet_list()
		), ->
			console.log "Modal dismissed at: " + new Date()
     
	$scope.email_configurations_clicked = () ->
		console.log "email configurations clicked"
		$scope.email_types = email_types

		modalInstance = $modal.open(
			templateUrl: '/clients/partials/email_config',
			controller: EmailConfigurationController
			scope: $scope
		)

	$scope.publish_settings_clicked = () ->
		console.log "publish settings clicked"
		modalInstance = $modal.open(
			templateUrl: '/clients/partials/modal_template',
			controller: PublishController
		)

	$scope.publish_clicked = () ->
		console.log "save and publish clicked"

		CampaignServices.save(ClientFactory.client.client_id, $scope.campaign, $scope.settings.layout.id, $scope.settings.theme.id).then (response) ->
			Util.navigate_absolute '/clients/' + ClientFactory.client.client_id + '/campaigns'

	$scope.configuration_clicked = () ->
    	ngDialog.open({ 
    		template: '/clients/campaigns/partials/configuration'
    		controller: 'CampaignConfigurationController'
    		scope: $scope
    	});

	$scope.email_setup_clicked = () ->
    	$scope.email_types = $scope.system.email_types
    	
    	ngDialog.open({ 
    		template: '/clients/campaigns/partials/email_setup'
    		controller: 'EmailConfigurationController'
    		scope: $scope
    	});

    $scope.publishers_clicked = () ->
    	ngDialog.open({ 
    		template: '/clients/campaigns/partials/publishers' 
    		controller: 'CampaignPublishersController'
    		scope: $scope
    	});

    $scope.activity_clicked = () ->
    	ngDialog.open({ 
    		template: '/clients/campaigns/partials/activity' 
    		controller: 'CampaignActivityController'
    		scope: $scope
    	});



CampaignController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'CampaignFactory', 'Util', 'cssInjector', 'campaign', 'pages', 'layouts', 'themes', 'email_types', 'ngDialog']

CampaignController.resolve =

	campaign: ['CampaignServices', '$q', '$route', (CampaignServices, $q, $route) ->

		client_id = client.client_id
		campaign_id = campaign.id

		deferred = $q.defer()

		CampaignServices.get_campaign(client_id, campaign_id).then (response) ->
			deferred.resolve(response)

		deferred.promise	
	]
	pages: ['PageServices', '$q', (PageServices, $q) ->
		deferred = $q.defer()

		PageServices.get_pages(1).then (response) ->
			deferred.resolve(response)

		deferred.promise
	]
	themes: ['ThemeServices', '$q', (ThemeServices, $q) ->

		deferred = $q.defer()

		ThemeServices.get_themes().then (response) ->
			deferred.resolve(response)

		deferred.promise
	]

	layouts: ['LayoutServices', '$q', (LayoutServices, $q) ->
		deferred = $q.defer()

		LayoutServices.get_layouts().then (response) ->
			deferred.resolve(response)

		deferred.promise
	]
	email_types: ['EmailTypeServices', '$q', (EmailTypeServices, $q) ->
		deferred = $q.defer()

		EmailTypeServices.get_email_types().then (response) ->
			deferred.resolve(response)

		deferred.promise
	]

