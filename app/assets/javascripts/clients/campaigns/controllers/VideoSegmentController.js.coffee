@VideoSegmentController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, $modalInstance, segment) ->

	$scope.video = {
		embed_code: segment.embed_code
		height: segment.height
		width: segment.width
	}
	
	$scope.ok = () ->
		$modalInstance.close($scope.video)

	$scope.cancel = () ->
		$modalInstance.dismiss()

VideoSegmentController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', '$modalInstance', 'segment']
