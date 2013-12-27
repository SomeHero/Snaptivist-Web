###
@see http://docs.angularjs.org/guide/concepts
@see http://docs.angularjs.org/api/ng.directive:ngModel.NgModelController
@see https://github.com/angular/angular.js/issues/528#issuecomment-7573166
###
angular.module("contenteditable", []).directive "contenteditable", ["$timeout", ($timeout) ->
  restrict: "A"
  require: "?ngModel"

  link: ($scope, $element, attrs, ngModel) ->
    
    # dont do anything unless this is actually bound to a model
    return  unless ngModel
    
    if !$scope.is_admin
      $element.removeAttr('contenteditable')

    # view -> model
    $element.bind "input", (e) ->
      $scope.$apply ->
        html = undefined
        html2 = undefined
        rerender = undefined
        html = $element.html()
        rerender = false
        html = html.replace(/<br>$/, "")  if attrs.stripBr and attrs.stripBr isnt "false"
        html = html.replace(/<br>/g, "<br><br>")
        html = html.replace(/<div>/g, "").replace(/<\/div>/g, "")
        if attrs.noLineBreaks and attrs.noLineBreaks isnt "false"
          html2 = html.replace(/<div>/g, "").replace(/<br>/g, "").replace(/<\/div>/g, "")
          if html2 isnt html
            rerender = true
            html = html2
        ngModel.$setViewValue html
        ngModel.$render()  if rerender
        if html is ""
          #add back in data-placeholder
          $element.addClass("placeholder-showing")

          # the cursor disappears if the contents is empty
          # so we need to refocus
          $timeout ->
            $element[0].blur()
            $element[0].focus()
        else
          #remove data-placeholder
          $element.removeClass("placeholder-showing")



    
    # model -> view
    oldRender = ngModel.$render
    ngModel.$render = ->
      el = undefined
      el2 = undefined
      range = undefined
      sel = undefined
      oldRender()  unless not oldRender
      $element.html ngModel.$viewValue or ""
      el = $element[0]

      if $element.html() is ""
        #add back in data-placeholder
        $element.addClass("placeholder-showing")

        # the cursor disappears if the contents is empty
        # so we need to refocus
        $timeout ->
          $element[0].blur()
          $element[0].focus()
      else
        #remove data-placeholder
        $element.removeClass("placeholder-showing")

    if attrs.selectNonEditable and attrs.selectNonEditable isnt "false"
      $element.bind "click", (e) ->
        range = undefined
        sel = undefined
        target = undefined
        target = e.toElement
        if target isnt this and angular.element(target).attr("contenteditable") is "false"
          range = document.createRange()
          sel = window.getSelection()
          range.setStartBefore target
          range.setEndAfter target
          sel.removeAllRanges()
          sel.addRange range

]