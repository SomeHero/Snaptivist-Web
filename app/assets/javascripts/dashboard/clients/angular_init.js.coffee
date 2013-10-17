@app = angular.module('clients', ['ui.bootstrap'])
	.value('$anchorScroll', angular.noop)

@app.config ['$locationProvider', ($locationProvider) ->
  $locationProvider.html5mode = true
]
@app.filter "fromNow", ->
  (dateString) ->
    moment(new Date(dateString)).fromNow()