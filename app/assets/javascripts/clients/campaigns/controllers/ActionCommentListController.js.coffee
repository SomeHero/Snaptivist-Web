@ActionCommentListController = ($scope, $route, $routeParams, $modal, $log, $rootScope, $location, $q, $modalInstance, CampaignServices, ClientFactory, Util, $upload, fileReader) ->
	
	$scope.image = {
		tempImage: {}
	}
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
				$scope.image.data = data
			)
			#upload.php script, node.js route, or servlet upload url
			# method: POST or PUT,
			# headers: {'headerKey': 'headerValue'}, withCredential: true,
			i++

	$scope.getFile = ->
		$scope.progress = 0
		fileReader.readAsDataUrl($scope.file, $scope).then (result) ->
			$scope.image.tempImage.url = result
			$scope.image.tempImage.file_name = $scope.file
	
	$scope.ok = () ->
		$modalInstance.close($scope.image)

	$scope.cancel = () ->
		$modalInstance.dismiss()

ActionCommentListController.$inject = ['$scope', '$route', '$routeParams', '$modal', '$log', '$rootScope', '$location', '$q', '$modalInstance', 'CampaignServices', 'ClientFactory', 'Util', '$upload', 'fileReader']