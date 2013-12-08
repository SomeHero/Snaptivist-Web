@PetitionSetupController = ($scope, $route, $modal, $log, $rootScope, $location, fileReader, ClientFactory, PetitionServices, Util, layouts) ->
	window.scope = $scope

	$scope.client_id = $scope.client.client_id
	$scope.is_admin = true
	$scope.layouts = layouts
	$scope.petition = ClientFactory.petition
	$scope.action_tags = {
		new_tag: ""
		list: []
	}
	for tag in $scope.petition.action_tags.split(',')
		$scope.action_tags.list.push({
			name: tag
		})	

	if $location.hash()
		$scope.step = parseInt($location.hash())
	else
		$scope.step = 1

	$scope.goto_step_clicked = (step) ->
		console.log("step clicked")
		$scope.step = step

		$location.hash($scope.step)

	$scope.highlight_step = (step) ->
		if step == $scope.step
			return {
				'color':  '#eae874'
			}

	$scope.content_template_urls = () ->
		if $scope.step == 6
			return "clients/partials/publish"
		else if $scope.step == 5
			return "clients/partials/email_config"
		else if $scope.step == 4
			return "clients/partials/pages"
		else if $scope.step == 3
			return "clients/partials/theme"
		else if $scope.step == 2
			return "clients/partials/layout"
		else
			return "clients/partials/configure"

	$scope.sidebar_template_urls = () ->
		if $scope.step == 6
			return "clients/partials/publish_sidebar"
		else if $scope.step == 5
			return "clients/partials/email_config_sidebar"
		else if $scope.step == 4
			return "clients/partials/pages_sidebar"
		else if $scope.step == 3
			return "clients/partials/theme_sidebar"
		else if $scope.step == 2
			return "clients/partials/layout_sidebar"
		else
			return "clients/partials/configure_sidebar"

	$scope.items = ['item1', 'item2', 'item3'];

	$scope.next_step_clicked = (form) ->
		console.log("next clicked")

		if form.$valid

			if $scope.step == 5
				$scope.submit_petition()
			else
				$scope.step = parseInt($scope.step) + 1
				
				$location.hash($scope.step)
		else
			errors = []

			if $scope.step == 1
				if form.petition_name.$error['required']
					errors.push("You must specify a name fom your petition.")
				if form.subdomain.$error['required']
					errors.push("You must specify a subdomain fom your petition.")
			else if $scope.step == 4
				if form.headline_primary.$error['required']
					errors.push("You must specify the text for the 'Petition Headline'.")
				if form.sign_with_facebook_cta_button_text.$error['required']
					errors.push("You must specify the text for the 'Sign with Facebook' button.")
				if form.sign_with_email_cta_button_text.$error['required']
					errors.push("You must specify the text for the 'Sign with Email Address' button.")
				if form.target_count.$error['required']
					errors.push("You must specify the target number of signatures your petition is attempting to collect.")
				if form.summary.$error['required']
					errors.push("You must specify the summary text for your petition.")
				if form.signature_more_signers_button_text.$error['required']
					errors.push("You must specify the text for the 'More Signers' button.")

			modalInstance = $modal.open(
			    templateUrl: 'clients/partials/modal_template'
			    controller: ModalInstanceController
			    resolve:
			      items: ->
			        errors
			  )
			modalInstance.result.then ((selectedItem) ->
			    $scope.selected = selectedItem
			  ), ->
			    $log.info "Modal dismissed at: " + new Date()

	$scope.onFileSelect = ($files) ->
	
		#$files: an array of files selected, each file has name, size, and type.
		i = 0

		while i < $files.length
			$file = $files[i]
			$scope.file = $file
			$scope.getFile()
			#upload.php script, node.js route, or servlet upload url
			# method: POST or PUT,
			# headers: {'headerKey': 'headerValue'}, withCredential: true,
			i++

	$scope.getFile = ->
		$scope.progress = 0
		fileReader.readAsDataUrl($scope.file, $scope).then (result) ->
			$scope[$scope.file.file_name + "_url"] = result
			$scope[$scope.file.file_name] = $scope.file

	$scope.submit_petition = () ->

		if $scope.petition.id
			console.log "update petition"
			PetitionServices.update($scope.client_id, $scope.petition, $scope.image_full, $scope.premium_image).success (response) ->
				console.log "petition update success"

				Util.navigate('petitions')

			.error ->
				console.log "petition update failed"
		else
			PetitionServices.create($scope.client_id, $scope.petition, $scope.image_full, $scope.premium_image).success (response) ->
				console.log "petition created"

				Util.navigate('petitions')

			.error ->
				console.log "create petition failed"

	$scope.client_image_url = () ->
		$scope.client.image_large

	$scope.get_tweet_message_length = () ->
		if $scope.petition.default_tweet_text
			return $scope.petition.default_tweet_text.length
		else
			return 0

	$scope.signature_image_styling = ->
		if $scope.image_full_url
			{
				'background-image': 'url(' + $scope.image_full_url + ')'
			}
		else
			{
      			'background-image': 'url(' + $scope.petition.image_full_url + ')'
    		}

	$scope.premium_image_styling = ->
		{
			'background-image': 'url(' + $scope.premium_image_url + ')'
		}
	$scope.petition_url = () ->
		$location.protocol() + "://" + $location.host() + "/petitions/" + $scope.petition.id

	$scope.set_layout = (layout) ->
		$scope.settings.layout = layout.url_fragment
		$scope.update_page_list()
		$scope.update_stylesheet_list()

	$scope.add_action_tag = () ->
		new_tag = $scope.action_tags.new_tag
		$scope.action_tags.list.push({
			name: new_tag
		})
		$scope.action_tags.new_tag = ""
		if $scope.petition.action_tags
			$scope.petition.action_tags += "," + new_tag	
		else
			$scope.petition.action_tags = new_tag

	$scope.delete_action_tag = (tag) ->
		$scope.action_tags.list.splice($scope.action_tags.list.indexOf(tag), 1)	

		$scope.petition.action_tags = ""
		for tag in $scope.action_tags.list
			if $scope.petition.action_tags
				$scope.petition.action_tags += "," + tag.name	
			else
				$scope.petition.action_tags = tag.name			

	lastRoute = $route.current
	$scope.$on "$locationChangeSuccess", (event) ->
		if $route.current.templateUrl == 'clients/petition_setup'
	  		$route.current = lastRoute
	
PetitionSetupController.$inject = ['$scope', '$route', '$modal', '$log', '$rootScope', '$location', 'fileReader', 'ClientFactory', 'PetitionServices', 'Util', 'layouts']

PetitionSetupController.resolve =
  	
  layouts: ['LayoutServices', '$q', (LayoutServices, $q) ->
    deferred = $q.defer()

    LayoutServices.get_layouts().then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]

