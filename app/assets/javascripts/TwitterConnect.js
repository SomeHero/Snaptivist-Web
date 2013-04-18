var TwitterConnect = (function() {

  // constructor accepts a url which should be your Twitter OAuth url
  function TwitterConnect(url, success, failure) {
    this.url = url;
    this.success = success;
    this.failure = failure;
  }

  TwitterConnect.prototype.exec = function() {
    var self = this,
      params = 'location=0,status=0,width=800,height=600';

    this.twitter_window = window.open(this.url, 'twitterWindow', params);

    this.interval = window.setInterval((function() {
      if (self.twitter_window.closed) {
        window.clearInterval(self.interval);
        self.finish();
      }
    }), 1000);

    // the server will use this cookie to determine if the Twitter redirection
    // url should window.close() or not
    document.cookie = 'twitter_oauth_popup=1; path=/';
  }

  TwitterConnect.prototype.finish = function() {

    $.ajax({
      type: 'get',
      url: '/auth/check/twitter',
      dataType: 'json',
      success: function(response) {
        if (response.authed) {
          this.success();
        } else {
          this.failure();
        }
      }
    });
   };

  return TwitterConnect;
})();''