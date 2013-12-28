@PagesController = ($scope, $rootScope, PageServices) ->

	$scope.remove_page = (page) ->
		for page_item, i in scope.settings.pages_list
			if page_item == page
				$scope.settings.pages_list.splice(i, 1)

	$scope.toggle_page = (page) ->
		page.expanded = !page.expanded


