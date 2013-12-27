@PagesConfigurationController = ($scope, $rootScope, $location) ->

	$scope.add_page = (page) ->
		page.expanded = true
		$scope.settings.pages_list.push(page)
		$scope.update_petition_pages()

