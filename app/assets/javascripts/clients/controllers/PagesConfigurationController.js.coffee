@PagesConfigurationController = ($scope, $rootScope, PageServices) ->

	PageServices.get_pages($scope.settings.layout.layout_id).then (response) ->
		$scope.system.pages = response

	$scope.add_page = (page) ->
		$scope.settings.pages_list.push({
			page_id: page.id
			page: page
			position: $scope.settings.pages_list.length + 1
			expanded: true
		})
		
		$scope.petition.petition_pages_attributes.push({
          page_id: page.id,
          position: $scope.petition.petition_pages_attributes.length + 1
        });

