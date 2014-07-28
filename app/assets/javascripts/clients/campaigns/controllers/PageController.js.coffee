@PageController = ($scope, $rootScope, PageServices) ->

	$scope.add_page = (page) ->
		$scope.campaign.pages.push({
			page_id: page.id
			page: page
			position: $scope.campaign.pages.length + 1
			expanded: true
		})
		$scope.campaign.pages[$scope.campaign.pages.length-1].action = {
			name: ''
			type: 'Poll'
			poll_choices: [{
				label: ""
				position: 1
			}, {
				label: ""
				position: 2
			}, {
				label: ""
				position: 3
			}]
		}

		return

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