@ClientsController = ($scope, $http, $rootScope) ->

  window.scope = $scope

  $scope.petitions = petitions
  $scope.stats = stats