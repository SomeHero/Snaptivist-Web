@LayoutConfigurationController = ($scope, $rootScope) ->

	$scope.set_layout_item_styling = (layout) ->
		if $scope.settings.layout.layout_id == layout.id
	  		{
	  			'border': 'dashed 2px green';
	  		}
	  		
