@MoreActionController = ($scope, PetitionServices, $http, Util, $rootScope, more_actions) ->
  
  $scope.more_actions = more_actions
  $scope.petition = petition
  $scope.isCollapsed = true
  $scope.summary_more_text = "More"
  $scope.loading = {
    show_spinner: false
  }

  window.scope = $scope

MoreActionController.resolve =
  more_actions: ['PetitionServices', '$q', '$rootScope', (PetitionServices, $q, $rootScope) ->
    deferred = $q.defer()
    PetitionServices.get_more_petitions().then (petitions) ->
      console.log "got some other actions"

      deferred.resolve petitions
    
    deferred.promise
  ]

