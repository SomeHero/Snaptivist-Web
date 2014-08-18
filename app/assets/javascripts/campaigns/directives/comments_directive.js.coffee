@app.directive 'ngComments', ['$timeout', '$window', 'ActionServices', 'Util', ($timeout, $window, ActionServices, Util) ->
	restrict: "A"
	replace: true
	scope: {
		campaign: '=campaign'
		page: '=page'
		action: '=action'
		content: '=content'
		isAdmin: '=isAdmin'
	}
	templateUrl: '/client_views/layout1/templates/comments_template'
	link: (scope, element, attrs) ->
		console.log "loading comments control"

	controller: ($scope, $attrs) ->
		$scope.comments = {
			items: [],
			offset: 0
		}
		$scope.default_comments = {
			items: [
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 1"
						zip_code: "28027"
					}
					user_id: 843
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 2"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 3"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 4"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 5"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 6"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 7"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 8"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 9"
						zip_code: "28027"
					}
					user_id: 844
				},
				{
					city: "Austin"
					comment: "You have my vote!!!"
					country: "US"
					delivered: false
					state: "TX"
					user: {
						avatar_url: null
						first_name: "A"
						last_name: "Voter 10"
						zip_code: "28027"
					}
					user_id: 844
				}
			]
		}
		$scope.get_avatar_url = (signature) ->
			if !signature.user
				{
					'background-image': 'url(/assets/jcc_avatar_logo.png)',
					'width': '128px',
					'height': '123px',
					'background-size': 'cover',
					'background-repeat': 'no-repeat',
					'background-position': '50% 50%'
				}

			if signature.user.avatar_url 
				{
					'background-image': 'url(' + signature.user.avatar_url + '?type=large)',
					'width': '128px',
					'height': '123px',
					'background-size': 'cover',
					'background-repeat': 'no-repeat',
					'background-position': '50% 50%'
				}
			else
				{
					'background-image': 'url(/assets/jcc_avatar_logo.png)',
					'width': '128px',
					'height': '123px',
					'background-size': 'cover',
					'background-repeat': 'no-repeat',
					'background-position': '50% 50%'
				}

		$scope.display_location = (signature) ->
			if signature.city && signature.state
				return "in " + signature.city + ", " + signature.state
			else
				return ""

		$scope.show_signature_delivered = (signature) ->
			return signature.delivered

		$scope.show_comments = ->
			if $scope.comments.items.length > 0
				return true
			else
				return false

		$scope.show_more_signatures_click = ->
			console.log 'Show More Signatures Clicked'

			$scope.comments.offset = $scope.comments.offset + 10

			ActionServices.get_responses(scope.campaign, scope.page.action, $scope.comments.offset).then(save_comments, error_comments)

		$scope.show_more_signatures_button = ->
			return $scope.comments.total < $scope.comments.items.length + 1

		save_comments = (response) ->
			console.log "Retrieved Comments"

			i = 0

			while i < response.data.results.length
				$scope.comments.items.push response.data.results[i]
				i++	

			$scope.comments.total = response.data.total
			
		error_comments = (response) ->
			console.log "Failed Getting Comments"

		if !$scope.isAdmin && $scope.comments.items.length == 0
			ActionServices.get_responses(scope.campaign, $scope.action, $scope.comments.offset).then(save_comments, error_comments)
		else if $scope.isAdmin
			$scope.comments.items = $scope.default_comments.items
]