@ClientsController = ($scope, $rootScope) ->
  window.scope = $scope
  $scope.client = {
  	name: "Test Client"
  }

ClientsController.$inject = ['$scope', '$rootScope']
