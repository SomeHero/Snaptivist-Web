@ClientsController = ($scope, $rootScope, ClientFactory, Util, $modal) ->
  
  $scope.client = client
  $scope.styles = {
    stylesheet_list: []
  }
  $scope.loading = {
    show_spinner: false
  }

  $scope.stylesheets = () ->
    return $scope.styles.stylesheet_list


ClientsController.$inject = ['$scope', '$rootScope', 'ClientFactory', 'Util', '$modal']
