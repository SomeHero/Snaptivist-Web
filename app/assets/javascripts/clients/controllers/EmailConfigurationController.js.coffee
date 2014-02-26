@EmailConfigurationController = ($scope, $rootScope,  $modalInstance, Util) ->

  $scope.ok = () ->
    $modalInstance.close()

  $scope.cancel = () ->
    $modalInstance.close()

EmailConfigurationController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util']
