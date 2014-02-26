@PublishController = ($scope, $rootScope,  $modalInstance, Util) ->

  $scope.ok = () ->
    $modalInstance.close()

  $scope.cancel = () ->
    $modalInstance.close()

PublishController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util']
