@app.directive 'ngPollResults', ['$timeout', '$window', ($timeout, $window) ->
  restrict: "A"
  replace: true
  scope: {
    campaign: '=campaign'
    action: '=action'
    page: '=page'
    isAdmin: '=isAdmin'
  }
  templateUrl: '/client_views/layout1/templates/poll_results_template'
  link: (scope, element, attrs) ->

  controller: ($scope, $attrs) ->

  	default_poll_choices = [{
  		label: "Yes"
  		percentage: 18
  		position: 1
  	}, {
  		label: "No",
  		percentage: 32
  		position: 2
  	}, {
  		label: "Maybe",
  		percentage: 40
  		position: 3
  	}, {
  		label: "Sort Of",
  		percentage: 10
  		position: 4
  	}]

  	get_poll = () ->
  		if $scope.action.poll
  			return $scope.action.poll

  		for page in scope.campaign.campaign_pages
  			if(page.action && page.action.type == 'poll_action')
  				return page.action

  	get_poll_choices = () ->
  		poll = get_poll()

  		if poll
  			$scope.action.poll_id = poll.id
  			for poll_choice in poll.poll_choices_attributes
  				percentage = 1/poll.poll_choices_attributes.length * 100
  				poll_choice.percentage = percentage.toFixed(2)
  				
  			poll.poll_choices_attributes
  		else
  			default_poll_choices

  	$scope.poll_choices = get_poll_choices()

]