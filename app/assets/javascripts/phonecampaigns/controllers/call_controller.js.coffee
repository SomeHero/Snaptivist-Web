@CallController = ($scope, PhoneCampaignServices, $http, Util, $rootScope) ->

	$scope.log_call_with_facebook = ->
        Util.navigate "/deliver"

    $scope.log_call_with_email_address = ->
    	Util.navigate "/deliver"
