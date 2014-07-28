@ActionTagsController = ($scope, $rootScope,  $modalInstance, Util, campaign) ->

  $scope.campaign = campaign
  $scope.action_tags = {
    new_tag: ""
    list: []
  }
  if($scope.campaign.action_tags)
    for action_tag in $scope.campaign.action_tags.split(',')
      $scope.action_tags.list.push({
        name: action_tag
      })

  $scope.ok = () ->
    $modalInstance.close()

  $scope.cancel = () ->
    $modalInstance.dismiss()

  $scope.add_action_tag = () ->
    new_tag = $scope.action_tags.new_tag
    $scope.action_tags.list.push({
      name: new_tag
    })
    if $scope.campaign.action_tags
      $scope.campaign.action_tags += "," + new_tag  
    else
      $scope.campaign.action_tags = new_tag
    $scope.action_tags.new_tag = ""

ActionTagsController.$inject = ['$scope', '$rootScope', '$modalInstance', 'Util', 'campaign']
