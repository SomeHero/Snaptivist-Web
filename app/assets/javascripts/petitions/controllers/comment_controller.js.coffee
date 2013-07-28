@CommentController = ($scope, CommentServices, $http, $q, Util, $rootScope) ->
	
	$scope.comments = {
		offset: 0
		total: 0
		items: []
	}

	window.scope.comments = $scope

	$rootScope.$on 'signedPetition', (event, comment) ->
		$scope.comments.items.push comment
  			
	$scope.get_avatar_url = (signature) ->
		if !signature.user
			return '/assets/avatar.png'

		if signature.user.avatar_url 
			return signature.user.avatar_url + "?type=large"
		else
			return '/assets/avatar.png'

	$scope.show_more_signatures_click = ->
		console.log 'Show More Signatures Clicked'

		$scope.comments.offset = $scope.comments.offset + 10

		CommentServices.get_comments($scope.petition.petition_id, $scope.comments.offset).then(save_comments, error_comments)

	$scope.show_more_signatures_button = ->
		return $scope.comments.total < $scope.comments.items.length + 1

	save_comments = (response) ->
		console.log "Retrieved Comments"

		i = 0

		while i < response.result.signatures.length
  			$scope.comments.items.push response.result.signatures[i]
  			i++	

  		$scope.comments.total = response.result.total
		
	error_comments = (response) ->
		console.log "Failed Getting Comments"

	CommentServices.get_comments($scope.petition.petition_id, $scope.comments.offset).then(save_comments, error_comments)
