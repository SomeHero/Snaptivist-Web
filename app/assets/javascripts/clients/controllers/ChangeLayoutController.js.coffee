@ChangeLayoutController = ($scope, $rootScope,  $modalInstance, Util, layouts, settings) ->

  $scope.layouts = layouts
  $scope.selected = {
    layout: $scope.layouts[0]
  };

  $scope.ok = () ->
    $modalInstance.close($scope.selected.layout)

  $scope.cancel = () ->
    $modalInstance.close()

  $scope.set_layout = (layout) ->
    $scope.selected.layout = layout

ChangeLayoutController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util', 'layouts', 'settings']
