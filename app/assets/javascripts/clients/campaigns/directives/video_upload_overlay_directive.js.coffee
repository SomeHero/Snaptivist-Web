@app.directive "videoUploadOverlay", ->
    
    restrict: "A"
    replace: false
    transclude: true
    scope: {
      segment: '='
      isAdmin: '='
    }
    templateUrl: '/clients/campaigns/partials/video_upload_overlay'
    
    controller: ($scope, $attrs) ->
      $scope.submit_clicked = () ->
        console.log 'video submit'

        $scope.segment.embed_code = embedCode

    link: (scope, element, attr) ->
      return unless scope.isAdmin
        
      # Set text of warning box
      element.bind 'mouseover', ->

        overlay = element.find(".upload-overlay")
        overlay.css('top', '-' + overlay.height() + 'px')
        
        element.find(".upload-overlay").show()

      element.bind 'mouseleave', ->
        element.find(".upload-overlay").hide()