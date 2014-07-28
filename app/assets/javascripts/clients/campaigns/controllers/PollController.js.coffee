@PollController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, $modalInstance, CampaignServices, ClientFactory, Util, cssInjector) ->

	$scope.segment_type = segment_type

	$scope.set_segment_type = (segment_type) ->
		$scope.segment_type = segment_type

	$scope.ok = () ->
    	$modalInstance.close($scope.segment_type)

	$scope.cancel = () ->
		$modalInstance.dismiss()

PollController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', '$modalInstance', 'CampaignServices', 'ClientFactory', 'Util', 'cssInjector']
