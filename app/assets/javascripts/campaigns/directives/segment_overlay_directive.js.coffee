@app.directive "segmentOverlay", ->
    
    restrict: "A"
    replace: false
    transclude: true
    scope: {
      segment: '='
      isAdmin: '='
    }
    templateUrl: '/clients/campaigns/partials/segment_overlay'
    controller: (scope, attrs) ->
      scope.set_segment_type = (type_name) ->
        console.log 'setting segment type'

        scope.segment.type = type_name
        
    link: (scope, element, attr) ->
      #return unless scope.isAdmin
        
      # Set text of warning box
      element.bind 'mouseover', ->

        overlay = element.find(".segment-overlay")
        overlay.css('top', '-' + overlay.height() + 'px')
        
        element.find(".segment-overlay").show()

      element.bind 'mouseleave', ->
        element.find(".segment-overlay").hide()