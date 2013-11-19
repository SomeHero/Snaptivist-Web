@PetitionSetupController = ($scope, $route, $modal, $log, $rootScope, $location, fileReader, PetitionServices, layouts) ->
	window.scope = $scope

	$scope.client_id = $scope.client.client_id
	$scope.is_admin = true
	$scope.layouts = layouts
	$scope.petition = {}

	if $location.hash()
		$scope.step = parseInt($location.hash())
	else
		$scope.step = 1

	$scope.content_template_urls = () ->
		if $scope.step == 5
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
		if $scope.step == 5
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

		client_id = 1

		PetitionServices.create(client_id, $scope.petition, $scope.image_full, $scope.premium_image).success (response) ->
			console.log "petitioin created"
			
			$scope.petition.result = response

			$scope.step += 1
		
			$location.hash($scope.step)

		.error ->
			console.log "create give flow failed"

	$scope.client_image_url = () ->
		$scope.client.image_large
		
	$scope.signature_image_styling = ->
		{
			'background-image': 'url(' + $scope.image_full_url + ')'
		}

	$scope.premium_image_styling = ->
		{
			'background-image': 'url(' + $scope.premium_image_url + ')'
		}

	lastRoute = $route.current
	$scope.$on "$locationChangeSuccess", (event) ->
	  $route.current = lastRoute
	
	PetitionSetupController.$inject = ['$scope', '$route', '$modal', '$log', '$rootScope', '$location', 'fileReader', 'PetitionServices', 'layouts']

PetitionSetupController.resolve =
  layouts: ['LayoutServices', '$q', (LayoutServices, $q) ->
    deferred = $q.defer()

    LayoutServices.get_layouts().then (response) ->
      deferred.resolve(response)

    deferred.promise

    ]

