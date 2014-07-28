@MainNavigationController = ($scope, $rootScope, ClientFactory, PetitionServices, Util, $modal) ->
  
  $scope.client = client
  ClientFactory.client = client

  $scope.navigation = {
    selected: 'pages'
  }
  
  $scope.new_petition_clicked = () ->
    console.log "new petition clicked"

    modalInstance = $modal.open(
        templateUrl: '/clients/campaigns/partials/new_petition',
        controller: NewPetitionController
      )
    modalInstance.result.then ((new_petition) ->
      if(!new_petition)
        return
        
      #$scope.loading.show_spinner = true

      PetitionServices.create($scope.client.client_id, new_petition.title, new_petition.subdomain).success (response) ->
        console.log "petition created"

        #$scope.loading.show_spinner = false

        Util.navigate_absolute('/clients/1/petitions/' + response.id)

      .error ->
        #$scope.loading.show_spinner = false

        console.log "create petition failed"
    ), ->
      #$scope.loading.show_spinner = false

      console.log "Modal dismissed at: " + new Date()

MainNavigationController.$inject = ['$scope', '$rootScope', 'ClientFactory', 'PetitionServices', 'Util', '$modal']
