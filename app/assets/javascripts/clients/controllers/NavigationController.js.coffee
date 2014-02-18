@NavigationController = ($scope, $rootScope, $location) ->
	
	validate_step = (step) ->
		if step == 1
			return $scope.petition.title && $scope.petition.subdomain || false
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

	$scope.disabled_step_styling = (step) ->
		if step == 2 && !validate_step(1)
			{			
				'color': 'gray'
			}
		else if step == 3 && !(validate_step(1) && validate_step(2))
			{			
				'color': 'gray'
			}
		else if step == 4  && !(validate_step(1) && validate_step(2) && validate_step(3))
			{			
				'color': 'gray'
			}
		else if step == 5 && !(validate_step(1) && validate_step(2) && validate_step(3) && validate_step(4))
			{			
				'color': 'gray'
			}
		else if step == 6 && !(validate_step(1) && validate_step(2) && validate_step(3) && validate_step(4) && validate_step(5))
			{			
				'color': 'gray'
			}

	$scope.goto_step_clicked = (step) ->
		console.log("step clicked")
		
		if !validate_step(step - 1)
			return

		$scope.settings.step = step

		$location.hash($scope.settings.step)


