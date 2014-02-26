@ActionTagsController = ($scope, $rootScope,  $modalInstance, Util, petition) ->

  $scope.petition = petition
  $scope.action_tags = {
    new_tag: ""
    list: []
  }
  if($scope.petition.action_tags)
    for action_tag in $scope.petition.action_tags.split(',')
      $scope.action_tags.list.push({
        name: action_tag
      })

  $scope.ok = () ->
    $modalInstance.close()

  $scope.cancel = () ->
    $modalInstance.close()

  $scope.add_action_tag = () ->
    new_tag = $scope.action_tags.new_tag
    $scope.action_tags.list.push({
      name: new_tag
    })
    if $scope.petition.action_tags
      $scope.petition.action_tags += "," + new_tag  
    else
      $scope.petition.action_tags = new_tag
    $scope.action_tags.new_tag = ""

ActionTagsController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util', 'petition']
