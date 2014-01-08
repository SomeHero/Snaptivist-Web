@PetitionSetupController = ($scope, $route, $modal, $log, $rootScope, $location, fileReader, ClientFactory, PetitionServices, Util, petition, email_types, layouts) ->
	window.scope = $scope

	$scope.client_id = $scope.client.client_id
	$scope.petition = {}
	$scope.petition = petition if petition
	$scope.is_admin = true
	$scope.disable_forms = true
	$scope.system = {
		email_types: email_types
		layouts: layouts
		themes: []
		pages: []
	}

	$scope.settings = {
		layout: null
		theme: null
		step: 1
		pages_list: []
		show_spinner: true
	}

	$scope.update_petition_pages = () ->
		$scope.petition.petition_pages_attributes = []

		i = 1
		for page_item in $scope.settings.pages_list
			$scope.petition.petition_pages_attributes.push({
				page_id: page_item.id
				position: i
			})
			i++

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

	$scope.petition.petition_pages_attributes = [] if !$scope.petition.petition_pages_attributes
	$scope.settings.pages_list = [] if !$scope.settings.pages_list
	
	if $scope.petition.layout
		$scope.settings.layout = $scope.petition.layout
		$scope.update_stylesheet_list()

	if $scope.petition.theme
		$scope.settings.theme = $scope.petition.theme
		$scope.update_stylesheet_list()

	if $scope.petition.pages
		for page in $scope.petition.pages
			$scope.settings.pages_list.push(page)

	$scope.action_tags = {
		new_tag: ""
		list: []
	}
	if $scope.petition.action_tags
		for tag in $scope.petition.action_tags.split(',')
			$scope.action_tags.list.push({
				name: tag
			})	
	if !$scope.petition.email_configurations_attributes || $scope.petition.email_configurations_attributes.length == 0
		$scope.petition.email_configurations_attributes = []
		for email_type in $scope.system.email_types
			$scope.petition.email_configurations_attributes.push({
				email_type: email_type
				email_type_id: email_type.id
				enabled: email_type.default_state
				from_address: $scope.client.email || "admin@snaptivist.com"
				from_name: $scope.client.name
				subject: email_type.default_subject
			})

	if $location.hash()
		$scope.settings.step = parseInt($location.hash())
	else
		$scope.settings.step = 1

	$scope.publish_clicked = () ->
		console.log "publish clicked"

		$scope.petition.status = "Published"
		$scope.submit_petition()

	$scope.save_clicked = () ->
		console.log "save clicked"

		$scope.submit_petition()

	$scope.cancel_clicked = () ->
		console.log "cancel clicked"

		Util.navigate('petitions')

	$scope.highlight_step = (step) ->
		if step == $scope.settings.step
			return {
				'color':  '#eae874'
			}

	$scope.show_next_button = () ->
		if $scope.settings.step == 6
			return false

		return true

	$scope.content_template_urls = () ->
		if $scope.settings.step == 6
			return "clients/partials/publish"
		else if $scope.settings.step == 5
			return "clients/partials/email_config"
		else if $scope.settings.step == 4
			return "clients/partials/pages"
		else if $scope.settings.step == 3
			return "clients/partials/theme"
		else if $scope.settings.step == 2
			return "clients/partials/layout"
		else
			return "clients/partials/configure"

	$scope.sidebar_template_urls = () ->
		if $scope.settings.step == 6
			return "clients/partials/publish_sidebar"
		else if $scope.settings.step == 5
			return "clients/partials/email_config_sidebar"
		else if $scope.settings.step == 4
			return "clients/partials/pages_sidebar"
		else if $scope.settings.step == 3
			return "clients/partials/theme_sidebar"
		else if $scope.settings.step == 2
			return "clients/partials/layout_sidebar"
		else
			return "clients/partials/configure_sidebar"

	$scope.items = ['item1', 'item2', 'item3'];

	errorMessages =
		petition_name: ->
			required = "You must specify a name for your petition."
			required: required
		subdomain: ->
			required = "You must specify a subdomain for your petition"
			pattern = "The subdomain cannot contain special characters"
			required: required
			pattern: pattern
		headline_primary: ->
			required = "You must specify the text for the 'Signature Headline'."
			required: required
		headline_secondary: ->
			required = "You must specify the text for the 'Signature Headline (Secondary)'."
			required: required
		sign_with_facebook_cta_button_text: ->
			required = "You must specify the text for the 'Sign with Facebook' button."
			required: required
		sign_with_email_cta_button_text: ->
			required = "You must specify the text for the 'Sign with Email Address' button."
			required: required
		target_count: ->
			required = "You must specify the target number of signatures your petition is attempting to collect."
			required: required
		summary: ->
			required = "You must specify the text for 'Petition Summary'."
			required: required
		signature_more_signers_button_text: ->
			required = "You must specify the text for the 'More Signers' button."
			required: required
		delivery_headline_primary: ->
			required = "You must specify the delivery headline for your petition."
			required: required
		delivery_headline_secondary: ->
			required = "You must specify the delivery secondary headline for your petition."
			required: required
		delivery_summary: ->
			required = "You must specify the text for 'Delivery Summary'."
			required: required
		delivery_call_to_action_text: ->
			required = "You must specify the delivery call to action text."
			required: required
		default_tweet_text: ->
			required = "You must specify the default tweet message for your petition."
			required: required
		delivery_call_to_action_button_text: ->
			required = "You must specify the delivery call to action button text for your petition."
			required: required
		delivery_skip_button_text: ->
			required = "You must specify the delivery skip button text for your petition."
			required: required
		delivery_more_tweets_button_text: ->
			required = "You must specify the delivery more tweets button text for your petition."
			required: required
		premium_headline_primary: ->
			required = "You must specify the premium headline text for your petition."
			required: required
		premium_headline_secondary: ->
			required = "You must specify the premium headline secondary for your petition."
			required: required
		premium_summary: ->
			required = "You must specify the premium summary for your petition."
			required: required
		premium_call_to_action_button_text: ->
			required = "You must specify the premium call to action button text for your petition."
			required: required
		donation_page_url: ->
			required = "You must set the Donation Redirect URL for your petition"
			required: required

	$scope.next_step_clicked = (form) ->
		console.log("next clicked")

		if form.$valid && validate_step($scope.settings.step)

			$scope.settings.step = parseInt($scope.settings.step) + 1
					
			$location.hash($scope.settings.step)

		else

			errors = []

			for validations of form.$error
				  count = 0
				  while count < form.$error[validations].length
				  	error_message = errorMessages[form.$error[validations][count].$name]()[validations]
				  	if errors.indexOf(error_message) < 0
				    	errors.push error_message
				    count++

			if $scope.settings.step == 2
				errors.push("You must select a layout for your petition from the layouts on the right.")
			else if $scope.settings.step == 3
				errors.push("You must select a theme for your petition from the themes on the right.")
			else if $scope.settings.step == 4
				if $scope.settings.pages_list.length == 0
					errors.push("You must add atleast 1 page to your petition. Select a page to add from the list of pages on the right.")
				else

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

		$scope.loading.show_spinner = true

		$scope.petition.layout_id = $scope.settings.layout.id
		$scope.petition.theme_id = $scope.settings.theme.id

		delete $scope.petition["layout"]
		delete $scope.petition["theme"]
		delete $scope.petition["pages"]
		delete $scope.petition["signature_image_full_url"]
		delete $scope.petition["delivery_image_full_url"]
		delete $scope.petition["premium_image_full_url"]
		delete $scope.petition["header_image_full_url"]
		delete $scope.petition["footer_image_full_url"]
		delete $scope.petition["share_count"]
		delete $scope.petition["delivery_count"]
		delete $scope.petition["premium_count"]

		if $scope.petition.id
			console.log "update petition"
			PetitionServices.update($scope.client_id, $scope.petition, $scope.header_image_full, $scope.footer_image_full, $scope.image_full, $scope.premium_image).success (response) ->
				console.log "petition update success"

				$scope.loading.show_spinner = false

				Util.navigate('petitions')

			.error ->
				console.log "petition update failed"

				$scope.loading.show_spinner = false

		else
			PetitionServices.create($scope.client_id, $scope.petition, $scope.header_image_full, $scope.footer_image_full, $scope.image_full, $scope.premium_image).success (response) ->
				console.log "petition created"

				$scope.loading.show_spinner = false

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

	$scope.has_header_image = ->
		true
	$scope.header_image_styling = ->
		if $scope.header_image_full_url
			{
				'background-image': 'url(' + $scope.header_image_full_url + ')'
				'background-repeat': 'no-repeat'
				'background-position': '50% 50%'
			}
		else
			{
				'background-image': 'url(' + $scope.petition.header_image_full_url + ')'
				'background-repeat': 'no-repeat'
				'background-position': '50% 50%'
			}
	$scope.has_footer_image = ->
		true

	$scope.footer_image_styling = ->
		if $scope.header_image_full_url
			{
				'background-image': 'url(' + $scope.footer_image_full_url + ')'
				'background-repeat': 'no-repeat'
				'background-position': '50% 50%'
			}
		else
			{
				'background-image': 'url(' + $scope.petition.footer_image_full_url + ')'
				'background-repeat': 'no-repeat'
				'background-position': '50% 50%'
			}


	$scope.signature_image_styling = ->
		if $scope.image_full_url
			{
				'background-image': 'url(' + $scope.image_full_url + ')'
			}
		else
			{
      			'background-image': 'url(' + $scope.petition.signature_image_full_url + ')'
    		}

	$scope.premium_image_styling = ->
		{
			'background-image': 'url(' + $scope.premium_image_url + ')'
		}
	$scope.petition_url = () ->
		port = $location.port

		$location.protocol() + "://" + $location.host() + (port ? ":" + port : "") + "/petitions/" + $scope.petition.id

	$scope.set_layout = (layout) ->
		$scope.settings.layout = layout
		$scope.settings.theme = null
		$scope.update_stylesheet_list()

	$scope.set_theme = (theme) ->
		$scope.settings.theme = theme
		$scope.update_stylesheet_list()

	$scope.get_page_template = (template_name) ->
		"/client_views/" + $scope.settings.layout.url_fragment + "/" + template_name

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

	validate_step = (step) ->
		if step == 1
			return $scope.petition.name && $scope.petition.subdomain || false
		else if step == 2
			return $scope.settings.layout || false
		else if step == 3
			return $scope.settings.theme || false
		else if step == 4
			return $scope.settings.pages_list.length > 0
		else if step == 5
			return $scope.settings.pages_list.length > 0
		else if step == 6
			return $scope.settings.pages_list.length > 0

		return true

	lastRoute = $route.current
	$scope.$on "$locationChangeSuccess", (event) ->
		if $route.current.templateUrl == 'clients/petition_setup'
	  		$route.current = lastRoute
	
PetitionSetupController.$inject = ['$scope', '$route', '$modal', '$log', '$rootScope', '$location', 'fileReader', 'ClientFactory', 'PetitionServices', 'Util', 'petition', 'email_types', 'layouts']

PetitionSetupController.resolve =
  	
  petition: ['PetitionServices', '$q', '$route', (PetitionServices, $q, $route) ->

    if $route.current.params.petition_id
	    petition_id = $route.current.params.petition_id
	    
	    deferred = $q.defer()

	    PetitionServices.get_petition(petition_id).then (response) ->
	      deferred.resolve(response)

	    deferred.promise
    ]

  email_types: ['EmailTypeServices', '$q', (EmailTypeServices, $q) ->
    deferred = $q.defer()

    EmailTypeServices.get_email_types().then (response) ->
      deferred.resolve(response)

    deferred.promise
  ]

  layouts: ['LayoutServices', '$q', (LayoutServices, $q) ->
    deferred = $q.defer()

    LayoutServices.get_layouts().then (response) ->
      deferred.resolve(response)

    deferred.promise

  ]

