@NationBuilderController = ($scope, $rootScope, $window) ->
	
	$scope.nation_builder = $scope.client.nation_builder

	$scope.authenicate_clicked= () ->
		console.log "authenticate clicked"

		$window.open "https://" + $scope.nation_builder.nation_name + ".nationbuilder.com/oauth/authorize?response_type=code&client_id=" + $scope.nation_builder.client_app_id + "&redirect_uri=http://localhost:3000/oauth/nb"