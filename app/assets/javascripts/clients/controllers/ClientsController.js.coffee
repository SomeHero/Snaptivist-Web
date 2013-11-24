@ClientsController = ($scope, $rootScope, ClientFactory) ->
  window.scope = $scope
  $scope.client = client

  $scope.settings = {
    layout: 'layout2',
    theme: 'standard'
  }
  $scope.theme = 'standard'

  $scope.stylesheet_list = []

  $scope.stylesheets = () ->
  	return $scope.stylesheet_list

  $scope.page_list = []

  $scope.pages = [{
      name: 'Signature Page'
      page_url: 'signature_template'
    }, {
      name: 'Delivery Page'
      page_url: 'delivery_template'
    }, {
      name: 'Premium Page'
      page_url: 'premium_template'
    }]

  $scope.update_page_list = () ->
    $scope.page_list = []
    for page in $scope.pages
      $scope.page_list.push({
        title: page.name,
        url: '/client_views/' + $scope.settings.layout + '/' + page.page_url
      })

  $scope.update_stylesheet_list = () ->
    $scope.stylesheet_list.push({
      href: '/assets/layouts/' + $scope.settings.layout + '.css'
    })
    $scope.stylesheet_list.push({
      href: '/assets/layouts/' + $scope.settings.layout + '-responsive.css'
    })
    $scope.stylesheet_list.push({
      href: '/assets/themes/' + $scope.settings.layout + '_' + $scope.settings.theme + '.css'
    })


  $scope.update_page_list()
  $scope.update_stylesheet_list()

ClientsController.$inject = ['$scope', '$rootScope', 'ClientFactory']
