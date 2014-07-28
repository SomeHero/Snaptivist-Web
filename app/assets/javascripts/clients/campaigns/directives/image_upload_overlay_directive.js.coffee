@app.directive "imageUploadOverlay", ['$http', '$templateCache', '$compile', '$timeout', '$window', '$upload', 'fileReader', ($http, $templateCache, $compile, $timeout, $window, $upload, fileReader)  ->
    
    restrict: "A"
    replace: false
    transclude: true
    scope: {
      imageName: '@'
      title: '@'
      notes: '@'
      segment: '='
      isAdmin: '='
      tempImage: '='
    }
    templateUrl: '/clients/campaigns/partials/image_upload_overlay'
    controller: ($scope, $attrs) ->
      $scope.onFileSelect = ($files) ->
  
        #$files: an array of files selected, each file has name, size, and type.
        i = 0

        while i < $files.length
          $file = $files[i]
          $scope.file = $file
          $scope.getFile()
          $scope.upload = $upload(
            url: '/api/images',
            file: $file
          ).success((data, status, headers, config) ->
            console.log(data)
            $scope.tempImage.data = data
          )
          #upload.php script, node.js route, or servlet upload url
          # method: POST or PUT,
          # headers: {'headerKey': 'headerValue'}, withCredential: true,
          i++

      $scope.getFile = ->
        $scope.progress = 0
        fileReader.readAsDataUrl($scope.file, $scope).then (result) ->
          $scope.tempImage.url = result
          $scope.tempImage.file_name = $scope.file
    
    link: (scope, element, attr) ->
      return unless scope.isAdmin
        
      # Set text of warning box
      element.bind 'mouseover', ->

        overlay = element.find(".image-upload-overlay")
        overlay.css('top', '-' + overlay.height() + 'px')
        
        element.find(".image-upload-overlay").show()

      element.bind 'mouseleave', ->
        element.find(".image-upload-overlay").hide()

]