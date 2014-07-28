@CommentController = ($scope, $rootScope) ->
	
	$scope.comments = {
		items: []
	}
	$scope.comments.items = [
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
	$scope.get_avatar_url = (signature, segment) ->
		if($scope.temp_image && $scope.temp_image.url) 
			{
				'width': '128px',
				'height': '123px',
				'background-image': 'url(' + $scope.temp_image.url + ')'
				'background-size': 'cover',
				'background-repeat': 'no-repeat'
				'background-position': '50% 50%'
			} 
		else if segment.background_image
			{
				'background-image': 'url(' + segment.background_image.sizes.full + ')',
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