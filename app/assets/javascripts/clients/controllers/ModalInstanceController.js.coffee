@ModalInstanceController = ($scope, $modalInstance, items) ->
  $scope.errors = items
  $scope.selected = item: $scope.errors[0]
  $scope.ok = ->
    $modalInstance.close $scope.selected.item

  $scope.cancel = ->
    $modalInstance.dismiss "cancel"