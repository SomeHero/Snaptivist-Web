@app.directive "clickToEdit", ->
    templateUrl: '/dashboard/client_views/text_edit.html'
    restrict: "A"
    replace: false
    scope:
      value: "=clickToEdit"

    link: (scope, elem, attr) ->
      elem.bind 'click', ->
        $(this).find(input).focus()
        scope.$apply ->
          scope.view.editorEnabled = true
      elem.bind 'dblclick', ->
        scope.$apply ->
          scope.value = scope.view.editableValue
          scope.view.editorEnabled = false
      elem.bind 'focusout', ->
        scope.$apply ->
          scope.value = scope.view.editableValue
          scope.view.editorEnabled = false

    controller: ($scope) ->
      $scope.view =
        editableValue: $scope.value
        editorEnabled: false

      $scope.enableEditor = ->
        $scope.view.editorEnabled = true
        $scope.view.editableValue = $scope.value

      $scope.disableEditor = ->
        $scope.view.editorEnabled = false

      $scope.save = ->
        $scope.value = $scope.view.editableValue
        $scope.disableEditor()