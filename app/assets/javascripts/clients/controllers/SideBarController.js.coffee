@SidebarController = ($scope, $rootScope, Util) ->
  window.scope = $scope

  $scope.client = {}

  $scope.view_campaign = (give_flow) ->
    $rootScope.give_flow = give_flow
    Util.navigate('/dashboard')

  $scope.new_campaign = () ->
  	Util.navigate('/setup')

SidebarController.$inject = ['$scope', '$rootScope', 'Util']
