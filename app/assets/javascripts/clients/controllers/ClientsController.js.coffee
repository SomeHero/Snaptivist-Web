@ClientsController = ($scope, $rootScope) ->
  window.scope = $scope
  $scope.client = client

  $scope.layout = 'layout2'
  $scope.theme = 'standard'

  $scope.stylesheet_list = 
  	[{
  		href: '/assets/layouts/' + $scope.layout + '.css'
  	},
  	{
  		href: '/assets/layouts/' + $scope.layout + '-responsive.css'
  	},
  	{
  		href: '/assets/themes/' + $scope.layout + '_' + $scope.theme + '.css'
  	}]

  $scope.stylesheets = () ->
  	return $scope.stylesheet_list

  $scope.page_list =  
  	[{
  		title: 'Signature Page',
  		url: '/client_views/' + $scope.layout + '/signature_template'
  	}, {
  		title: 'Delivery Page',
  		url: '/client_views/' + $scope.layout + '/delivery_template'
  	}, {
  		title: 'Premium Page',
  		url: '/client_views/' + $scope.layout + '/premium_template'
  	}]

  $scope.pages = () ->
  	return $scope.page_list

ClientsController.$inject = ['$scope', '$rootScope']
