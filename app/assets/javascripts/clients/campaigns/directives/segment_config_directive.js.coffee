@app.directive "segmentConfig", ['$http', '$templateCache', '$compile', '$timeout', '$window', '$modal', 'CampaignServices', ($http, $templateCache, $compile, $timeout, $window, $modal, CampaignServices)  ->
    
  getTemplate = (templateUrl) ->
  
    $http.get(templateUrl,
      cache: $templateCache
    )
  
  loadTemplate = (scope, element, attrs) ->
    templateUrl = '/clients/campaigns/partials/segment_config'

    getTemplate(templateUrl).then((response) ->
      configEl = angular.element($compile(response.data)(scope))

      element.css 'position', 'relative'
      element.append configEl
    )

  return (
    restrict: "A"
    replace: false
    scope: false
    controller: ($scope, $attrs) ->
      $scope.config_clicked = () ->
        console.log 'config clicked'

        modalInstance = $modal.open(
          templateUrl: '/clients/campaigns/partials/segment_overlay',
          controller: SegmentController
          resolve: 
            segment_type: ->
              $scope.segment.type
        )
        modalInstance.result.then ((segment_type) ->
        
          #$scope.loading.show_spinner = true

          $scope.segment.type = segment_type

          if segment_type == 'signature_action'
            $scope.action.type = 'Petition'
          else if segment_type == 'poll_action'
            $scope.action.type = 'Poll'

        ), ->
          #$scope.loading.show_spinner = false

          console.log "Modal dismissed at: " + new Date()

      $scope.edit_clicked = () ->

        if $scope.segment.type == 'photo'
          open_photo_edit_model()
        else if $scope.segment.type == 'video'
          open_video_edit_model($scope.segment)
        else if $scope.segment.type == 'poll_results'
          open_poll_results_edit_model()
        else if $scope.segment.type == 'signature_action'
          open_signature_action_edit_modal()
        else if $scope.segment.type == 'action_comments_list'
          open_action_comment_list_edit_model()
        else
          return


      open_photo_edit_model = () ->
        templateUrl = '/clients/campaigns/partials/image_upload_overlay'

        modalInstance = $modal.open(
          templateUrl: templateUrl
          controller: ImageSegmentController
        )
        modalInstance.result.then ((image) ->
        
          #$scope.loading.show_spinner = true

          $scope.temp_image = image.tempImage
          $scope.segment.image = image.data

        ), ->
          #$scope.loading.show_spinner = false

          console.log "Modal dismissed at: " + new Date()

      open_video_edit_model = (segment) ->
        templateUrl = '/clients/campaigns/partials/video_upload_overlay'

        modalInstance = $modal.open(
          templateUrl: templateUrl
          controller: VideoSegmentController
          resolve:
            segment: ->
              segment
        )
        modalInstance.result.then ((video) ->
        
          #$scope.loading.show_spinner = true

          $scope.segment.embed_code = video.embed_code
          $scope.segment.height = video.height
          $scope.segment.width = video.width
        ), ->
          #$scope.loading.show_spinner = false

          console.log "Modal dismissed at: " + new Date()

      open_poll_results_edit_model = () ->
        templateUrl = '/clients/campaigns/partials/poll_results_overlay'

        modalInstance = $modal.open(
          templateUrl: templateUrl
          controller: PollResultsController
          resolve: 
            polls: ->
              CampaignServices.get_polls(1)
        )
        modalInstance.result.then ((selected_poll) ->
        
          #$scope.loading.show_spinner = true

          $scope.segment.poll_id = selected_poll.poll.id
        ), ->
          #$scope.loading.show_spinner = false

          console.log "Modal dismissed at: " + new Date()

      open_action_comment_list_edit_model = () ->
        templateUrl = '/clients/campaigns/partials/action_comment_list_overlay'

        modalInstance = $modal.open(
          templateUrl: templateUrl
          controller: ActionCommentListController
        )
        modalInstance.result.then ((image) ->
        
          #$scope.loading.show_spinner = true

          $scope.temp_image = image.tempImage
          $scope.segment.background_image = image.data
        ), ->
          #$scope.loading.show_spinner = false

          console.log "Modal dismissed at: " + new Date()

      open_signature_action_edit_modal = () ->

        templateUrl = '/clients/campaigns/partials/signature_action_overlay'

        modalInstance = $modal.open(
          templateUrl: templateUrl
          controller: SignatureActionConfigController
        )
        modalInstance.result.then ((selected_poll) ->
        
          #$scope.loading.show_spinner = true

          #$scope.segment.poll_id = selected_poll.poll.id
        ), ->
          #$scope.loading.show_spinner = false

          console.log "Modal dismissed at: " + new Date()

    link: (scope, element, attr) ->
      return unless scope.isAdmin
          
      loadTemplate(scope, element, attr)

  )

]