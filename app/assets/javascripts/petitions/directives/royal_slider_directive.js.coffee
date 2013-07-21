
@app.directive "royalSlider", ['$window', '$timeout', ($window, $timeout) ->
  (scope, element, attrs) ->
    element.addClass('royalSlider').addClass(attrs.royalSlider)
    loop_toggle = (if $window.screen.width <= 959 then false else true)
    thumbnail_toggle = 'none'

    scope.rs_display = true

    init_royal_slider = ->
      element.royalSlider
        controlNavigation: thumbnail_toggle
        imgWidth: 350
        imgHeight: 350
        addActiveClass: true
        arrowsNav: true
        keyboardNavEnabled: true
        slidesSpacing: 10
        loop: loop_toggle
        allowCSS3: true
        randomizeSlides: false
        usePreloader: true
        arrowsNavHideOnTouch: true
        globalCaption: false
        imageScaleMode: 'fit'
        numImagesToPreload: 2
        fadeInLoadedSlide: false
        transitionType: 'move'
        transitionSpeed: 600
        visibleNearby:
          enabled: true
          centerArea: 0.3
          center: true
          navigateByCenterClick: false
          breakpoint: 959
          breakpointCenterArea: 0.75
        thumbs:
          spacing: 0
          arrows: true
          touch: true
          autoCenter: true
          fitInViewport: true

      scope.rs_display = true

      element.data('royalSlider').ev.on 'rsBeforeAnimStart', (event, type) ->
        scope.action = { title: "New Petition"}
        console.log "Action changed to id: ", scope.action.title
        scope.$apply() unless scope.$$phase

    $timeout(init_royal_slider, 0)

]
