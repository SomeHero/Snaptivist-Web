@TweetController = ($scope, TweetServices, $http, $q, Util, $rootScope) ->
	  
	$scope.display_location = (signature) ->
		if signature.city && signature.state
			return "in " + signature.city + ", " + signature.state
		else
			return ""

	$scope.show_tweets = ->
		if $scope.tweets.items.length > 0
			return true
		else
			return false

	$scope.show_more_tweets_click = ->
		console.log 'Show More Tweets Clicked'

		$scope.tweets.offset = $scope.tweets.offset + 10

		TweetServices.get_tweets($scope.petition.petition_id, $scope.comments.offset).then(save_tweets, error_tweets)

	$scope.show_more_tweet_button = ->
		return $scope.tweets.total < $scope.tweets.items.length + 1

	save_tweets = (response) ->
		console.log "Retrieved Tweets"

		i = 0

		while i < response.result.tweets.length
  			$scope.tweets.items.push response.result.tweets[i]
  			i++	

  		$scope.tweets.total = response.result.total
		
	error_tweets = (response) ->
		console.log "Failed GettingTweets"

	$scope.get_avatar_url = (tweet) ->

		if tweet.avatar_url 
			{
				'background-image': 'url(' + tweet.avatar_url + '?type=large)',
				'width': '128px',
				'height': '123px',
				'background-size': 'cover',
				'background-repeat': 'no-repeat',
				'background-position': '50% 50%'
			}
		else
			{
				'background-image': 'url(/assets/jcc_avatar_logo.png)',
				'width': '128px',
				'height': '123px',
				'background-size': 'cover',
				'background-repeat': 'no-repeat',
				'background-position': '50% 50%'
			}

	TweetServices.get_tweets($scope.petition.petition_id, $scope.tweets.offset).then(save_tweets, error_tweets)
