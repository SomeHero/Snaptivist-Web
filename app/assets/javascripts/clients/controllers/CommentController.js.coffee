@CommentController = ($scope, $rootScope) ->
	
	$scope.comments = {
		items: []
	}
	$scope.comments.items = [
		{
			city: "Concord"
			comment: ""
			country: "US"
			delivered: false
			state: "NC"
			user: {
				avatar_url: null
				first_name: "Al"
				last_name: "J"
				zip_code: "28027"
			}
			user_id: 843
		}
	]
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