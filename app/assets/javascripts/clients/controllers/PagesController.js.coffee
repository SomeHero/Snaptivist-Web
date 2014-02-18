@PagesController = ($scope, $rootScope, PageServices) ->

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


