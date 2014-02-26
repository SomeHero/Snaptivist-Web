@ClientsController = ($scope, $rootScope, ClientFactory, PetitionServices, Util, $modal) ->
  window.scope = $scope
  $scope.client = client
  $scope.styles = {
    stylesheet_list: []
  }
  $scope.loading = {
    show_spinner: false
  }

  $scope.stylesheets = () ->
    return $scope.styles.stylesheet_list

  $scope.new_petition_clicked = () ->
    console.log "new petition clicked"

    modalInstance = $modal.open(
        templateUrl: '/clients/partials/new_petition',
        controller: NewPetitionController
      )
    modalInstance.result.then ((new_petition) ->
      if(!new_petition)
        return
        
      $scope.loading.show_spinner = true

      PetitionServices.create($scope.client.client_id, new_petition.title, new_petition.subdomain).success (response) ->
        console.log "petition created"

        $scope.loading.show_spinner = false

        Util.navigate_absolute('/clients/1/petitions/' + response.id)

      .error ->
        $scope.loading.show_spinner = false

        console.log "create petition failed"
    ), ->
      $scope.loading.show_spinner = false

      console.log "Modal dismissed at: " + new Date()

ClientsController.$inject = ['$scope', '$rootScope', 'ClientFactory', 'PetitionServices', 'Util', '$modal']
