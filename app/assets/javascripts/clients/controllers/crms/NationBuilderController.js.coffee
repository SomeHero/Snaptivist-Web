@NationBuilderController = ($scope, $rootScope, $window, CrmServices) ->
	
	$scope.nation_builder = $scope.client.nation_builder

	$scope.authenicate_clicked= () ->
		console.log "authenticate clicked"

		CrmServices.save_nation_builder_oauth_credentials($scope.client.client_id, {
			'nation_name': $scope.nation_builder.nation_name
			'client_uid': $scope.nation_builder.client_app_id
			'client_secret': $scope.nation_builder.client_secret
			'redirect_uri': $scope.nation_builder.redirect_uri
		}).success (response) ->
			$window.open "https://" + $scope.nation_builder.nation_name + ".nationbuilder.com/oauth/authorize?response_type=code&client_id=" + $scope.nation_builder.client_app_id + "&redirect_uri=" + $scope.nation_builder.redirect_uri

		.error (response) ->
			console.log "error trying to save nation builder oauth credentials"