@app.directive "imageUploadOverlay", ->
    
    restrict: "A"
    replace: false
    transclude: true
    scope: {
      imageName: '@'
      title: '@'
      notes: '@'
    }
    templateUrl: 'clients/partials/image_upload_overlay'
    
    link: (scope, element, attr) ->
      # Set text of warning box
      element.bind 'mouseover', ->
        overlay = element.find(".image-upload-overlay")
        overlay.css('top', '-' + overlay.height() + 'px')
        
        element.find(".image-upload-overlay").show()

      element.bind 'mouseleave', ->
        element.find(".image-upload-overlay").hide()