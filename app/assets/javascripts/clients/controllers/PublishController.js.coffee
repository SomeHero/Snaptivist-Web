@PublishController = ($scope, $rootScope,  $modalInstance, Util) ->

  $scope.ok = () ->
    $modalInstance.close()

  $scope.cancel = () ->
    $modalInstance.dismiss()

PublishController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util']
