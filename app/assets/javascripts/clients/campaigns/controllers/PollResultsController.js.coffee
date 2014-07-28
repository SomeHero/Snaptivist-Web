@PollResultsController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, $modalInstance, CampaignServices, polls) ->

	window.scope = $scope

	$scope.polls = polls
	$scope.selected_poll = {
		poll: polls[0]
	}

	$scope.ok = () ->
    	$modalInstance.close($scope.selected_poll)

	$scope.cancel = () ->
		$modalInstance.dismiss()

PollResultsController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', '$modalInstance', 'CampaignServices', 'polls']
