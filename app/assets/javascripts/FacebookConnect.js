var FacebookConnect = (function() {
  var successCallback, failureCallback;
  
  // constructor accepts a url which should be your Twitter OAuth url
  function FacebookConnect(url, success, failure) {
    this.url = url;
    successCallback = success;
    failureCallback = failure;
  }

  FacebookConnect.prototype.exec = function() {
    var self = this,
      params = 'location=0,status=0,width=800,height=600';

    this.facebook_window = window.open(this.url, 'facebookWindow', params);

    this.interval = window.setInterval((function() {
      if (self.facebook_window.closed) {
        window.clearInterval(self.interval);
        self.finish();
      }
    }), 1000);

    // the server will use this cookie to determine if the Twitter redirection
    // url should window.close() or not
    document.cookie = 'twitter_oauth_popup=1; path=/';
  }

  FacebookConnect.prototype.finish = function(success, failure) {

    $.ajax({
      type: 'get',
      url: '/auth/check/facebook',
      dataType: 'json',
      success: function(response) {
        if (response.authed) {
          successCallback();
        } else {
          failureCallback();
        }
      }
    });
  };

  return FacebookConnect;
})();''