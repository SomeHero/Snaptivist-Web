@ClientsController = ($scope, $rootScope, ClientFactory, Util) ->
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
    ClientFactory.petition = {}

    Util.navigate_absolute('/clients/' + $scope.client.client_id + '/', 'petition_setup#1', false)

ClientsController.$inject = ['$scope', '$rootScope', 'ClientFactory', 'Util']
