@PublishingController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, CampaignServices, ClientFactory, Util) ->
	$scope.navigation.selected = 'publishing'

	$scope.client = ClientFactory.client
	$scope.campaign = campaign

	$scope.sign_with_facebook = (auth)->
        console.log "Facebook Login Success"

        #$scope.loading.show_spinner = true

        $scope.auth = auth


PublishingController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', 'CampaignServices', 'ClientFactory', 'Util']