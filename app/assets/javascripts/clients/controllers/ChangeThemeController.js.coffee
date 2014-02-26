@ChangeThemeController = ($scope, $rootScope,  $modalInstance, Util, themes) ->

  $scope.themes = themes
  $scope.selected = {
    theme: $scope.themes[0]
  };
  $scope.ok = () ->
    $modalInstance.close($scope.selected.theme)

  $scope.cancel = () ->
    $modalInstance.close()

  $scope.set_theme = (theme) ->
    $scope.selected.theme = theme

ChangeThemeController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util', 'themes']
