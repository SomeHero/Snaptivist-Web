@CommentController = ($scope, $rootScope, CampaignServices) ->
	
	$scope.comments = {
		items: [],
		offset: 0
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

		CampaignServices.get_actions($scope.campaign.id, $scope.comments.offset).then(save_comments, error_comments)

	$scope.show_more_signatures_button = ->
		return $scope.comments.total < $scope.comments.items.length + 1

	save_comments = (response) ->
		console.log "Retrieved Comments"

		i = 0

		while i < response.results.length
			$scope.comments.items.push response.results[i]
			i++	

		$scope.comments.total = response.total
		
	error_comments = (response) ->
		console.log "Failed Getting Comments"

	if $scope.comments.items.length == 0
		CampaignServices.get_actions(scope.campaign.id, $scope.comments.offset).then(save_comments, error_comments)