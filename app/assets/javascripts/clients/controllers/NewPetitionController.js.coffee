@NewPetitionController = ($scope, $rootScope,  $modalInstance, Util) ->

  $scope.new_petition = {
  	title: '',
  	subdomain: ''
  }
  $scope.ok = () ->
    $modalInstance.close($scope.new_petition)

  $scope.cancel = () ->
    $modalInstance.close()

NewPetitionController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util']
