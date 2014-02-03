@PagesController = ($scope, $rootScope, PageServices) ->

	$scope.get_pages = ->
		pages = []
		for page_item in scope.petition.petition_pages_attributes
			if !page_item._destroy
				pages.push(page_item)

		return pages

	$scope.remove_page = (page) ->
		for page_item, i in scope.settings.pages_list
			if page.petition_page_id
				if page.petition_page_id == page_item.petition_page_id
					$scope.settings.pages_list.splice(i, 1)	
			else if page.page_id == page_item.page_id
				$scope.settings.pages_list.splice(i, 1)
		for page_item, i in scope.petition.petition_pages_attributes
			if page.petition_page_id == page_item.id
				page_item._destroy = true

	$scope.toggle_page = (page) ->
		page.expanded = !page.expanded


