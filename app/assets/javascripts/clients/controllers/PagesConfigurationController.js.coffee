@PagesConfigurationController = ($scope, $rootScope, PageServices) ->

	PageServices.get_pages($scope.settings.layout.id).then (response) ->
		$scope.system.pages = response

	$scope.add_page = (page) ->
		page.expanded = true
		$scope.settings.pages_list.push(page)
		$scope.update_petition_pages()

