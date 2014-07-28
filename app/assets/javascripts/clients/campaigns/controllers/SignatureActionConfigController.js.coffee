@SignatureActionConfigController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, $modalInstance, CampaignServices, ClientFactory, Util) ->

	$scope.ok = () ->
    	$modalInstance.close($scope.segment_type)

	$scope.cancel = () ->
		$modalInstance.dismiss()

SignatureActionConfigController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', '$modalInstance', 'CampaignServices', 'ClientFactory', 'Util']
