@ThemeConfigurationController = ($scope, $rootScope, ThemeServices) ->
	
	ThemeServices.get_themes($scope.settings.layout.id).then (response) ->
		$scope.system.themes = response


	$scope.set_theme_item_styling = (theme) ->
		if $scope.settings.theme.id == theme.id
	  		{
	  			'border': 'dashed 2px green';
	  		}

