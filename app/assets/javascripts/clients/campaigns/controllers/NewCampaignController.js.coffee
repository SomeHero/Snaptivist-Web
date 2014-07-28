@NewCampaignController = ($scope, $rootScope,  $modalInstance, ClientFactory, CampaignServices, Util) ->

  $scope.new_petition = {
  	title: '',
  	subdomain: ''
  }
  $scope.ok = () ->

  	CampaignServices.create(ClientFactory.client.client_id, $scope.new_petition.title, $scope.new_petition.subdomain).success (response) ->

  		$scope.new_petition = response

  		$modalInstance.close($scope.new_petition)

  	.error ->
  		console.log "unable to create campaign"


  $scope.cancel = () ->
    $modalInstance.dismiss()

NewCampaignController.$inject = ['$scope', '$rootScope', '$modalInstance', 'ClientFactory', 'CampaignServices', 'Util']
