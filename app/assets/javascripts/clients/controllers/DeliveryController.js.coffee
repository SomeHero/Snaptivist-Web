@DeliveryController = ($scope, $route, $modal, $log, $rootScope, $location, ClientFactory, Util) ->
	window.delivery_scope = $scope
	
	$scope.delivery_image_styling = ->
		if $scope.delivery_image_url
			{
				'background-image': 'url(' + $scope.delivery_image_url + ')'
			}
		else
			{
				'background-image': 'url(' + $scope.petition.delivery_image_full_url + ')'
			}

	$scope.set_content_width = () ->
		if $scope.has_delivery_image()
		  return "col-md-6";
		else
		  return "col-md-8 col-md-offset-2"

	$scope.has_delivery_image = ->
		return true
