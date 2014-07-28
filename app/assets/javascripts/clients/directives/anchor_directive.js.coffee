@app.directive "a", ->
  restrict: "E"
  link: (scope, elem, attrs) ->
    if attrs.ngClick or attrs.href is "" or attrs.href is "#"
      elem.on "click", (e) ->
        e.preventDefault()
