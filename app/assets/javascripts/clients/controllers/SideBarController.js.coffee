@SidebarController = ($scope, $rootScope, Util) ->
  window.scope = $scope

  $scope.client = {}

  $scope.new_campaign = () ->
  	Util.navigate('/setup')

SidebarController.$inject = ['$scope', '$rootScope', 'Util']
