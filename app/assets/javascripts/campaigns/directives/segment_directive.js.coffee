@app.directive 'ngSegment', ['$http', '$templateCache', '$compile', '$timeout', '$window', '$sce', ($http, $templateCache, $compile, $timeout, $window, $sce) ->
  getTemplate = (layout, contentType) ->
    baseUrl = "/client_views/" + layout.url_fragment + "/segments/"

    templateMap = {
      text: 'text.html',
      photo: 'photo.html',
      video: 'video.html',
      disclaimer: 'disclaimer.html',
      signature_action: 'signature-action.html',
      poll_action: 'poll-action.html',
      poll_results: 'poll-results.html',
      premium_action: 'premium-action.html',
      tweet_action: 'tweet-action.html',
      action_guage: 'action-guage.html',
      action_comments_list: 'action-comments-list.html'
    }
    templateUrl = baseUrl + templateMap[contentType]
    $http.get(templateUrl,
      cache: $templateCache
    )
  
  loadTemplate = (scope, element, attrs) ->
    if(!scope.segment || !scope.segment.type)
      scope.segment.type = scope.segment_type || 'text'

    getTemplate(scope.layout, scope.segment.type).success((html) ->
        element.html ""
      ).then((response) ->
        element.append $compile(response.data)(scope)
      )

  linker = (scope, element, attrs) ->
    scope.temp_image = {}
    scope.segment_type = attrs.segmentType
    scope.segment_width = attrs.segmentWidth
    scope.segment_height = attrs.segmentHeight
    scope.segment_position = attrs.segmentPosition
    scope.placeholder = attrs.placeholder
    scope.image_overlay_title = attrs.imageOverlayTitle
    scope.image_overlay_notes = attrs.imageOverlayNotes

    if(!scope.segment)
      scope.segment = {
        type: scope.segmentType
      }
    if(!scope.action)
      scope.action = {
        count: 0
      }

    if(scope.segment && scope.segment.url)
      scope.segment.url = $sce.trustAsResourceUrl(scope.segment.url)
    
    scope.$watch 'segment.type', ((newValue, oldValue) ->
      if(newValue == oldValue) 
        return;
        
      console.log "segment changed"
      loadTemplate(scope, element, attrs)
    ), true

    loadTemplate(scope, element, attrs)

  return (
    restrict: 'EA'
    replace: true
    transclude: false
    scope: {
      segment: '='
      action: '='
      isAdmin: '='
      layout: '='
    }
    controller: ($scope, $attrs) ->
      $scope.get_placeholder_text = () ->
        console.log "getting placeholder text"

        return $scope.placeholder

      $scope.format_video_embed_url = () ->
        return $sce.trustAsResourceUrl("http://www.youtube.com/embed/" + $scope.segment.embed_code)

      $scope.image_styling = (segment) ->
        if($scope.temp_image && $scope.temp_image.url) 
          return {
            'height': $scope.segment_height
            'background-image': 'url(' + $scope.temp_image.url + ')'
            'background-repeat': 'no-repeat'
            'background-position': '50% 50%'
          } 
        else if(segment.image && segment.image.sizes && segment.image.sizes.full)
          return {
              'height': $scope.segment_height
              'background-image': 'url(' + segment.image.sizes.full + ')'
              'background-repeat': 'no-repeat'
              'background-position': '50% 50%'
            }
        else
          return {
            'height': $scope.segment_height
          }

    link: linker
  )
]