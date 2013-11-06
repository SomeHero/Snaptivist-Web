(function() {

  this.app = angular.module('poll', ['ui.bootstrap']).value('$anchorScroll', angular.noop);

  this.app.config([
    '$routeProvider', function($routeProvider) {
      var base_page_url;
      base_page_url = '/sign';
      return $routeProvider.when('/sign', {
        templateUrl: '/client_views/vote',
        controller: SignatureController
      }).when('/deliver', {
        templateUrl: '/client_views/deliver',
        controller: DeliveryController
      }).when('/complete', {
        templateUrl: '/client_views/more',
        controller: MoreActionController,
        resolve: MoreActionController.resolve
      }).otherwise({
        redirectTo: base_page_url
      });
    }
  ]);

  this.app.config([
    '$locationProvider', function($locationProvider) {
      return $locationProvider.html5mode = true;
    }
  ]);

  this.app.filter("fromNow", function() {
    return function(dateString) {
      return moment(new Date(dateString)).fromNow();
    };
  });

  this.app.directive("facebook", function($http, Util, $q, $location, PetitionServices) {
    return {
      restrict: "A",
      scope: true,
      controller: function($scope, $attrs) {
        var fetch, login;
        login = function() {
          return FB.login((function(response) {
            if (response.authResponse) {
              console.log("FB.login connected");
              scope.auth = response.authResponse;
              return scope.$apply(function() {
                return scope.$broadcast('handleFacebookAuth');
              });
            } else {
              return console.log("FB.login cancelled");
            }
          }), {
            scope: "email,publish_stream"
          });
        };
        fetch = function() {
          console.log("Signing with Facebook");
          return scope.$broadcast('handleFacebookAuth');
        };
        (function(d) {
          var id, js, ref;
          js = void 0;
          id = "facebook-jssdk";
          ref = d.getElementsByTagName("script")[0];
          if (d.getElementById(id)) {
            return;
          }
          js = d.createElement("script");
          js.id = id;
          js.async = true;
          js.src = "//connect.facebook.net/en_US/all.js";
          return ref.parentNode.insertBefore(js, ref);
        })(document);
        return $scope.fetch = function() {
          $scope.loading.show_spinner = true;
          if ($scope.login_status === "connected") {
            console.log("fetch");
            return fetch();
          } else {
            return login();
          }
        };
      },
      link: function(scope, element, attrs, controller) {
        return window.fbAsyncInit = function() {
          FB.init({
            appId: attrs.facebook,
            channelUrl: "//localhost:3000/channel.html",
            status: true,
            cookie: true,
            xfbml: true
          });
          return FB.getLoginStatus(function(response) {
            if (response.status === "connected") {
              scope.auth = response.authResponse;
            } else if (response.status === "not_authorized") {

            } else {

            }
            scope.login_status = response.status;
            return scope.$apply();
          });
        };
      }
    };
  });

}).call(this);
 // FACEBOOK

      (function(d){
         var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
         if (d.getElementById(id)) {return;}
         js = d.createElement('script'); js.id = id; js.async = true;
         js.src = "//connect.facebook.net/en_US/all.js";
         ref.parentNode.insertBefore(js, ref);
       }(document));

      window.fbAsyncInit = function() {
        FB.init({
          appId: '478676018853709',
          status     : true, // check login status
          cookie     : true, // enable cookies to allow the server to access the session
          xfbml      : true  // parse XFBML
        });

        FB.getLoginStatus(function(response) {
        });

        FB.Event.subscribe('auth.login', function(response) {
        });

        FB.Event.subscribe('auth.logout', function(response) {
        });
      }
;
(function() {

  this.CommentController = function($scope, CommentServices, $http, $q, Util, $rootScope) {
    var error_comments, save_comments;
    $scope.comments = {
      offset: 0,
      total: 0,
      items: []
    };
    window.scope.comments = $scope;
    $rootScope.$on('signedPetition', function(event, comment) {
      return $scope.comments.items.push(comment);
    });
    $scope.get_avatar_url = function(user) {
      if (user.avatar_url) {
        return user.avatar_url + "?type=large";
      } else {
        return '/assets/avatar.png';
      }
    };
    $scope.show_more_signatures_click = function() {
      console.log('Show More Signatures Clicked');
      $scope.comments.offset = $scope.comments.offset + 10;
      return CommentServices.get_comments($scope.petition.petition_id, $scope.comments.offset).then(save_comments, error_comments);
    };
    $scope.show_more_signatures_button = function() {
      return $scope.comments.total < $scope.comments.items.length + 1;
    };
    save_comments = function(response) {
      var i;
      console.log("Retrieved Comments");
      i = 0;
      while (i < response.result.signatures.length) {
        $scope.comments.items.push(response.result.signatures[i]);
        i++;
      }
      return $scope.comments.total = response.result.total;
    };
    error_comments = function(response) {
      return console.log("Failed Getting Comments");
    };
    return CommentServices.get_comments(1, $scope.comments.offset).then(save_comments, error_comments);
  };

}).call(this);
(function() {

  this.DeliveryController = function($scope, PetitionServices, $http, $q, Util, $rootScope) {
    Util.push_ga_event("Petition", "Load", "Delivery");
    window.scope = $scope;
    $scope.deliver_action = function() {
      var interval, params, twitter_window;
      console.log("delivering signature");
      $scope.loading.show_spinner = true;
      params = 'location=0,status=0,width=800,height=600';
      twitter_window = window.open('/users/auth/twitter', 'twitterWindow', params);
      return interval = window.setInterval((function() {
        if (twitter_window.closed) {
          window.clearInterval(interval);
          return $scope.$apply(function() {
            return PetitionServices.deliver_signature($scope.petition.petition_id, $scope.signature.signature_id, $scope.tweet).success(function(response) {
              console.log("signature delivered");
              Util.push_ga_event("Petition", "Deliver Signature", "Success");
              $scope.loading.show_spinner = false;
              return Util.navigate("/complete");
            }).error(function(response) {
              console.log("delivery failed");
              Util.push_ga_event("Petition", "Deliver Signature", "Failed");
              return Util.navigate("/complete");
            });
          });
        }
      }), 1000);
    };
    return $scope.skip_delivery = function() {
      console.log("skipping delivery");
      Util.push_ga_event("Petition", "Deliver Signature", "Skipped");
      $scope.loading.show_spinner = true;
      return Util.navigate("/complete");
    };
  };

}).call(this);
(function() {

  this.MoreActionController = function($scope, PetitionServices, $http, Util, $rootScope, more_actions) {
    $scope.more_actions = more_actions;
    Util.push_ga_event("Petition", "Load", "More Actions");
    $scope.sign_another = function(petition) {
      $scope.loading.show_spinner = true;
      return PetitionServices.sign_another(petition.petition_id).success(function(response) {
        var fb_message_obj, result, scroll;
        if (response.statusCode === 200) {
          console.log("signature complete; trying to Share via FB");
          Util.push_ga_event("Petition", "Sign Another Petition", "Success");
          $scope.loading.show_spinner = false;
          result = response.result;
          $rootScope.signature = result.signature;
          if ($scope.auth) {
            fb_message_obj = {
              method: 'feed',
              redirect_uri: 'YOUR URL HERE',
              link: petition.short_url,
              name: 'Vote',
              caption: petition.title,
              description: petition.summary
            };
            if (scope.petition.image_square) {
              $.extend(true, fb_message_obj, {
                picture: $scope.petition.image_square
              });
            } else {
              $.extend(true, fb_message_obj, {
                picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png'
              });
            }
            scroll = $(window).scrollTop();
            return FB.ui(fb_message_obj, function(response) {
              $(window).scrollTop(scroll);
              if (response) {
                console.log("share complete");
                return Util.push_ga_event("Petition", "Facebook Share", "Success");
              } else {
                console.log("error sharing");
                return Util.push_ga_event("Petition", "Facebook Share", "Failed");
              }
            });
          }
        } else {
          console.log("error: " + response);
          $scope.loading.show_spinner = false;
          return Util.push_ga_event("Petition", "Sign Another Petition", "Failed");
        }
      });
    };
    $scope.read_more = function(petition) {
      Util.push_ga_event("Petition", "Read More", "Success");
      return Util.navigate_absolute(("http://" + petition.subdomain + ".") + window.location.hostname.split('.').slice(2 - window.location.hostname.split('.').length - 1).join('.') + ":" + (window.location.port ? window.location.port : ""), null, false);
    };
    return window.scope = $scope;
  };

  MoreActionController.resolve = {
    more_actions: [
      'PetitionServices', '$q', '$rootScope', function(PetitionServices, $q, $rootScope) {
        var deferred;
        deferred = $q.defer();
        PetitionServices.get_more_petitions().then(function(petitions) {
          console.log("got some other actions");
          return deferred.resolve(petitions);
        });
        return deferred.promise;
      }
    ]
  };

}).call(this);
(function() {

  this.PollController = function($scope, PetitionServices, $http, Util, $rootScope) {
    $scope.poll = poll;
    window.scopes = $scope;
    $scope.loading = {
      show_spinner: false
    };
    $scope.getWidth = function() {
      return $(window).width();
    };
    $scope.$watch($scope.getWidth, function(newValue, oldValue) {
      return console.log("browser width changed");
    });
    window.onresize = function() {
      return $scope.$apply();
    };
    $scope.has_header_image = function() {
      if ($scope.poll.image_full) {
        return true;
      } else {
        return false;
      }
    };
    $scope.tweet = 'test';
    $scope.get_percentage_signed = function(signatures, target) {
      if ((signatures * 100) / target > 100) {
        return 100;
      } else {
        return (signatures * 100) / target;
      }
    };
    $scope.load_progress_marker = function(signatures, target) {
      var percentage, width;
      width = $("#progress-bar-wrapper").width();
      percentage = (signatures * 100) / target;
      if ((signatures * 100) / target > 100) {
        percentage = 100;
      }
      return (width * (percentage / 100)) + $("#progress-marker").width() / 2 + "px";
    };
    $scope.get_avatar_url = function(user) {
      if (user.avatar_url) {
        return user.avatar_url + "?type=large";
      } else {
        return '/assets/avatar.png';
      }
    };
    $scope.$on('$viewContentLoaded', function() {
      var new_height;
      console.log('view loaded');
      new_height = $(".view-enter#loaded-view").height();
      if ($(".with-rs-slider").length) {
        new_height += 450;
      }
      return $("#view-container").animate({
        height: new_height
      }, 1000, function() {
        return $scope.$apply(function() {
          return $scope.loading.show_spinner = false;
        });
      });
    });
    return $scope.load_progress_marker();
  };

}).call(this);
(function() {

  this.SignatureController = function($scope, PetitionServices, $http, Util, $rootScope) {
    Util.push_ga_event("Petition", "Load", "Sign");
    window.scope = $scope;
    $scope.signature_form = {
      first_name: '',
      last_name: '',
      email_address: '',
      zip_code: '',
      opt_in: true,
      comment: ''
    };
    $scope.sign_with_email_address = function(form) {
      var petition_id;
      console.log("signing petition with email address");
      form.submitted = true;
      if (form.$valid) {
        $scope.loading.show_spinner = true;
        petition_id = $scope.petition.petition_id;
        return PetitionServices.sign_with_email_address(petition_id, $scope.signature_form).success(function(response) {
          var result;
          console.log("signature complete");
          Util.push_ga_event("Petition", "Sign With Email", "Success");
          $scope.loading.show_spinner = false;
          result = response.result;
          $rootScope.petition = result.petition;
          $rootScope.signature = result.signature;
          $rootScope.$broadcast('signedPetition', $scope.signature);
          return Util.navigate("/deliver");
        }).error(function() {
          console.log("signature failed");
          Util.push_ga_event("Petition", "Sign With Email", "Failed");
          return $scope.loading.show_spinner = false;
        });
      }
    };
    $scope.set_action_background = function(action) {
      return {
        'background-image': 'url(assets/avatar.png)'
      };
    };
    return $scope.$on('handleFacebookAuth', function(event, source) {
      console.log("Facebook Login Success");
      return PetitionServices.sign_with_facebook($scope.auth, $scope.petition.petition_id, $scope.signature_form).success(function(response) {
        var fb_message_obj, result, scroll;
        if (response.statusCode === 200) {
          console.log("signature complete; trying to Share via FB");
          Util.push_ga_event("Petition", "Sign With Facebook", "Success");
          result = response.result;
          $rootScope.signature = result.signature;
          $rootScope.$broadcast('signedPetition', $scope.signature);
          fb_message_obj = {
            method: 'feed',
            link: $scope.petition.short_url,
            name: 'Sign the Petition',
            caption: $scope.petition.title,
            description: $scope.petition.summary
          };
          if (scope.petition.image_square) {
            $.extend(true, fb_message_obj, {
              picture: $scope.petition.image_square
            });
          } else {
            $.extend(true, fb_message_obj, {
              picture: 'http://snaptivist.s3.amazonaws.com/assets/logo_120x118.png'
            });
          }
          scroll = $(window).scrollTop();
          return FB.ui(fb_message_obj, function(response) {
            $(window).scrollTop(scroll);
            if (response) {
              console.log("share complete");
              Util.push_ga_event("Petition", "Facebook Share", "Success");
              return $scope.$apply(function() {
                return Util.navigate("/deliver");
              });
            } else {
              console.log("error sharing");
              Util.push_ga_event("Petition", "Facebook Share", "Failed");
              return $scope.$apply(function() {
                return Util.navigate("/deliver");
              });
            }
          });
        } else {
          console.log("error: " + response);
          return Util.push_ga_event("Petition", "Sign With Facebook", "Failed");
        }
      }).error(function(response) {
        console.log("signature failed: " + response);
        return Util.push_ga_event("Petition", "Sign With Facebook", "Failed");
      });
    });
  };

}).call(this);
(function() {

  this.app.factory("Util", [
    '$location', '$window', '$http', '$q', function($location, $window, $http, $q) {
      var data;
      data = {};
      data.is_mobile = false;
      return {
        data: function() {
          return data;
        },
        set_data: function(hash) {
          return data = $.extend(true, data, hash);
        },
        mobile_screen: function() {
          return $(window).width() < 959;
        },
        non_desktop: function() {
          return /Android|Mobile|webOS/.test(navigator.userAgent);
        },
        navigate_home: function() {
          return $window.location.href = '/';
        },
        navigate_back: function() {
          return $window.history.back();
        },
        navigate_absolute: function(url, hash, new_window) {
          if (hash) {
            url += hash;
          }
          if (new_window === true) {
            return $window.open(url);
          } else {
            return $window.location.href = url;
          }
        },
        navigate: function(url, query_params) {
          var k, v, _results;
          $location.path(url);
          _results = [];
          for (k in query_params) {
            v = query_params[k];
            _results.push($location.search(k, String(v).replace(" ", "+")));
          }
          return _results;
        },
        hide_iframe: function() {
          return parent.hideIframe();
        },
        browser_supports_flash: function() {
          return (typeof navigator.plugins !== "undefined" && typeof navigator.plugins["Shockwave Flash"] === "object") || (window.ActiveXObject && (new ActiveXObject("ShockwaveFlash.ShockwaveFlash")) !== false);
        },
        log_error: function(params) {
          console.log("ERROR: " + params.event_data);
          params.client_id = (data.is_mobile ? 2 : 1);
          params.event_id = '13';
          return $http.get('/api/log/event', {
            params: params
          }).success(function(response) {
            return console.log("Error message successful submitted to backend");
          });
        },
        query_params_obj: function() {
          var window_params;
          if ($window.location.search) {
            window_params = JSON.parse('{"' + decodeURI($window.location.search.replace(/^\?/, "").replace(/&/g, "\",\"").replace(/\=/g, "\":\"")) + '"}');
          } else {
            window_params = {};
          }
          return $.extend(window_params, $location.$$search);
        },
        create_iframe: function(src, passed_params) {
          var params;
          params = $.extend(this.query_params_obj(), passed_params);
          if (params) {
            src = "" + src + "?" + ($.param(params));
          }
          if (_test_env) {
            console.log("tracking iframe url: ", src);
          }
          return $("<iframe />", {
            width: "1",
            height: "1",
            frameborder: "0",
            scrolling: "no",
            style: "position:absolute;left : -9000px;top:-1000px",
            src: src
          }).appendTo("body");
        },
        marketing_pixel: function(event, params) {
          if (_test_env) {
            console.log("Attempting to create tracking pixel iframes for event: ", event);
          }
          switch (event) {
            case 'Authed':
              return this.create_iframe('/tracking/authed', params);
            case 'Accepted_offer':
              return this.create_iframe('/tracking/landing', params);
            case 'Purchase':
              return this.create_iframe('/tracking/treated', params);
          }
        },
        push_ga_event: function(category, action, label, value) {
          try {
            if (_test_env) {
              console.log("Adding GA event for: ", action);
            }
            return _gaq.push(["_trackEvent", category, action, label, value]);
          } catch (e) {
            return console.log("Failed to track event with GA: ", e.message);
          }
        },
        terms_of_service: function() {
          var deferred;
          deferred = $q.defer();
          $http.get('/api/texts/ts_and_cs').success(function(response) {
            if (response.statusCode === 200) {
              return deferred.resolve(response.result.text);
            }
          });
          return deferred.promise;
        },
        track_event: function(category, action, label, value, params) {
          this.push_ga_event(category, action, label, value);
          return this.marketing_pixel(category, params);
        },
        get_parameter: function(param) {
          var i, len, params, tmp, url;
          url = location.search;
          url = url.substring(url.indexOf("?") + 1, (url.indexOf("\n#") > -1 ? url.indexOf("#") : url.length));
          params = url.split("&");
          i = 0;
          len = params.length;
          while (i < len) {
            tmp = params[i].split("=");
            if (param === tmp[0]) {
              return tmp[1];
            }
            i++;
          }
          if ($location.$$search[param]) {
            return $location.$$search[param];
          } else {
            return null;
          }
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.factory("CommentServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get_comments: function(petition_id, offset) {
          var deferred;
          console.log("Fetch comments for Petition: ", petition_id);
          deferred = $q.defer();
          $http.get('/api/petitions/' + petition_id + '/signatures?offset=' + offset).success(function(response) {
            if (response.statusCode === 200) {
              return deferred.resolve(response);
            } else {
              return deferred.reject(response);
            }
          }).error(function(response) {
            return deferred.reject(response);
          });
          return deferred.promise;
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.factory("PetitionServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get_petition: function(petition_id) {
          var deferred;
          console.log("Fetching petition details for petition: ", petition_id);
          deferred = $q.defer();
          $http.get('/api/petitions', {
            params: {
              id: petition_id
            }
          }).success(function(response) {
            if (response.statusCode === 200) {
              return deferred.resolve(response);
            } else {
              return deferred.reject(response);
            }
          });
          return deferred.promise;
        },
        sign_with_facebook: function(auth, petition_id, signature) {
          var data;
          console.log("Petition Services: Signing with Facebook");
          data = {};
          data = $.extend(true, data, auth);
          data = $.extend(true, data, signature);
          return $http.post("/api/petitions/" + petition_id + "/sign_with_facebook", data);
        },
        sign_with_email_address: function(petition_id, signature) {
          console.log("Petition Services: Signing with Email Address");
          return $http.post("/api/petitions/" + petition_id + "/sign", signature);
        },
        sign_another: function(petition_id, signature) {
          console.log("Petition Services: Signing Another Petition");
          return $http.post("/api/petitions/" + petition_id + "/sign_another", signature);
        },
        deliver_signature: function(petition_id, signature_id, tweet) {
          var data;
          console.log("Delivering Signature: ", signature_id);
          data = {};
          data = $.extend(true, data, {
            'tweet': tweet
          });
          data = $.extend(true, data, {
            'signature_id': signature_id
          });
          return $http.post("/api/petitions/" + petition_id + "/share", data);
        },
        get_more_petitions: function() {
          var deferred;
          console.log("getting some more petitions");
          deferred = $q.defer();
          $http.get('/api/petitions/more').then(function(response) {
            if (response.data.statusCode === 200) {
              return deferred.resolve(response.data.result.petitions);
            } else {
              return deferred.reject(response);
            }
          });
          return deferred.promise;
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.directive("loadingScreen", function() {
    var postLink;
    return {
      restrict: 'EA',
      templateUrl: '/client_views/loading_screen',
      replace: true,
      scope: true,
      link: postLink = function(scope, element, attrs) {
        var background_color;
        element.hide();
        background_color = element.css('background-color');
        return scope.$watch(attrs.loadingScreen, function() {
          if (scope.$eval(attrs.loadingScreen)) {
            element.show();
          } else {
            element.hide();
          }
          if (scope.loading && scope.loading.hide_background) {
            return element.css('background-color', 'transparent');
          } else {
            return element.css('background-color', background_color);
          }
        }, true);
      }
    };
  });

}).call(this);
(function() {

  this.app.directive("royalSlider", [
    '$window', '$timeout', function($window, $timeout) {
      return function(scope, element, attrs) {
        var init_royal_slider, loop_toggle, thumbnail_toggle;
        element.addClass('royalSlider').addClass(attrs.royalSlider);
        loop_toggle = ($window.screen.width <= 959 ? false : true);
        thumbnail_toggle = 'none';
        scope.rs_display = true;
        init_royal_slider = function() {
          element.royalSlider({
            controlNavigation: thumbnail_toggle,
            imgWidth: 350,
            imgHeight: 350,
            addActiveClass: true,
            arrowsNav: true,
            keyboardNavEnabled: true,
            slidesSpacing: 10,
            navigateByClick: false,
            loop: loop_toggle,
            allowCSS3: true,
            randomizeSlides: false,
            usePreloader: true,
            arrowsNavHideOnTouch: true,
            globalCaption: false,
            imageScaleMode: 'fit',
            numImagesToPreload: 2,
            fadeInLoadedSlide: false,
            transitionType: 'move',
            transitionSpeed: 600,
            visibleNearby: {
              enabled: true,
              centerArea: 0.3,
              center: true,
              navigateByCenterClick: false,
              breakpoint: 959,
              breakpointCenterArea: 0.75
            }
          });
          scope.rs_display = true;
          return element.data('royalSlider').ev.on('rsBeforeAnimStart', function(event, type) {
            scope.action = {
              title: "New Petition"
            };
            console.log("Action changed to id: ", scope.action.title);
            if (!scope.$$phase) {
              return scope.$apply();
            }
          });
        };
        return $timeout(init_royal_slider, 0);
      };
    }
  ]);

}).call(this);
angular.module("ui.bootstrap", ["ui.bootstrap.transition","ui.bootstrap.collapse","ui.bootstrap.accordion","ui.bootstrap.alert","ui.bootstrap.buttons","ui.bootstrap.carousel","ui.bootstrap.dialog","ui.bootstrap.dropdownToggle","ui.bootstrap.modal","ui.bootstrap.pagination","ui.bootstrap.position","ui.bootstrap.tooltip","ui.bootstrap.popover","ui.bootstrap.progressbar","ui.bootstrap.rating","ui.bootstrap.tabs","ui.bootstrap.typeahead"]);
angular.module('ui.bootstrap.transition', [])

/**
 * $transition service provides a consistent interface to trigger CSS 3 transitions and to be informed when they complete.
 * @param  {DOMElement} element  The DOMElement that will be animated.
 * @param  {string|object|function} trigger  The thing that will cause the transition to start:
 *   - As a string, it represents the css class to be added to the element.
 *   - As an object, it represents a hash of style attributes to be applied to the element.
 *   - As a function, it represents a function to be called that will cause the transition to occur.
 * @return {Promise}  A promise that is resolved when the transition finishes.
 */
.factory('$transition', ['$q', '$timeout', '$rootScope', function($q, $timeout, $rootScope) {

  var $transition = function(element, trigger, options) {
    options = options || {};
    var deferred = $q.defer();
    var endEventName = $transition[options.animation ? "animationEndEventName" : "transitionEndEventName"];

    var transitionEndHandler = function(event) {
      $rootScope.$apply(function() {
        element.unbind(endEventName, transitionEndHandler);
        deferred.resolve(element);
      });
    };

    if (endEventName) {
      element.bind(endEventName, transitionEndHandler);
    }

    // Wrap in a timeout to allow the browser time to update the DOM before the transition is to occur
    $timeout(function() {
      if ( angular.isString(trigger) ) {
        element.addClass(trigger);
      } else if ( angular.isFunction(trigger) ) {
        trigger(element);
      } else if ( angular.isObject(trigger) ) {
        element.css(trigger);
      }
      //If browser does not support transitions, instantly resolve
      if ( !endEventName ) {
        deferred.resolve(element);
      }
    });

    // Add our custom cancel function to the promise that is returned
    // We can call this if we are about to run a new transition, which we know will prevent this transition from ending,
    // i.e. it will therefore never raise a transitionEnd event for that transition
    deferred.promise.cancel = function() {
      if ( endEventName ) {
        element.unbind(endEventName, transitionEndHandler);
      }
      deferred.reject('Transition cancelled');
    };

    return deferred.promise;
  };

  // Work out the name of the transitionEnd event
  var transElement = document.createElement('trans');
  var transitionEndEventNames = {
    'WebkitTransition': 'webkitTransitionEnd',
    'MozTransition': 'transitionend',
    'OTransition': 'oTransitionEnd',
    'transition': 'transitionend'
  };
  var animationEndEventNames = {
    'WebkitTransition': 'webkitAnimationEnd',
    'MozTransition': 'animationend',
    'OTransition': 'oAnimationEnd',
    'transition': 'animationend'
  };
  function findEndEventName(endEventNames) {
    for (var name in endEventNames){
      if (transElement.style[name] !== undefined) {
        return endEventNames[name];
      }
    }
  }
  $transition.transitionEndEventName = findEndEventName(transitionEndEventNames);
  $transition.animationEndEventName = findEndEventName(animationEndEventNames);
  return $transition;
}]);

angular.module('ui.bootstrap.collapse',['ui.bootstrap.transition'])

// The collapsible directive indicates a block of html that will expand and collapse
.directive('collapse', ['$transition', function($transition) {
  // CSS transitions don't work with height: auto, so we have to manually change the height to a
  // specific value and then once the animation completes, we can reset the height to auto.
  // Unfortunately if you do this while the CSS transitions are specified (i.e. in the CSS class
  // "collapse") then you trigger a change to height 0 in between.
  // The fix is to remove the "collapse" CSS class while changing the height back to auto - phew!
  var fixUpHeight = function(scope, element, height) {
    // We remove the collapse CSS class to prevent a transition when we change to height: auto
    element.removeClass('collapse');
    element.css({ height: height });
    // It appears that  reading offsetWidth makes the browser realise that we have changed the
    // height already :-/
    var x = element[0].offsetWidth;
    element.addClass('collapse');
  };

  return {
    link: function(scope, element, attrs) {

      var isCollapsed;
      var initialAnimSkip = true;
      scope.$watch(function (){ return element[0].scrollHeight; }, function (value) {
        //The listener is called when scollHeight changes
        //It actually does on 2 scenarios: 
        // 1. Parent is set to display none
        // 2. angular bindings inside are resolved
        //When we have a change of scrollHeight we are setting again the correct height if the group is opened
        if (element[0].scrollHeight !== 0) {
          if (!isCollapsed) {
            if (initialAnimSkip) {
              fixUpHeight(scope, element, element[0].scrollHeight + 'px');
            } else {
              fixUpHeight(scope, element, 'auto');
            }
          }
        }
      });
      
      scope.$watch(attrs.collapse, function(value) {
        if (value) {
          collapse();
        } else {
          expand();
        }
      });
      

      var currentTransition;
      var doTransition = function(change) {
        if ( currentTransition ) {
          currentTransition.cancel();
        }
        currentTransition = $transition(element,change);
        currentTransition.then(
          function() { currentTransition = undefined; },
          function() { currentTransition = undefined; }
        );
        return currentTransition;
      };

      var expand = function() {
        if (initialAnimSkip) {
          initialAnimSkip = false;
          if ( !isCollapsed ) {
            fixUpHeight(scope, element, 'auto');
          }
        } else {
          doTransition({ height : element[0].scrollHeight + 'px' })
          .then(function() {
            // This check ensures that we don't accidentally update the height if the user has closed
            // the group while the animation was still running
            if ( !isCollapsed ) {
              fixUpHeight(scope, element, 'auto');
            }
          });
        }
        isCollapsed = false;
      };
      
      var collapse = function() {
        isCollapsed = true;
        if (initialAnimSkip) {
          initialAnimSkip = false;
          fixUpHeight(scope, element, 0);
        } else {
          fixUpHeight(scope, element, element[0].scrollHeight + 'px');
          doTransition({'height':'0'});
        }
      };
    }
  };
}]);

angular.module('ui.bootstrap.accordion', ['ui.bootstrap.collapse'])

.constant('accordionConfig', {
  closeOthers: true
})

.controller('AccordionController', ['$scope', '$attrs', 'accordionConfig', function ($scope, $attrs, accordionConfig) {
  
  // This array keeps track of the accordion groups
  this.groups = [];

  // Ensure that all the groups in this accordion are closed, unless close-others explicitly says not to
  this.closeOthers = function(openGroup) {
    var closeOthers = angular.isDefined($attrs.closeOthers) ? $scope.$eval($attrs.closeOthers) : accordionConfig.closeOthers;
    if ( closeOthers ) {
      angular.forEach(this.groups, function (group) {
        if ( group !== openGroup ) {
          group.isOpen = false;
        }
      });
    }
  };
  
  // This is called from the accordion-group directive to add itself to the accordion
  this.addGroup = function(groupScope) {
    var that = this;
    this.groups.push(groupScope);

    groupScope.$on('$destroy', function (event) {
      that.removeGroup(groupScope);
    });
  };

  // This is called from the accordion-group directive when to remove itself
  this.removeGroup = function(group) {
    var index = this.groups.indexOf(group);
    if ( index !== -1 ) {
      this.groups.splice(this.groups.indexOf(group), 1);
    }
  };

}])

// The accordion directive simply sets up the directive controller
// and adds an accordion CSS class to itself element.
.directive('accordion', function () {
  return {
    restrict:'EA',
    controller:'AccordionController',
    transclude: true,
    replace: false,
    templateUrl: 'template/accordion/accordion.html'
  };
})

// The accordion-group directive indicates a block of html that will expand and collapse in an accordion
.directive('accordionGroup', ['$parse', '$transition', '$timeout', function($parse, $transition, $timeout) {
  return {
    require:'^accordion',         // We need this directive to be inside an accordion
    restrict:'EA',
    transclude:true,              // It transcludes the contents of the directive into the template
    replace: true,                // The element containing the directive will be replaced with the template
    templateUrl:'template/accordion/accordion-group.html',
    scope:{ heading:'@' },        // Create an isolated scope and interpolate the heading attribute onto this scope
    controller: ['$scope', function($scope) {
      this.setHeading = function(element) {
        this.heading = element;
      };
    }],
    link: function(scope, element, attrs, accordionCtrl) {
      var getIsOpen, setIsOpen;

      accordionCtrl.addGroup(scope);

      scope.isOpen = false;
      
      if ( attrs.isOpen ) {
        getIsOpen = $parse(attrs.isOpen);
        setIsOpen = getIsOpen.assign;

        scope.$watch(
          function watchIsOpen() { return getIsOpen(scope.$parent); },
          function updateOpen(value) { scope.isOpen = value; }
        );
        
        scope.isOpen = getIsOpen ? getIsOpen(scope.$parent) : false;
      }

      scope.$watch('isOpen', function(value) {
        if ( value ) {
          accordionCtrl.closeOthers(scope);
        }
        if ( setIsOpen ) {
          setIsOpen(scope.$parent, value);
        }
      });
    }
  };
}])

// Use accordion-heading below an accordion-group to provide a heading containing HTML
// <accordion-group>
//   <accordion-heading>Heading containing HTML - <img src="..."></accordion-heading>
// </accordion-group>
.directive('accordionHeading', function() {
  return {
    restrict: 'E',
    transclude: true,   // Grab the contents to be used as the heading
    template: '',       // In effect remove this element!
    replace: true,
    require: '^accordionGroup',
    compile: function(element, attr, transclude) {
      return function link(scope, element, attr, accordionGroupCtrl) {
        // Pass the heading to the accordion-group controller
        // so that it can be transcluded into the right place in the template
        // [The second parameter to transclude causes the elements to be cloned so that they work in ng-repeat]
        accordionGroupCtrl.setHeading(transclude(scope, function() {}));
      };
    }
  };
})

// Use in the accordion-group template to indicate where you want the heading to be transcluded
// You must provide the property on the accordion-group controller that will hold the transcluded element
// <div class="accordion-group">
//   <div class="accordion-heading" ><a ... accordion-transclude="heading">...</a></div>
//   ...
// </div>
.directive('accordionTransclude', function() {
  return {
    require: '^accordionGroup',
    link: function(scope, element, attr, controller) {
      scope.$watch(function() { return controller[attr.accordionTransclude]; }, function(heading) {
        if ( heading ) {
          element.html('');
          element.append(heading);
        }
      });
    }
  };
});

angular.module("ui.bootstrap.alert", []).directive('alert', function () {
  return {
    restrict:'EA',
    templateUrl:'template/alert/alert.html',
    transclude:true,
    replace:true,
    scope: {
      type: '=',
      close: '&'
    },
    link: function(scope, iElement, iAttrs, controller) {
      scope.closeable = "close" in iAttrs;
    }
  };
});

angular.module('ui.bootstrap.buttons', [])

  .constant('buttonConfig', {
    activeClass:'active',
    toggleEvent:'click'
  })

  .directive('btnRadio', ['buttonConfig', function (buttonConfig) {
  var activeClass = buttonConfig.activeClass || 'active';
  var toggleEvent = buttonConfig.toggleEvent || 'click';

  return {

    require:'ngModel',
    link:function (scope, element, attrs, ngModelCtrl) {

      var value = scope.$eval(attrs.btnRadio);

      //model -> UI
      scope.$watch(function () {
        return ngModelCtrl.$modelValue;
      }, function (modelValue) {
        if (angular.equals(modelValue, value)){
          element.addClass(activeClass);
        } else {
          element.removeClass(activeClass);
        }
      });

      //ui->model
      element.bind(toggleEvent, function () {
        if (!element.hasClass(activeClass)) {
          scope.$apply(function () {
            ngModelCtrl.$setViewValue(value);
          });
        }
      });
    }
  };
}])

  .directive('btnCheckbox', ['buttonConfig', function (buttonConfig) {

  var activeClass = buttonConfig.activeClass || 'active';
  var toggleEvent = buttonConfig.toggleEvent || 'click';

  return {
    require:'ngModel',
    link:function (scope, element, attrs, ngModelCtrl) {

      var trueValue = scope.$eval(attrs.btnCheckboxTrue);
      var falseValue = scope.$eval(attrs.btnCheckboxFalse);

      trueValue = angular.isDefined(trueValue) ? trueValue : true;
      falseValue = angular.isDefined(falseValue) ? falseValue : false;

      //model -> UI
      scope.$watch(function () {
        return ngModelCtrl.$modelValue;
      }, function (modelValue) {
        if (angular.equals(modelValue, trueValue)) {
          element.addClass(activeClass);
        } else {
          element.removeClass(activeClass);
        }
      });

      //ui->model
      element.bind(toggleEvent, function () {
        scope.$apply(function () {
          ngModelCtrl.$setViewValue(element.hasClass(activeClass) ? falseValue : trueValue);
        });
      });
    }
  };
}]);
/*
*
*    AngularJS Bootstrap Carousel 
*
*      A pure AngularJS carousel.
*      
*      For no interval set the interval to non-number, or milliseconds of desired interval
*      Template: <carousel interval="none"><slide>{{anything}}</slide></carousel>
*      To change the carousel's active slide set the active attribute to true
*      Template: <carousel interval="none"><slide active="someModel">{{anything}}</slide></carousel>
*/
angular.module('ui.bootstrap.carousel', ['ui.bootstrap.transition'])
.controller('CarouselController', ['$scope', '$timeout', '$transition', '$q', function ($scope, $timeout, $transition, $q) {
  var self = this,
    slides = self.slides = [],
    currentIndex = -1,
    currentTimeout, isPlaying;
  self.currentSlide = null;

  /* direction: "prev" or "next" */
  self.select = function(nextSlide, direction) {
    var nextIndex = slides.indexOf(nextSlide);
    //Decide direction if it's not given
    if (direction === undefined) {
      direction = nextIndex > currentIndex ? "next" : "prev";
    }
    if (nextSlide && nextSlide !== self.currentSlide) {
      if ($scope.$currentTransition) {
        $scope.$currentTransition.cancel();
        //Timeout so ng-class in template has time to fix classes for finished slide
        $timeout(goNext);
      } else {
        goNext();
      }
    }
    function goNext() {
      //If we have a slide to transition from and we have a transition type and we're allowed, go
      if (self.currentSlide && angular.isString(direction) && !$scope.noTransition && nextSlide.$element) { 
        //We shouldn't do class manip in here, but it's the same weird thing bootstrap does. need to fix sometime
        nextSlide.$element.addClass(direction);
        nextSlide.$element[0].offsetWidth = nextSlide.$element[0].offsetWidth; //force reflow

        //Set all other slides to stop doing their stuff for the new transition
        angular.forEach(slides, function(slide) {
          angular.extend(slide, {direction: '', entering: false, leaving: false, active: false});
        });
        angular.extend(nextSlide, {direction: direction, active: true, entering: true});
        angular.extend(self.currentSlide||{}, {direction: direction, leaving: true});

        $scope.$currentTransition = $transition(nextSlide.$element, {});
        //We have to create new pointers inside a closure since next & current will change
        (function(next,current) {
          $scope.$currentTransition.then(
            function(){ transitionDone(next, current); },
            function(){ transitionDone(next, current); }
          );
        }(nextSlide, self.currentSlide));
      } else {
        transitionDone(nextSlide, self.currentSlide);
      }
      self.currentSlide = nextSlide;
      currentIndex = nextIndex;
      //every time you change slides, reset the timer
      restartTimer();
    }
    function transitionDone(next, current) {
      angular.extend(next, {direction: '', active: true, leaving: false, entering: false});
      angular.extend(current||{}, {direction: '', active: false, leaving: false, entering: false});
      $scope.$currentTransition = null;
    }
  };

  /* Allow outside people to call indexOf on slides array */
  self.indexOfSlide = function(slide) {
    return slides.indexOf(slide);
  };

  $scope.next = function() {
    var newIndex = (currentIndex + 1) % slides.length;
    return self.select(slides[newIndex], 'next');
  };

  $scope.prev = function() {
    var newIndex = currentIndex - 1 < 0 ? slides.length - 1 : currentIndex - 1;
    return self.select(slides[newIndex], 'prev');
  };

  $scope.select = function(slide) {
    self.select(slide);
  };

  $scope.isActive = function(slide) {
     return self.currentSlide === slide;
  };

  $scope.slides = function() {
    return slides;
  };

  $scope.$watch('interval', restartTimer);
  function restartTimer() {
    if (currentTimeout) {
      $timeout.cancel(currentTimeout);
    }
    function go() {
      if (isPlaying) {
        $scope.next();
        restartTimer();
      } else {
        $scope.pause();
      }
    }
    var interval = +$scope.interval;
    if (!isNaN(interval) && interval>=0) {
      currentTimeout = $timeout(go, interval);
    }
  }
  $scope.play = function() {
    if (!isPlaying) {
      isPlaying = true;
      restartTimer();
    }
  };
  $scope.pause = function() {
    isPlaying = false;
    if (currentTimeout) {
      $timeout.cancel(currentTimeout);
    }
  };

  self.addSlide = function(slide, element) {
    slide.$element = element;
    slides.push(slide);
    //if this is the first slide or the slide is set to active, select it
    if(slides.length === 1 || slide.active) {
      self.select(slides[slides.length-1]);
      if (slides.length == 1) {
        $scope.play();
      }
    } else {
      slide.active = false;
    }
  };

  self.removeSlide = function(slide) {
    //get the index of the slide inside the carousel
    var index = slides.indexOf(slide);
    slides.splice(index, 1);
    if (slides.length > 0 && slide.active) {
      if (index >= slides.length) {
        self.select(slides[index-1]);
      } else {
        self.select(slides[index]);
      }
    }
  };
}])
.directive('carousel', [function() {
  return {
    restrict: 'EA',
    transclude: true,
    replace: true,
    controller: 'CarouselController',
    require: 'carousel',
    templateUrl: 'template/carousel/carousel.html',
    scope: {
      interval: '=',
      noTransition: '='
    }
  };
}])
.directive('slide', [function() {
  return {
    require: '^carousel',
    restrict: 'EA',
    transclude: true,
    replace: true,
    templateUrl: 'template/carousel/slide.html',
    scope: {
      active: '='
    },
    link: function (scope, element, attrs, carouselCtrl) {
      carouselCtrl.addSlide(scope, element);
      //when the scope is destroyed then remove the slide from the current slides array
      scope.$on('$destroy', function() {
        carouselCtrl.removeSlide(scope);
      });

      scope.$watch('active', function(active) {
        if (active) {
          carouselCtrl.select(scope);
        }
      });
    }
  };
}]);

// The `$dialogProvider` can be used to configure global defaults for your
// `$dialog` service.
var dialogModule = angular.module('ui.bootstrap.dialog', ['ui.bootstrap.transition']);

dialogModule.controller('MessageBoxController', ['$scope', 'dialog', 'model', function($scope, dialog, model){
  $scope.title = model.title;
  $scope.message = model.message;
  $scope.buttons = model.buttons;
  $scope.close = function(res){
    dialog.close(res);
  };
}]);

dialogModule.provider("$dialog", function(){

  // The default options for all dialogs.
  var defaults = {
    backdrop: true,
    dialogClass: 'modal',
    backdropClass: 'modal-backdrop',
    transitionClass: 'fade',
    triggerClass: 'in',
    dialogOpenClass: 'modal-open',  
    resolve:{},
    backdropFade: false,
    dialogFade:false,
    keyboard: true, // close with esc key
    backdropClick: true // only in conjunction with backdrop=true
    /* other options: template, templateUrl, controller */
	};

	var globalOptions = {};

  var activeBackdrops = {value : 0};

  // The `options({})` allows global configuration of all dialogs in the application.
  //
  //      var app = angular.module('App', ['ui.bootstrap.dialog'], function($dialogProvider){
  //        // don't close dialog when backdrop is clicked by default
  //        $dialogProvider.options({backdropClick: false});
  //      });
	this.options = function(value){
		globalOptions = value;
	};

  // Returns the actual `$dialog` service that is injected in controllers
	this.$get = ["$http", "$document", "$compile", "$rootScope", "$controller", "$templateCache", "$q", "$transition", "$injector",
  function ($http, $document, $compile, $rootScope, $controller, $templateCache, $q, $transition, $injector) {

		var body = $document.find('body');

		function createElement(clazz) {
			var el = angular.element("<div>");
			el.addClass(clazz);
			return el;
		}

    // The `Dialog` class represents a modal dialog. The dialog class can be invoked by providing an options object
    // containing at lest template or templateUrl and controller:
    //
    //     var d = new Dialog({templateUrl: 'foo.html', controller: 'BarController'});
    //
    // Dialogs can also be created using templateUrl and controller as distinct arguments:
    //
    //     var d = new Dialog('path/to/dialog.html', MyDialogController);
		function Dialog(opts) {

      var self = this, options = this.options = angular.extend({}, defaults, globalOptions, opts);
      this._open = false;

      this.backdropEl = createElement(options.backdropClass);
      if(options.backdropFade){
        this.backdropEl.addClass(options.transitionClass);
        this.backdropEl.removeClass(options.triggerClass);
      }

      this.modalEl = createElement(options.dialogClass);
      if(options.dialogFade){
        this.modalEl.addClass(options.transitionClass);
        this.modalEl.removeClass(options.triggerClass);
      }

      this.handledEscapeKey = function(e) {
        if (e.which === 27) {
          self.close();
          e.preventDefault();
          self.$scope.$apply();
        }
      };

      this.handleBackDropClick = function(e) {
        self.close();
        e.preventDefault();
        self.$scope.$apply();
      };

      this.handleLocationChange = function() {
        self.close();
      };
    }

    // The `isOpen()` method returns wether the dialog is currently visible.
    Dialog.prototype.isOpen = function(){
      return this._open;
    };

    // The `open(templateUrl, controller)` method opens the dialog.
    // Use the `templateUrl` and `controller` arguments if specifying them at dialog creation time is not desired.
    Dialog.prototype.open = function(templateUrl, controller){
      var self = this, options = this.options;

      if(templateUrl){
        options.templateUrl = templateUrl;
      }
      if(controller){
        options.controller = controller;
      }

      if(!(options.template || options.templateUrl)) {
        throw new Error('Dialog.open expected template or templateUrl, neither found. Use options or open method to specify them.');
      }

      this._loadResolves().then(function(locals) {
        var $scope = locals.$scope = self.$scope = locals.$scope ? locals.$scope : $rootScope.$new();

        self.modalEl.html(locals.$template);

        if (self.options.controller) {
          var ctrl = $controller(self.options.controller, locals);
          self.modalEl.children().data('ngControllerController', ctrl);
        }

        $compile(self.modalEl)($scope);
        self._addElementsToDom();
        body.addClass(self.options.dialogOpenClass);

        // trigger tranisitions
        setTimeout(function(){
          if(self.options.dialogFade){ self.modalEl.addClass(self.options.triggerClass); }
          if(self.options.backdropFade){ self.backdropEl.addClass(self.options.triggerClass); }
        });

        self._bindEvents();
      });

      this.deferred = $q.defer();
      return this.deferred.promise;
    };

    // closes the dialog and resolves the promise returned by the `open` method with the specified result.
    Dialog.prototype.close = function(result){
      var self = this;
      var fadingElements = this._getFadingElements();

      body.removeClass(self.options.dialogOpenClass);
      if(fadingElements.length > 0){
        for (var i = fadingElements.length - 1; i >= 0; i--) {
          $transition(fadingElements[i], removeTriggerClass).then(onCloseComplete);
        }
        return;
      }

      this._onCloseComplete(result);

      function removeTriggerClass(el){
        el.removeClass(self.options.triggerClass);
      }

      function onCloseComplete(){
        if(self._open){
          self._onCloseComplete(result);
        }
      }
    };

    Dialog.prototype._getFadingElements = function(){
      var elements = [];
      if(this.options.dialogFade){
        elements.push(this.modalEl);
      }
      if(this.options.backdropFade){
        elements.push(this.backdropEl);
      }

      return elements;
    };

    Dialog.prototype._bindEvents = function() {
      if(this.options.keyboard){ body.bind('keydown', this.handledEscapeKey); }
      if(this.options.backdrop && this.options.backdropClick){ this.backdropEl.bind('click', this.handleBackDropClick); }

      this.$scope.$on('$locationChangeSuccess', this.handleLocationChange);
    };

    Dialog.prototype._unbindEvents = function() {
      if(this.options.keyboard){ body.unbind('keydown', this.handledEscapeKey); }
      if(this.options.backdrop && this.options.backdropClick){ this.backdropEl.unbind('click', this.handleBackDropClick); }
    };

    Dialog.prototype._onCloseComplete = function(result) {
      this._removeElementsFromDom();
      this._unbindEvents();

      this.deferred.resolve(result);
    };

    Dialog.prototype._addElementsToDom = function(){
      body.append(this.modalEl);

      if(this.options.backdrop) { 
        if (activeBackdrops.value === 0) {
          body.append(this.backdropEl); 
        }
        activeBackdrops.value++;
      }

      this._open = true;
    };

    Dialog.prototype._removeElementsFromDom = function(){
      this.modalEl.remove();

      if(this.options.backdrop) { 
        activeBackdrops.value--;
        if (activeBackdrops.value === 0) {
          this.backdropEl.remove(); 
        }
      }
      this._open = false;
    };

    // Loads all `options.resolve` members to be used as locals for the controller associated with the dialog.
    Dialog.prototype._loadResolves = function(){
      var values = [], keys = [], templatePromise, self = this;

      if (this.options.template) {
        templatePromise = $q.when(this.options.template);
      } else if (this.options.templateUrl) {
        templatePromise = $http.get(this.options.templateUrl, {cache:$templateCache})
        .then(function(response) { return response.data; });
      }

      angular.forEach(this.options.resolve || [], function(value, key) {
        keys.push(key);
        values.push(angular.isString(value) ? $injector.get(value) : $injector.invoke(value));
      });

      keys.push('$template');
      values.push(templatePromise);

      return $q.all(values).then(function(values) {
        var locals = {};
        angular.forEach(values, function(value, index) {
          locals[keys[index]] = value;
        });
        locals.dialog = self;
        return locals;
      });
    };

    // The actual `$dialog` service that is injected in controllers.
    return {
      // Creates a new `Dialog` with the specified options.
      dialog: function(opts){
        return new Dialog(opts);
      },
      // creates a new `Dialog` tied to the default message box template and controller.
      //
      // Arguments `title` and `message` are rendered in the modal header and body sections respectively.
      // The `buttons` array holds an object with the following members for each button to include in the
      // modal footer section:
      //
      // * `result`: the result to pass to the `close` method of the dialog when the button is clicked
      // * `label`: the label of the button
      // * `cssClass`: additional css class(es) to apply to the button for styling
      messageBox: function(title, message, buttons){
        return new Dialog({templateUrl: 'template/dialog/message.html', controller: 'MessageBoxController', resolve:
          {model: function() {
            return {
              title: title,
              message: message,
              buttons: buttons
            };
          }
        }});
      }
    };
  }];
});

/*
 * dropdownToggle - Provides dropdown menu functionality in place of bootstrap js
 * @restrict class or attribute
 * @example:
   <li class="dropdown">
     <a class="dropdown-toggle">My Dropdown Menu</a>
     <ul class="dropdown-menu">
       <li ng-repeat="choice in dropChoices">
         <a ng-href="{{choice.href}}">{{choice.text}}</a>
       </li>
     </ul>
   </li>
 */

angular.module('ui.bootstrap.dropdownToggle', []).directive('dropdownToggle',
  ['$document', '$location', '$window', function ($document, $location, $window) {
  var openElement = null,
      closeMenu   = angular.noop;
  return {
    restrict: 'CA',
    link: function(scope, element, attrs) {
      scope.$watch('$location.path', function() { closeMenu(); });
      element.parent().bind('click', function() { closeMenu(); });
      element.bind('click', function(event) {
        event.preventDefault();
        event.stopPropagation();
        var elementWasOpen = (element === openElement);
        if (!!openElement) {
          closeMenu(); }
        if (!elementWasOpen){
          element.parent().addClass('open');
          openElement = element;
          closeMenu = function (event) {
            if (event) {
              event.preventDefault();
              event.stopPropagation();
            }
            $document.unbind('click', closeMenu);
            element.parent().removeClass('open');
            closeMenu   = angular.noop;
            openElement = null;
          };
          $document.bind('click', closeMenu);
        }
      });
    }
  };
}]);
angular.module('ui.bootstrap.modal', ['ui.bootstrap.dialog'])
.directive('modal', ['$parse', '$dialog', function($parse, $dialog) {
  return {
    restrict: 'EA',
    terminal: true,
    link: function(scope, elm, attrs) {
      var opts = angular.extend({}, scope.$eval(attrs.uiOptions || attrs.bsOptions || attrs.options));
      var shownExpr = attrs.modal || attrs.show;
      var setClosed;

      // Create a dialog with the template as the contents of the directive
      // Add the current scope as the resolve in order to make the directive scope as a dialog controller scope
      opts = angular.extend(opts, {
        template: elm.html(), 
        resolve: { $scope: function() { return scope; } }
      });
      var dialog = $dialog.dialog(opts);

      elm.remove();

      if (attrs.close) {
        setClosed = function() {
          $parse(attrs.close)(scope);
        };
      } else {
        setClosed = function() {         
          if (angular.isFunction($parse(shownExpr).assign)) {
            $parse(shownExpr).assign(scope, false); 
          }
        };
      }

      scope.$watch(shownExpr, function(isShown, oldShown) {
        if (isShown) {
          dialog.open().then(function(){
            setClosed();
          });
        } else {
          //Make sure it is not opened
          if (dialog.isOpen()){
            dialog.close();
          }
        }
      });
    }
  };
}]);
angular.module('ui.bootstrap.pagination', [])

.constant('paginationConfig', {
  boundaryLinks: false,
  directionLinks: true,
  firstText: 'First',
  previousText: 'Previous',
  nextText: 'Next',
  lastText: 'Last'
})

.directive('pagination', ['paginationConfig', function(paginationConfig) {
  return {
    restrict: 'EA',
    scope: {
      numPages: '=',
      currentPage: '=',
      maxSize: '=',
      onSelectPage: '&'
    },
    templateUrl: 'template/pagination/pagination.html',
    replace: true,
    link: function(scope, element, attrs) {

      // Setup configuration parameters
      var boundaryLinks = angular.isDefined(attrs.boundaryLinks) ? scope.$eval(attrs.boundaryLinks) : paginationConfig.boundaryLinks;
      var directionLinks = angular.isDefined(attrs.directionLinks) ? scope.$eval(attrs.directionLinks) : paginationConfig.directionLinks;
      var firstText = angular.isDefined(attrs.firstText) ? attrs.firstText : paginationConfig.firstText;
      var previousText = angular.isDefined(attrs.previousText) ? attrs.previousText : paginationConfig.previousText;
      var nextText = angular.isDefined(attrs.nextText) ? attrs.nextText : paginationConfig.nextText;
      var lastText = angular.isDefined(attrs.lastText) ? attrs.lastText : paginationConfig.lastText;

      // Create page object used in template
      function makePage(number, text, isActive, isDisabled) {
        return {
          number: number,
          text: text,
          active: isActive,
          disabled: isDisabled
        };
      }

      scope.$watch('numPages + currentPage + maxSize', function() {
        scope.pages = [];
        
        // Default page limits
        var startPage = 1, endPage = scope.numPages;

        // recompute if maxSize
        if ( scope.maxSize && scope.maxSize < scope.numPages ) {
          startPage = Math.max(scope.currentPage - Math.floor(scope.maxSize/2), 1);
          endPage   = startPage + scope.maxSize - 1;

          // Adjust if limit is exceeded
          if (endPage > scope.numPages) {
            endPage   = scope.numPages;
            startPage = endPage - scope.maxSize + 1;
          }
        }

        // Add page number links
        for (var number = startPage; number <= endPage; number++) {
          var page = makePage(number, number, scope.isActive(number), false);
          scope.pages.push(page);
        }

        // Add previous & next links
        if (directionLinks) {
          var previousPage = makePage(scope.currentPage - 1, previousText, false, scope.noPrevious());
          scope.pages.unshift(previousPage);

          var nextPage = makePage(scope.currentPage + 1, nextText, false, scope.noNext());
          scope.pages.push(nextPage);
        }

        // Add first & last links
        if (boundaryLinks) {
          var firstPage = makePage(1, firstText, false, scope.noPrevious());
          scope.pages.unshift(firstPage);

          var lastPage = makePage(scope.numPages, lastText, false, scope.noNext());
          scope.pages.push(lastPage);
        }


        if ( scope.currentPage > scope.numPages ) {
          scope.selectPage(scope.numPages);
        }
      });
      scope.noPrevious = function() {
        return scope.currentPage === 1;
      };
      scope.noNext = function() {
        return scope.currentPage === scope.numPages;
      };
      scope.isActive = function(page) {
        return scope.currentPage === page;
      };

      scope.selectPage = function(page) {
        if ( ! scope.isActive(page) && page > 0 && page <= scope.numPages) {
          scope.currentPage = page;
          scope.onSelectPage({ page: page });
        }
      };
    }
  };
}]);
angular.module('ui.bootstrap.position', [])

/**
 * A set of utility methods that can be use to retrieve position of DOM elements.
 * It is meant to be used where we need to absolute-position DOM elements in
 * relation to other, existing elements (this is the case for tooltips, popovers,
 * typeahead suggestions etc.).
 */
  .factory('$position', ['$document', '$window', function ($document, $window) {

    function getStyle(el, cssprop) {
      if (el.currentStyle) { //IE
        return el.currentStyle[cssprop];
      } else if ($window.getComputedStyle) {
        return $window.getComputedStyle(el)[cssprop];
      }
      // finally try and get inline style
      return el.style[cssprop];
    }

    /**
     * Checks if a given element is statically positioned
     * @param element - raw DOM element
     */
    function isStaticPositioned(element) {
      return (getStyle(element, "position") || 'static' ) === 'static';
    }

    /**
     * returns the closest, non-statically positioned parentOffset of a given element
     * @param element
     */
    var parentOffsetEl = function (element) {
      var docDomEl = $document[0];
      var offsetParent = element.offsetParent || docDomEl;
      while (offsetParent && offsetParent !== docDomEl && isStaticPositioned(offsetParent) ) {
        offsetParent = offsetParent.offsetParent;
      }
      return offsetParent || docDomEl;
    };

    return {
      /**
       * Provides read-only equivalent of jQuery's position function:
       * http://api.jquery.com/position/
       */
      position: function (element) {
        var elBCR = this.offset(element);
        var offsetParentBCR = { top: 0, left: 0 };
        var offsetParentEl = parentOffsetEl(element[0]);
        if (offsetParentEl != $document[0]) {
          offsetParentBCR = this.offset(angular.element(offsetParentEl));
          offsetParentBCR.top += offsetParentEl.clientTop;
          offsetParentBCR.left += offsetParentEl.clientLeft;
        }

        return {
          width: element.prop('offsetWidth'),
          height: element.prop('offsetHeight'),
          top: elBCR.top - offsetParentBCR.top,
          left: elBCR.left - offsetParentBCR.left
        };
      },

      /**
       * Provides read-only equivalent of jQuery's offset function:
       * http://api.jquery.com/offset/
       */
      offset: function (element) {
        var boundingClientRect = element[0].getBoundingClientRect();
        return {
          width: element.prop('offsetWidth'),
          height: element.prop('offsetHeight'),
          top: boundingClientRect.top + ($window.pageYOffset || $document[0].body.scrollTop),
          left: boundingClientRect.left + ($window.pageXOffset || $document[0].body.scrollLeft)
        };
      }
    };
  }]);

/**
 * The following features are still outstanding: animation as a
 * function, placement as a function, inside, support for more triggers than
 * just mouse enter/leave, html tooltips, and selector delegation.
 */
angular.module( 'ui.bootstrap.tooltip', [ 'ui.bootstrap.position' ] )

/**
 * The $tooltip service creates tooltip- and popover-like directives as well as
 * houses global options for them.
 */
.provider( '$tooltip', function () {
  // The default options tooltip and popover.
  var defaultOptions = {
    placement: 'top',
    animation: true,
    popupDelay: 0
  };

  // Default hide triggers for each show trigger
  var triggerMap = {
    'mouseenter': 'mouseleave',
    'click': 'click',
    'focus': 'blur'
  };

  // The options specified to the provider globally.
  var globalOptions = {};
  
  /**
   * `options({})` allows global configuration of all tooltips in the
   * application.
   *
   *   var app = angular.module( 'App', ['ui.bootstrap.tooltip'], function( $tooltipProvider ) {
   *     // place tooltips left instead of top by default
   *     $tooltipProvider.options( { placement: 'left' } );
   *   });
   */
	this.options = function( value ) {
		angular.extend( globalOptions, value );
	};

  /**
   * This is a helper function for translating camel-case to snake-case.
   */
  function snake_case(name){
    var regexp = /[A-Z]/g;
    var separator = '-';
    return name.replace(regexp, function(letter, pos) {
      return (pos ? separator : '') + letter.toLowerCase();
    });
  }

  /**
   * Returns the actual instance of the $tooltip service.
   * TODO support multiple triggers
   */
  this.$get = [ '$window', '$compile', '$timeout', '$parse', '$document', '$position', function ( $window, $compile, $timeout, $parse, $document, $position ) {
    return function $tooltip ( type, prefix, defaultTriggerShow ) {
      var options = angular.extend( {}, defaultOptions, globalOptions );

      /**
       * Returns an object of show and hide triggers.
       *
       * If a trigger is supplied,
       * it is used to show the tooltip; otherwise, it will use the `trigger`
       * option passed to the `$tooltipProvider.options` method; else it will
       * default to the trigger supplied to this directive factory.
       *
       * The hide trigger is based on the show trigger. If the `trigger` option
       * was passed to the `$tooltipProvider.options` method, it will use the
       * mapped trigger from `triggerMap` or the passed trigger if the map is
       * undefined; otherwise, it uses the `triggerMap` value of the show
       * trigger; else it will just use the show trigger.
       */
      function setTriggers ( trigger ) {
        var show, hide;
       
        show = trigger || options.trigger || defaultTriggerShow;
        if ( angular.isDefined ( options.trigger ) ) {
          hide = triggerMap[options.trigger] || show;
        } else {
          hide = triggerMap[show] || show;
        }

        return {
          show: show,
          hide: hide
        };
      }

      var directiveName = snake_case( type );
      var triggers = setTriggers( undefined );

      var template = 
        '<'+ directiveName +'-popup '+
          'title="{{tt_title}}" '+
          'content="{{tt_content}}" '+
          'placement="{{tt_placement}}" '+
          'animation="tt_animation()" '+
          'is-open="tt_isOpen"'+
          '>'+
        '</'+ directiveName +'-popup>';

      return {
        restrict: 'EA',
        scope: true,
        link: function link ( scope, element, attrs ) {
          var tooltip = $compile( template )( scope );
          var transitionTimeout;
          var popupTimeout;
          var $body;

          // By default, the tooltip is not open.
          // TODO add ability to start tooltip opened
          scope.tt_isOpen = false;

          function toggleTooltipBind () {
            if ( ! scope.tt_isOpen ) {
              showTooltipBind();
            } else {
              hideTooltipBind();
            }
          }
          
          // Show the tooltip with delay if specified, otherwise show it immediately
          function showTooltipBind() {
            if ( scope.tt_popupDelay ) {
              popupTimeout = $timeout( show, scope.tt_popupDelay );
            } else {
              scope.$apply( show );
            }
          }

          function hideTooltipBind () {
            scope.$apply(function () {
              hide();
            });
          }
          
          // Show the tooltip popup element.
          function show() {
            var position,
                ttWidth,
                ttHeight,
                ttPosition;

            // Don't show empty tooltips.
            if ( ! scope.tt_content ) {
              return;
            }

            // If there is a pending remove transition, we must cancel it, lest the
            // tooltip be mysteriously removed.
            if ( transitionTimeout ) {
              $timeout.cancel( transitionTimeout );
            }
            
            // Set the initial positioning.
            tooltip.css({ top: 0, left: 0, display: 'block' });
            
            // Now we add it to the DOM because need some info about it. But it's not 
            // visible yet anyway.
            if ( options.appendToBody ) {
                $body = $body || $document.find( 'body' );
                $body.append( tooltip );
            } else {
              element.after( tooltip );
            }
            
            // Get the position of the directive element.
            position = $position.position( element );

            // Get the height and width of the tooltip so we can center it.
            ttWidth = tooltip.prop( 'offsetWidth' );
            ttHeight = tooltip.prop( 'offsetHeight' );
            
            // Calculate the tooltip's top and left coordinates to center it with
            // this directive.
            switch ( scope.tt_placement ) {
              case 'right':
                ttPosition = {
                  top: (position.top + position.height / 2 - ttHeight / 2) + 'px',
                  left: (position.left + position.width) + 'px'
                };
                break;
              case 'bottom':
                ttPosition = {
                  top: (position.top + position.height) + 'px',
                  left: (position.left + position.width / 2 - ttWidth / 2) + 'px'
                };
                break;
              case 'left':
                ttPosition = {
                  top: (position.top + position.height / 2 - ttHeight / 2) + 'px',
                  left: (position.left - ttWidth) + 'px'
                };
                break;
              default:
                ttPosition = {
                  top: (position.top - ttHeight) + 'px',
                  left: (position.left + position.width / 2 - ttWidth / 2) + 'px'
                };
                break;
            }
            
            // Now set the calculated positioning.
            tooltip.css( ttPosition );
              
            // And show the tooltip.
            scope.tt_isOpen = true;
          }
          
          // Hide the tooltip popup element.
          function hide() {
            // First things first: we don't show it anymore.
            scope.tt_isOpen = false;

            //if tooltip is going to be shown after delay, we must cancel this
            $timeout.cancel( popupTimeout );
            
            // And now we remove it from the DOM. However, if we have animation, we 
            // need to wait for it to expire beforehand.
            // FIXME: this is a placeholder for a port of the transitions library.
            if ( angular.isDefined( scope.tt_animation ) && scope.tt_animation() ) {
              transitionTimeout = $timeout( function () { tooltip.remove(); }, 500 );
            } else {
              tooltip.remove();
            }
          }

          /**
           * Observe the relevant attributes.
           */
          attrs.$observe( type, function ( val ) {
            scope.tt_content = val;
          });

          attrs.$observe( prefix+'Title', function ( val ) {
            scope.tt_title = val;
          });

          attrs.$observe( prefix+'Placement', function ( val ) {
            scope.tt_placement = angular.isDefined( val ) ? val : options.placement;
          });

          attrs.$observe( prefix+'Animation', function ( val ) {
            scope.tt_animation = angular.isDefined( val ) ? $parse( val ) : function(){ return options.animation; };
          });

          attrs.$observe( prefix+'PopupDelay', function ( val ) {
            var delay = parseInt( val, 10 );
            scope.tt_popupDelay = ! isNaN(delay) ? delay : options.popupDelay;
          });

          attrs.$observe( prefix+'Trigger', function ( val ) {
            element.unbind( triggers.show );
            element.unbind( triggers.hide );

            triggers = setTriggers( val );

            if ( triggers.show === triggers.hide ) {
              element.bind( triggers.show, toggleTooltipBind );
            } else {
              element.bind( triggers.show, showTooltipBind );
              element.bind( triggers.hide, hideTooltipBind );
            }
          });
        }
      };
    };
  }];
})

.directive( 'tooltipPopup', function () {
  return {
    restrict: 'E',
    replace: true,
    scope: { content: '@', placement: '@', animation: '&', isOpen: '&' },
    templateUrl: 'template/tooltip/tooltip-popup.html'
  };
})

.directive( 'tooltip', [ '$tooltip', function ( $tooltip ) {
  return $tooltip( 'tooltip', 'tooltip', 'mouseenter' );
}])

.directive( 'tooltipHtmlUnsafePopup', function () {
  return {
    restrict: 'E',
    replace: true,
    scope: { content: '@', placement: '@', animation: '&', isOpen: '&' },
    templateUrl: 'template/tooltip/tooltip-html-unsafe-popup.html'
  };
})

.directive( 'tooltipHtmlUnsafe', [ '$tooltip', function ( $tooltip ) {
  return $tooltip( 'tooltipHtmlUnsafe', 'tooltip', 'mouseenter' );
}])

;


/**
 * The following features are still outstanding: popup delay, animation as a
 * function, placement as a function, inside, support for more triggers than
 * just mouse enter/leave, html popovers, and selector delegatation.
 */
angular.module( 'ui.bootstrap.popover', [ 'ui.bootstrap.tooltip' ] )
.directive( 'popoverPopup', function () {
  return {
    restrict: 'EA',
    replace: true,
    scope: { title: '@', content: '@', placement: '@', animation: '&', isOpen: '&' },
    templateUrl: 'template/popover/popover.html'
  };
})
.directive( 'popover', [ '$compile', '$timeout', '$parse', '$window', '$tooltip', function ( $compile, $timeout, $parse, $window, $tooltip ) {
  return $tooltip( 'popover', 'popover', 'click' );
}]);


angular.module('ui.bootstrap.progressbar', ['ui.bootstrap.transition'])

.constant('progressConfig', {
  animate: true,
  autoType: false,
  stackedTypes: ['success', 'info', 'warning', 'danger']
})

.controller('ProgressBarController', ['$scope', '$attrs', 'progressConfig', function($scope, $attrs, progressConfig) {

    // Whether bar transitions should be animated
    var animate = angular.isDefined($attrs.animate) ? $scope.$eval($attrs.animate) : progressConfig.animate;
    var autoType = angular.isDefined($attrs.autoType) ? $scope.$eval($attrs.autoType) : progressConfig.autoType;
    var stackedTypes = angular.isDefined($attrs.stackedTypes) ? $scope.$eval('[' + $attrs.stackedTypes + ']') : progressConfig.stackedTypes;

    // Create bar object
    this.makeBar = function(newBar, oldBar, index) {
        var newValue = (angular.isObject(newBar)) ? newBar.value : (newBar || 0);
        var oldValue =  (angular.isObject(oldBar)) ? oldBar.value : (oldBar || 0);
        var type = (angular.isObject(newBar) && angular.isDefined(newBar.type)) ? newBar.type : (autoType) ? getStackedType(index || 0) : null;

        return {
            from: oldValue,
            to: newValue,
            type: type,
            animate: animate
        };
    };

    function getStackedType(index) {
        return stackedTypes[index];
    }

    this.addBar = function(bar) {
        $scope.bars.push(bar);
        $scope.totalPercent += bar.to;
    };

    this.clearBars = function() {
        $scope.bars = [];
        $scope.totalPercent = 0;
    };
    this.clearBars();
}])

.directive('progress', function() {
    return {
        restrict: 'EA',
        replace: true,
        controller: 'ProgressBarController',
        scope: {
            value: '=',
            onFull: '&',
            onEmpty: '&'
        },
        templateUrl: 'template/progressbar/progress.html',
        link: function(scope, element, attrs, controller) {
            scope.$watch('value', function(newValue, oldValue) {
                controller.clearBars();

                if (angular.isArray(newValue)) {
                    // Stacked progress bar
                    for (var i=0, n=newValue.length; i < n; i++) {
                        controller.addBar(controller.makeBar(newValue[i], oldValue[i], i));
                    }
                } else {
                    // Simple bar
                    controller.addBar(controller.makeBar(newValue, oldValue));
                }
            }, true);

            // Total percent listeners
            scope.$watch('totalPercent', function(value) {
              if (value >= 100) {
                scope.onFull();
              } else if (value <= 0) {
                scope.onEmpty();
              }
            }, true);
        }
    };
})

.directive('progressbar', ['$transition', function($transition) {
    return {
        restrict: 'EA',
        replace: true,
        scope: {
            width: '=',
            old: '=',
            type: '=',
            animate: '='
        },
        templateUrl: 'template/progressbar/bar.html',
        link: function(scope, element) {
            scope.$watch('width', function(value) {
                if (scope.animate) {
                    element.css('width', scope.old + '%');
                    $transition(element, {width: value + '%'});
                } else {
                    element.css('width', value + '%');
                }
            });
        }
    };
}]);
angular.module('ui.bootstrap.rating', [])

.constant('ratingConfig', {
  max: 5
})

.directive('rating', ['ratingConfig', '$parse', function(ratingConfig, $parse) {
  return {
    restrict: 'EA',
    scope: {
      value: '='
    },
    templateUrl: 'template/rating/rating.html',
    replace: true,
    link: function(scope, element, attrs) {

      var maxRange = angular.isDefined(attrs.max) ? scope.$eval(attrs.max) : ratingConfig.max;

      scope.range = [];
      for (var i = 1; i <= maxRange; i++) {
          scope.range.push(i);
      }

      scope.rate = function(value) {
          if ( ! scope.readonly ) {
              scope.value = value;
          }
      };

      scope.enter = function(value) {
          if ( ! scope.readonly ) {
              scope.val = value;
          }
      };

      scope.reset = function() {
          scope.val = angular.copy(scope.value);
      };
      scope.reset();

      scope.$watch('value', function(value) {
          scope.val = value;
      });

      scope.readonly = false;
      if (attrs.readonly) {
          scope.$parent.$watch($parse(attrs.readonly), function(value) {
              scope.readonly = !!value;
          });
      }
    }
  };
}]);
angular.module('ui.bootstrap.tabs', [])
.controller('TabsController', ['$scope', '$element', function($scope, $element) {
  var panes = $scope.panes = [];

  this.select = $scope.select = function selectPane(pane) {
    angular.forEach(panes, function(pane) {
      pane.selected = false;
    });
    pane.selected = true;
  };

  this.addPane = function addPane(pane) {
    if (!panes.length) {
      $scope.select(pane);
    }
    panes.push(pane);
  };

  this.removePane = function removePane(pane) { 
    var index = panes.indexOf(pane);
    panes.splice(index, 1);
    //Select a new pane if removed pane was selected 
    if (pane.selected && panes.length > 0) {
      $scope.select(panes[index < panes.length ? index : index-1]);
    }
  };
}])
.directive('tabs', function() {
  return {
    restrict: 'EA',
    transclude: true,
    scope: {},
    controller: 'TabsController',
    templateUrl: 'template/tabs/tabs.html',
    replace: true
  };
})
.directive('pane', ['$parse', function($parse) {
  return {
    require: '^tabs',
    restrict: 'EA',
    transclude: true,
    scope:{
      heading:'@'
    },
    link: function(scope, element, attrs, tabsCtrl) {
      var getSelected, setSelected;
      scope.selected = false;
      if (attrs.active) {
        getSelected = $parse(attrs.active);
        setSelected = getSelected.assign;
        scope.$watch(
          function watchSelected() {return getSelected(scope.$parent);},
          function updateSelected(value) {scope.selected = value;}
        );
        scope.selected = getSelected ? getSelected(scope.$parent) : false;
      }
      scope.$watch('selected', function(selected) {
        if(selected) {
          tabsCtrl.select(scope);
        }
        if(setSelected) {
          setSelected(scope.$parent, selected);
        }
      });

      tabsCtrl.addPane(scope);
      scope.$on('$destroy', function() {
        tabsCtrl.removePane(scope);
      });
    },
    templateUrl: 'template/tabs/pane.html',
    replace: true
  };
}]);

angular.module('ui.bootstrap.typeahead', ['ui.bootstrap.position'])

/**
 * A helper service that can parse typeahead's syntax (string provided by users)
 * Extracted to a separate service for ease of unit testing
 */
  .factory('typeaheadParser', ['$parse', function ($parse) {

  //                      00000111000000000000022200000000000000003333333333333330000000000044000
  var TYPEAHEAD_REGEXP = /^\s*(.*?)(?:\s+as\s+(.*?))?\s+for\s+(?:([\$\w][\$\w\d]*))\s+in\s+(.*)$/;

  return {
    parse:function (input) {

      var match = input.match(TYPEAHEAD_REGEXP), modelMapper, viewMapper, source;
      if (!match) {
        throw new Error(
          "Expected typeahead specification in form of '_modelValue_ (as _label_)? for _item_ in _collection_'" +
            " but got '" + input + "'.");
      }

      return {
        itemName:match[3],
        source:$parse(match[4]),
        viewMapper:$parse(match[2] || match[1]),
        modelMapper:$parse(match[1])
      };
    }
  };
}])

  .directive('typeahead', ['$compile', '$parse', '$q', '$document', '$position', 'typeaheadParser', function ($compile, $parse, $q, $document, $position, typeaheadParser) {

  var HOT_KEYS = [9, 13, 27, 38, 40];

  return {
    require:'ngModel',
    link:function (originalScope, element, attrs, modelCtrl) {

      var selected;

      //minimal no of characters that needs to be entered before typeahead kicks-in
      var minSearch = originalScope.$eval(attrs.typeaheadMinLength) || 1;

      //expressions used by typeahead
      var parserResult = typeaheadParser.parse(attrs.typeahead);

      //should it restrict model values to the ones selected from the popup only?
      var isEditable = originalScope.$eval(attrs.typeaheadEditable) !== false;

      var isLoadingSetter = $parse(attrs.typeaheadLoading).assign || angular.noop;

      //pop-up element used to display matches
      var popUpEl = angular.element(
        "<typeahead-popup " +
          "matches='matches' " +
          "active='activeIdx' " +
          "select='select(activeIdx)' "+
          "query='query' "+
          "position='position'>"+
        "</typeahead-popup>");

      //create a child scope for the typeahead directive so we are not polluting original scope
      //with typeahead-specific data (matches, query etc.)
      var scope = originalScope.$new();
      originalScope.$on('$destroy', function(){
        scope.$destroy();
      });

      var resetMatches = function() {
        scope.matches = [];
        scope.activeIdx = -1;
      };

      var getMatchesAsync = function(inputValue) {

        var locals = {$viewValue: inputValue};
        isLoadingSetter(originalScope, true);
        $q.when(parserResult.source(scope, locals)).then(function(matches) {

          //it might happen that several async queries were in progress if a user were typing fast
          //but we are interested only in responses that correspond to the current view value
          if (inputValue === modelCtrl.$viewValue) {
            if (matches.length > 0) {

              scope.activeIdx = 0;
              scope.matches.length = 0;

              //transform labels
              for(var i=0; i<matches.length; i++) {
                locals[parserResult.itemName] = matches[i];
                scope.matches.push({
                  label: parserResult.viewMapper(scope, locals),
                  model: matches[i]
                });
              }

              scope.query = inputValue;
              //position pop-up with matches - we need to re-calculate its position each time we are opening a window
              //with matches as a pop-up might be absolute-positioned and position of an input might have changed on a page
              //due to other elements being rendered
              scope.position = $position.position(element);
              scope.position.top = scope.position.top + element.prop('offsetHeight');

            } else {
              resetMatches();
            }
            isLoadingSetter(originalScope, false);
          }
        }, function(){
          resetMatches();
          isLoadingSetter(originalScope, false);
        });
      };

      resetMatches();

      //we need to propagate user's query so we can higlight matches
      scope.query = undefined;

      //plug into $parsers pipeline to open a typeahead on view changes initiated from DOM
      //$parsers kick-in on all the changes coming from the view as well as manually triggered by $setViewValue
      modelCtrl.$parsers.push(function (inputValue) {

        resetMatches();
        if (selected) {
          return inputValue;
        } else {
          if (inputValue && inputValue.length >= minSearch) {
            getMatchesAsync(inputValue);
          }
        }

        return isEditable ? inputValue : undefined;
      });

      modelCtrl.$render = function () {
        var locals = {};
        locals[parserResult.itemName] = selected || modelCtrl.$viewValue;
        element.val(parserResult.viewMapper(scope, locals) || modelCtrl.$viewValue);
        selected = undefined;
      };

      scope.select = function (activeIdx) {
        //called from within the $digest() cycle
        var locals = {};
        locals[parserResult.itemName] = selected = scope.matches[activeIdx].model;

        modelCtrl.$setViewValue(parserResult.modelMapper(scope, locals));
        modelCtrl.$render();
      };

      //bind keyboard events: arrows up(38) / down(40), enter(13) and tab(9), esc(27)
      element.bind('keydown', function (evt) {

        //typeahead is open and an "interesting" key was pressed
        if (scope.matches.length === 0 || HOT_KEYS.indexOf(evt.which) === -1) {
          return;
        }

        evt.preventDefault();

        if (evt.which === 40) {
          scope.activeIdx = (scope.activeIdx + 1) % scope.matches.length;
          scope.$digest();

        } else if (evt.which === 38) {
          scope.activeIdx = (scope.activeIdx ? scope.activeIdx : scope.matches.length) - 1;
          scope.$digest();

        } else if (evt.which === 13 || evt.which === 9) {
          scope.$apply(function () {
            scope.select(scope.activeIdx);
          });

        } else if (evt.which === 27) {
          evt.stopPropagation();

          resetMatches();
          scope.$digest();
        }
      });

      $document.bind('click', function(){
        resetMatches();
        scope.$digest();
      });

      element.after($compile(popUpEl)(scope));
    }
  };

}])

  .directive('typeaheadPopup', function () {
    return {
      restrict:'E',
      scope:{
        matches:'=',
        query:'=',
        active:'=',
        position:'=',
        select:'&'
      },
      replace:true,
      templateUrl:'template/typeahead/typeahead.html',
      link:function (scope, element, attrs) {

        scope.isOpen = function () {
          return scope.matches.length > 0;
        };

        scope.isActive = function (matchIdx) {
          return scope.active == matchIdx;
        };

        scope.selectActive = function (matchIdx) {
          scope.active = matchIdx;
        };

        scope.selectMatch = function (activeIdx) {
          scope.select({activeIdx:activeIdx});
        };
      }
    };
  })

  .filter('typeaheadHighlight', function() {

    function escapeRegexp(queryToEscape) {
      return queryToEscape.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1");
    }

    return function(matchItem, query) {
      return query ? matchItem.replace(new RegExp(escapeRegexp(query), 'gi'), '<strong>$&</strong>') : query;
    };
  });
/*
 * RoyalSlider
 *
 * @version 9.4.8:
 *
 * Copyright 2011-2012, Dmitry Semenov
 *
 */

(function($) {
	if(!$.rsModules) {
		$.rsModules = {uid:0};
	}


	function RoyalSlider(element, options) {
		var i,
			self = this,
			ua = navigator.userAgent.toLowerCase();

		self.uid = $.rsModules.uid++;
		self.ns = '.rs' + self.uid; // unique namespace for events

		// feature detection, some ideas taken from Modernizr
		var tempStyle = document.createElement('div').style,
			vendors = ['webkit','Moz','ms','O'],
			vendor = '',
			lastTime = 0,
			tempV;

		for (i = 0; i < vendors.length; i++ ) {
			tempV = vendors[i];
			if (!vendor && (tempV + 'Transform') in tempStyle ) {
				vendor = tempV;
			}
			tempV = tempV.toLowerCase();
			
			if(!window.requestAnimationFrame) {
				window.requestAnimationFrame = window[tempV+'RequestAnimationFrame'];
       			window.cancelAnimationFrame = window[tempV+'CancelAnimationFrame'] 
                                   || window[tempV+'CancelRequestAnimationFrame'];
			}
		}

 		// requestAnimationFrame polyfill by Erik Möller
		// fixes from Paul Irish and Tino Zijdel
	    if (!window.requestAnimationFrame) {
	        window.requestAnimationFrame = function(callback, element) {
	            var currTime = new Date().getTime(),
	            	timeToCall = Math.max(0, 16 - (currTime - lastTime)),
	            	id = window.setTimeout(function() { callback(currTime + timeToCall); }, timeToCall);
	            lastTime = currTime + timeToCall;
	            return id;
	        };
	    }
	    if (!window.cancelAnimationFrame) 
	    	window.cancelAnimationFrame = function(id) { clearTimeout(id); };

	    self.isIPAD = ua.match(/(ipad)/);


	    // browser UA sniffing, sadly still required
	    var uaMatch = function( ua ) {
		    var match = /(chrome)[ \/]([\w.]+)/.exec( ua ) ||
		        /(webkit)[ \/]([\w.]+)/.exec( ua ) ||
		        /(opera)(?:.*version|)[ \/]([\w.]+)/.exec( ua ) ||
		        /(msie) ([\w.]+)/.exec( ua ) ||
		        ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec( ua ) ||
		        [];

		    return {
		        browser: match[ 1 ] || "",
		        version: match[ 2 ] || "0"
		    };
		};
		var matched = uaMatch( ua );
		var br = {};
		if ( matched.browser ) {
		    br[ matched.browser ] = true;
		    br.version = matched.version;
		}
		if(br.chrome) { br.webkit = true; };
		self._browser = br;
		self.isAndroid = ua.indexOf("android") > -1;



	    self.slider = $(element); // DOM reference
		self.ev = $(self); // event object
		self._doc = $(document);
		self.st = $.extend({}, $.fn.royalSlider.defaults, options); 
		self._currAnimSpeed = self.st.transitionSpeed;
 		self._minPosOffset = 0;
		if(self.st.allowCSS3) {
			if((!br.webkit || self.st.allowCSS3OnWebkit) ) {
		    	var bT = vendor + (vendor ? 'T' : 't' );
		    	self._useCSS3Transitions = ( (bT + 'ransform') in tempStyle ) && ( (bT + 'ransition') in tempStyle );
			    if(self._useCSS3Transitions) {
			    	self._use3dTransform = (vendor + (vendor ? 'P' : 'p'  ) + 'erspective') in tempStyle;
			    }
		    }
		}
	    
	    vendor = vendor.toLowerCase();
	    self._vendorPref = '-'+vendor+'-';
		
		self._slidesHorizontal = (self.st.slidesOrientation === 'vertical') ? false : true;
		self._reorderProp = self._slidesHorizontal ? 'left' : 'top';
		self._sizeProp = self._slidesHorizontal ? 'width' : 'height';
		self._prevNavItemId = -1;
		self._isMove = (self.st.transitionType === 'fade') ? false : true;
		if(!self._isMove) {
			self.st.sliderDrag = false;
			self._fadeZIndex = 10;
		}
		self._opacityCSS = 'z-index:0; display:none; opacity:0;';

		self._newSlideId = 0;
		self._sPosition = 0;
		self._nextSlidePos = 0;

		// init modules
		$.each($.rsModules, function (helper, opts) {
			if(helper !== 'uid')
				opts.call(self);
		});

		// parse all slides
		self.slides = [];
		self._idCount = 0;
		var returnVal;
		var ts = self.st.slides ? $(self.st.slides) : self.slider.children().detach();
		
		ts.each(function() {
			self._parseNode(this, true);
		});

		if(self.st.randomizeSlides) {
	    	self.slides.sort(function() { return 0.5 - Math.random() });
	    }
		self.numSlides = self.slides.length;
		self._refreshNumPreloadImages();

		if(!self.st.startSlideId) {
			self.st.startSlideId = 0;
		} else if(self.st.startSlideId > self.numSlides - 1) {
			self.st.startSlideId = self.numSlides - 1;
		}

		self._newSlideId = self.staticSlideId = self.currSlideId = self._realId =  self.st.startSlideId;
		self.currSlide = self.slides[self.currSlideId];

		self._accelerationPos = 0;
		self.msTouch = false;
		self.slider.addClass( (self._slidesHorizontal ? 'rsHor' : 'rsVer') + (self._isMove ? '' : ' rsFade') );

		var sliderHTML = '<div class="rsOverflow"><div class="rsContainer">';
		self.slidesSpacing = self.st.slidesSpacing;
		self._slideSize = ( self._slidesHorizontal ? self.slider.width() : self.slider.height() ) + self.st.slidesSpacing;

		self._preload = Boolean(self._numPreloadImages > 0);
		
		if(self.numSlides <= 1) {
			self._loop = false;
		}
		var loopHelpers = (self._loop && self._isMove) ? ( self.numSlides === 2 ? 1 : 2) : 0;
		self._loopHelpers = loopHelpers;

		self._maxImages = self.numSlides < 6 ? self.numSlides : 6;
		self._currBlockIndex = 0;


		self._idOffset = 0;
		self.slidesJQ = [];
		
		for(i =0; i < self.numSlides; i++) {
			self.slidesJQ.push( $(createItemHTML(i)) );
		}
		self._sliderOverflow = sliderHTML = $(sliderHTML + '</div></div>');


		var addCursors = function() {
			if(self.st.sliderDrag) {
				self._hasDrag = true;
				if (br.msie || br.opera) {
					self._grabCursor = self._grabbingCursor = "move";
				} else if(br.mozilla) {
					self._grabCursor = "-moz-grab";
					self._grabbingCursor = "-moz-grabbing";
				} else if(br.webkit && (navigator.platform.indexOf("Mac")!=-1)) {
					self._grabCursor = "-webkit-grab";
					self._grabbingCursor = "-webkit-grabbing";
				}
				self._setGrabCursor();
			}
		};
		var rsNS = self.ns;
		var addEventNames = function(pref, down, move, up, cancel) {
			self._downEvent = pref + down + rsNS;
			self._moveEvent = pref + move + rsNS;
			self._upEvent = pref + up + rsNS;
			if(cancel)
				self._cancelEvent = pref + cancel + rsNS;
		};


		// ie10
		self.msEnabled = window.navigator.msPointerEnabled;

		if(self.msEnabled) {
			self.msTouch = Boolean(window.navigator.msMaxTouchPoints > 1);
			self.hasTouch = false;
			self._lastItemFriction = 0.2;
			
			addEventNames('MSPointer', 'Down', 'Move', 'Up', 'Cancel');
		} else {
			addEventNames('mouse', 'down', 'move', 'up', 'up');

			if('ontouchstart' in window || 'createTouch' in document) {
				self.hasTouch = true;
				self._downEvent += ' touchstart' + rsNS;
				self._moveEvent += ' touchmove' + rsNS;
				self._upEvent += ' touchend' + rsNS;
				self._cancelEvent += ' touchcancel' + rsNS;
				self._lastItemFriction = 0.5;
				if(self.st.sliderTouch) {
					self._hasDrag = true;
				}
			} else {
				self.hasTouch = false;
				self._lastItemFriction = 0.2;
			}
		}
		addCursors();
	
		self.slider.html(sliderHTML);

		
		self._controlsContainer = self.st.controlsInside ? self._sliderOverflow : self.slider;
		
		self._slidesContainer = self._sliderOverflow.children('.rsContainer');
		if(self.msEnabled) {
			self._slidesContainer.css('-ms-touch-action', self._slidesHorizontal ? 'pan-y' : 'pan-x');
		}
		self._preloader = $('<div class="rsPreloader"></div>');
		var slides = self._slidesContainer.children('.rsSlide');

		self._currHolder = self.slidesJQ[self.currSlideId]
		self._selectedSlideHolder = 0;

		function createItemHTML(i, className) {
			return '<div style="'+ (self._isMove ? '' : (i !== self.currSlideId  ? self._opacityCSS : 'z-index:0;') ) +'" class="rsSlide '+ (className || '')+'"></div>';
		}
		
		if(self._useCSS3Transitions) {

			// some constants for CSS3
			self._TP = 'transition-property';
			self._TD = 'transition-duration';
			self._TTF = 'transition-timing-function';

			self._yProp = self._xProp = self._vendorPref +'transform';

			if(self._use3dTransform) {
				if(br.webkit && !br.chrome) {
					self.slider.addClass('rsWebkit3d');
				}

				self._tPref1 = 'translate3d(';
				self._tPref2 = 'px, ';
				self._tPref3 = 'px, 0px)';
			} else {
				self._tPref1 = 'translate(';
				self._tPref2 = 'px, ';
				self._tPref3 = 'px)';
			}
			if(!self._isMove) {
				var animObj = {};
				animObj[(self._vendorPref + self._TP)] = 'opacity';
				animObj[(self._vendorPref + self._TD)] = self.st.transitionSpeed + 'ms';
				animObj[(self._vendorPref + self._TTF)] = self.st.css3easeInOut;
				slides.css(animObj);
			} else {
				self._slidesContainer[(self._vendorPref + self._TP)] = (self._vendorPref + 'transform');
			}
			

		} else {
			self._xProp = 'left';
			self._yProp = 'top';
		}

		

		// window resize
		var resizeTimer;
		$(window).on('resize'+self.ns, function() {	
			if(resizeTimer) {
				clearTimeout(resizeTimer);			
			}
			resizeTimer = setTimeout(function() { self.updateSliderSize(); }, 50);			
		});	
		self.ev.trigger('rsAfterPropsSetup'); // navigation (bullets, thumbs...) are created here

		self.updateSliderSize();


		// keyboard nav
		if(self.st.keyboardNavEnabled) {
			self._bindKeyboardNav();
		}

		if(self.st.arrowsNavHideOnTouch && (self.hasTouch || self.msTouch) ) {
			self.st.arrowsNav = false;
		}

		//Direction navigation (arrows)
		if(self.st.arrowsNav) {
			var rArr = 'rsArrow',
				container = self._controlsContainer;
			$('<div class="'+rArr+' '+rArr+'Left"><div class="'+rArr+'Icn"></div></div><div class="'+rArr+' '+rArr+'Right"><div class="'+rArr+'Icn"></div></div>').appendTo(container);

			self._arrowLeft = container.children('.'+rArr+'Left').click(function(e) {
				e.preventDefault();
				self.prev();
			});
			self._arrowRight = container.children('.'+rArr+'Right').click(function(e) {
				e.preventDefault();
				self.next();
			});

			if(self.st.arrowsNavAutoHide && !self.hasTouch) {
				self._arrowLeft.addClass('rsHidden');
				self._arrowRight.addClass('rsHidden');

				var hoverEl = container;
				hoverEl.one("mousemove.arrowshover",function() {
					self._arrowLeft.removeClass('rsHidden');
					self._arrowRight.removeClass('rsHidden');			
				});


				hoverEl.hover(
					function() {
						if(!self._arrowsAutoHideLocked) {
							self._arrowLeft.removeClass('rsHidden');
							self._arrowRight.removeClass('rsHidden');
						}
					},
					function() {
						if(!self._arrowsAutoHideLocked) {
							self._arrowLeft.addClass('rsHidden');
							self._arrowRight.addClass('rsHidden');
						}
					}
				);	
			}	
			self.ev.on('rsOnUpdateNav', function() {
				self._updateArrowsNav();
			});
			self._updateArrowsNav();
		}

			
		
		if( self._hasDrag ) {
			self._slidesContainer.on(self._downEvent, function(e) { self._onDragStart(e); });	
		} else {
			self.dragSuccess = false;
		}
		var videoClasses = ['rsPlayBtnIcon', 'rsPlayBtn', 'rsCloseVideoBtn', 'rsCloseVideoIcn'];
		self._slidesContainer.click(function(e) {
			if(!self.dragSuccess) {
				var t = $(e.target);
				var tClass = t.attr('class');
				if( $.inArray(tClass, videoClasses) !== -1) {
			        if( self.toggleVideo() ) {
						return false;
					}
			    }
				if(self.st.navigateByClick && !self._blockActions) {
					if($(e.target).closest('.rsNoDrag', self._currHolder).length) {
						 return true;
					}
					self._mouseNext(e);
				} 
				self.ev.trigger('rsSlideClick');
			} 
		}).on('click.rs', 'a', function(e) {	
			if(self.dragSuccess) {						
				return false;
			} else {
				self._blockActions = true;
				//e.stopPropagation();
				//e.stopImmediatePropagation();
				setTimeout(function() {
					self._blockActions = false;
				}, 3);
			}
		});
		self.ev.trigger('rsAfterInit');
	} /* RoyalSlider Constructor End */

	/**
	 *
	 * RoyalSlider Core Prototype
	 * 
	 */
	RoyalSlider.prototype = {
		constructor: RoyalSlider,
		_mouseNext: function(e) {
			var self = this,
				relativePos = e[self._slidesHorizontal ? 'pageX' : 'pageY'] - self._sliderOffset;

		  	if(relativePos >= self._nextSlidePos) {
		  		self.next();
		  	} else if(relativePos < 0) {
		  		self.prev();
		  	}
		},
		_refreshNumPreloadImages: function() {
			var self = this,
				n;
			n = self.st.numImagesToPreload;
			self._loop = self.st.loop;

			if(self._loop) {
				if(self.numSlides === 2) {
					self._loop = false;
					self.st.loopRewind = true;
				} else if(self.numSlides < 2) {
					self.st.loopRewind = self._loop = false;
				}
				
			}
			if(self._loop && n > 0) {
				if(self.numSlides <= 4) {
					n = 1;
				} else {
					if(self.st.numImagesToPreload > (self.numSlides - 1) / 2 ) {
						n = Math.floor( (self.numSlides - 1) / 2 );
					}
				} 
			}
			self._numPreloadImages = n;
		},
		_parseNode: function(content, pushToSlides) {
			var self = this,
				hasImg,
				isRoot,
				hasCover,
				obj = {},
				tempEl,
				first = true;
			content = $(content);
			self._currContent = content;
			self.ev.trigger('rsBeforeParseNode', [content, obj]);
			if(obj.stopParsing) {
				return;
			}
			content = self._currContent;
			obj.id = self._idCount;
			obj.contentAdded = false;
			self._idCount++;
			obj.images = [];
			obj.isBig = false;

			if(!obj.hasCover) {
				if(content.hasClass('rsImg')) {
					tempEl = content;
					hasImg = true;
				} else {
					tempEl = content.find('.rsImg');
					if(tempEl.length) {
						hasImg = true;
					}
				}

				if(hasImg) {
					obj.bigImage = tempEl.eq(0).attr('data-rsBigImg');
					tempEl.each(function() {
						var item = $(this);
						if(item.is('a')) {
							parseEl(item, 'href');
						} else if(item.is('img')) {
							parseEl(item, 'src');
						} else {
							parseEl(item);
						}
					});
				} else if(content.is('img')) {
					content.addClass('rsImg rsMainSlideImage');
					parseEl(content, 'src');
				}
			}
			tempEl = content.find('.rsCaption');
			if(tempEl.length) {
				obj.caption = tempEl.remove();
			}
			obj.content = content;

			self.ev.trigger('rsAfterParseNode', [content, obj]);
			function parseEl(el, s) {
				if(s) {
					obj.images.push( el.attr(s) );
				} else {
					obj.images.push( el.text() );
				}
				if(first) {
					first = false;
					obj.caption = (s === 'src') ? el.attr('alt') : el.contents();
					obj.image = obj.images[0];
					obj.videoURL = el.attr('data-rsVideo');
					
					
					var wAtt = el.attr('data-rsw'),
						hAtt = el.attr('data-rsh');
					if (typeof wAtt !== 'undefined' && wAtt !== false && typeof hAtt !== 'undefined' && hAtt !== false ) {
						   obj.iW = parseInt(wAtt);
						   obj.iH = parseInt(hAtt);
					} else if(self.st.imgWidth && self.st.imgHeight ) {
						obj.iW = self.st.imgWidth;
						obj.iH = self.st.imgHeight;
					}
				}
			}
			if(pushToSlides) {
				self.slides.push(obj);
			}
			if(obj.images.length === 0) {
				obj.isLoaded = true;
				obj.isRendered = false;
				obj.isLoading = false;
				obj.images = null;
			}
			return obj;
		},
		_bindKeyboardNav: function() {
			var self = this,
				interval,
				keyCode,
				onKeyboardAction = function (keyCode) {
				    if (keyCode === 37) {
						self.prev();
					} else if (keyCode === 39) {
						self.next();
					}
				};

			self._doc.on('keydown' + self.ns, function(e) {
				if(!self._isDragging) {
					keyCode = e.keyCode;
					if(keyCode === 37 || keyCode === 39) {
						if(!interval) {
					        onKeyboardAction(keyCode);
					        interval = setInterval(function() {
					            onKeyboardAction(keyCode);
					        }, 700);
					    }
					}
				}
			}).on('keyup' + self.ns, function(e) {
				if(interval) {
					clearInterval(interval); 
			   	    interval = null;
				}
			});

			
			
		},




		goTo: function(id, notUserAction) {
			var self = this;
			if(id !== self.currSlideId) {
				self._moveTo(id,self.st.transitionSpeed, true, !notUserAction);
			}
		},
		destroy: function(remove) {
			var self = this;
			self.ev.trigger('rsBeforeDestroy');
			self._doc.off('keydown' +self.ns+ ' keyup' + self.ns + ' ' + self._moveEvent +' '+ self._upEvent );
			self._slidesContainer.off(self._downEvent + ' click');	
			self.slider.data('royalSlider', null);
			$.removeData(self.slider, 'royalSlider');
			$(window).off('resize' + self.ns);
			if(remove) {
				self.slider.remove();
			}
			self.slides = null;
			self.slider = null;
			self.ev = null;
		},
		_updateBlocksContent: function(beforeTransition, getId) {
			var self = this,
				item,
				i,
				n,
				pref,
				group,
				groupId,
				slideCode,
				loop = self._loop,
				numSlides = self.numSlides;
			if(!isNaN(getId) ) {
				return getCorrectLoopedId(getId);
			}


			var id = self.currSlideId;
			var groupOffset;
			
			var itemsOnSide = beforeTransition ? (Math.abs(self._prevSlideId - self.currSlideId) >= self.numSlides - 1 ? 0 : 1) : self._numPreloadImages;
			var itemsToCheck = Math.min(2, itemsOnSide); 
			
			var updateAfter = false;
			var updateBefore = false;
			var tempId;


			
			for(i = id; i < id + 1 + itemsToCheck; i++) {
				tempId = getCorrectLoopedId(i);
				item = self.slides[tempId];
				if(item && (!item.isAdded || !item.positionSet) ) {
					updateAfter = true;
					break;
				}
			}
			for(i = id - 1; i > id - 1 - itemsToCheck; i--) {
				tempId = getCorrectLoopedId(i);
				item = self.slides[tempId];
				if(item && (!item.isAdded || !item.positionSet) ) {
					updateBefore = true;
					break;
				}
			}
			if(updateAfter) {
				for(i = id; i < id + itemsOnSide + 1; i++) {
					tempId = getCorrectLoopedId(i);
					groupOffset = Math.floor( (self._realId - (id - i)) / self.numSlides) * self.numSlides;
					item = self.slides[tempId];
					if(item) {
						updateItem(item, tempId);	
					}
				}
			}
			if(updateBefore) {
				for(i = id - 1; i > id - 1 - itemsOnSide; i--) {
					tempId = getCorrectLoopedId(i);
					groupOffset = Math.floor( (self._realId - (id - i) ) / numSlides) * numSlides;
					item = self.slides[tempId];
					if(item) {
						updateItem(item, tempId);
					}
				}
			}
			if(!beforeTransition) {
				var start = id;
				var distance = itemsOnSide;
				var min = getCorrectLoopedId(id - itemsOnSide);
				var max = getCorrectLoopedId(id + itemsOnSide);
				
				var nmin = min > max ? 0 : min;
				
				for (i = 0; i < numSlides; i++) { 
					if(min > max) {
						if(i > min - 1) {
							continue;
						}
					}
					if(i < nmin || i > max) {
						 item = self.slides[i];
						if(item && item.holder) {
							
							//slideCode = self.slidesJQ[i];
							//if(typeof slideCode !== "string") { 
								item.holder.detach();
								item.isAdded = false;
							//}
						}     
					}                               
			    }   
			}

			
			
				
				
			function updateItem(item , i, slideCode) {

				if(!item.isAdded) {
					if(!slideCode)
						slideCode = self.slidesJQ[i];

					if(!item.holder) {
						slideCode = self.slidesJQ[i] = $(slideCode);
						item.holder = slideCode;
					} else {
						slideCode = item.holder;
					}

					item.appendOnLoaded = false;

					
					updatePos(i, item, slideCode);
					addContent(i, item);
					self._addBlockToContainer(item, slideCode, beforeTransition);
					item.isAdded = true;
					appended = true;
				} else {
					addContent(i, item);
					updatePos(i, item);
				}
			}
			function addContent(i, item) {
				if(!item.contentAdded) {
					self.setItemHtml(item, beforeTransition);
					if(!beforeTransition) {
						item.contentAdded = true;
					}
					
				}
			}
			function updatePos(i, item, slideCode) {
				if(self._isMove) {
					if(!slideCode) {
						slideCode = self.slidesJQ[i];
					}

					slideCode.css(self._reorderProp, (i + self._idOffset + groupOffset) * self._slideSize);
				}
			}
			function getCorrectLoopedId(index) {
				var changed = false;
				if(loop) {
					if(index > numSlides - 1) {
						return getCorrectLoopedId(index - numSlides);
					} else  if(index < 0) {
						return getCorrectLoopedId(numSlides + index);
					}
				}
				return index;
			}
			
		},

		/**
		 * Sets or loads HTML for specified slide
		 * @param {Object} currSlideObject  holds data about curr slide (read about rsAfterParseNode for more info)
		 * @param {Boolean} beforeTransition determines if setItemHTML method is called before or after transition
		 */
		setItemHtml: function(currSlideObject, beforeTransition) {

			var self = this;

			if(currSlideObject.isLoaded) {
				appendContent();
				return;
			} else {
				if(beforeTransition) {
					waitForTransition();
				} else {
					parseDataAndLoad();
				}
			}

			function parseDataAndLoad() {
				if(!currSlideObject.images) {
					currSlideObject.isRendered = true;
				    currSlideObject.isLoaded = true;
					currSlideObject.isLoading = false;
					appendContent(true);
					return;
				}
				if(currSlideObject.isLoading) {
					return;
				}
				
				var el,
					isRoot;
				if(currSlideObject.content.hasClass('rsImg') ) {
					el = currSlideObject.content;
					isRoot = true;
				} else {
					el = currSlideObject.content.find('.rsImg:not(img)')
				}
				if(el && !el.is('img')) {
					el.each(function() {
						var item = $(this),
							newEl = '<img class="rsImg" src="'+ ( item.is('a') ? item.attr('href') : item.text() ) +'" />';

						if(!isRoot) {
							item.replaceWith( newEl );
						} else {
							currSlideObject.content = $(newEl);
						}
					});
				}
				
				el = isRoot ? currSlideObject.content : currSlideObject.content.find('img.rsImg');
				setPreloader();
				
				el.eq(0).addClass('rsMainSlideImage');
				if(currSlideObject.iW && currSlideObject.iH) {
					if(!currSlideObject.isLoaded) {
						self._resizeImage( currSlideObject );
					}
					appendContent();
				}

				currSlideObject.isLoading = true;
				var newEl;

				if(currSlideObject.isBig) {
					$('<img />').on('load.rs error.rs', function(e){
						onLoad( [this], true );
					}).attr('src', currSlideObject.image);
				} else {
					currSlideObject.loaded = [];
					currSlideObject.imgLoaders = [];
					for(var i = 0; i < currSlideObject.images.length; i++) {
						var image = $('<img />');

						currSlideObject.imgLoaders.push( this );
						image.on('load.rs error.rs', function(e){
							currSlideObject.loaded.push( this );
							if(currSlideObject.loaded.length === currSlideObject.imgLoaders.length) {
								onLoad( currSlideObject.loaded, false );
							}
						}).attr('src', currSlideObject.images[i]);
					}
				}

				// old images loading
				// el.imagesLoaded( function( $images, $proper, $broken ) {
				// 	if($broken.length) {
				// 		currSlideObject.isLoading = false;
				// 		var img =  $images[0],
				//     		src = img.src;
				// 		if(src && src.indexOf(currSlideObject.image) === -1 ) {
				//     		return;
				//     	}
				// 		if(!currSlideObject.tryAgainCount) { currSlideObject.tryAgainCount = 0; }
				// 		if(currSlideObject.tryAgainCount < 3) {
				// 			currSlideObject.tryAgainCount++;
				// 			self.setItemHtml(currSlideObject, beforeTransition);
				// 			return;
				// 		}
				// 	}
				//     onLoad($images);
				// });
			}
			function onLoad($images, isBig) {
				if($images.length) {
			    	var img = $images[0],
			    		src = img.src;
			    	
		    		if(isBig !== currSlideObject.isBig) {
		    			var c = currSlideObject.holder.children();
			    		if(c && c.length > 1) {
			    			removePreloader();
			    		}
			    		return;
		    		}
			    	
			    	if(currSlideObject.iW && currSlideObject.iH) {
			    		imageLoadingComplete();
			    		return;
			    	}
			    	currSlideObject.iW = img.width;
				    currSlideObject.iH = img.height;
				    if(currSlideObject.iW && currSlideObject.iH) {
			    		imageLoadingComplete();
			    		return;
			    	} else {
			    		// if no size, try again
			    		var loader = new Image();
			    		loader.onload = function() {
			    			if(loader.width) {
			    				currSlideObject.iW = loader.width;
				    			currSlideObject.iH = loader.height;
				    			imageLoadingComplete();
			    			} else {
			    				setTimeout(function() {
			    					if(loader.width) {
			    						currSlideObject.iW = loader.width;
				    					currSlideObject.iH = loader.height;
			    					}

			    					// failed to get size on last tier, just output image
			    					imageLoadingComplete();
			    				}, 1000);
			    			}
						};
					    loader.src = img.src;
			    	}
			    } else {
			    	imageLoadingComplete();
			    }
			}
			function imageLoadingComplete() {
				currSlideObject.isLoaded = true;
				currSlideObject.isLoading = false;

			    appendContent();
			    removePreloader();
			    triggerLoaded();
			}
			function waitForTransition() {
				if(!self._isMove && currSlideObject.images && currSlideObject.iW && currSlideObject.iH) {
					parseDataAndLoad();
					return;
				}
				currSlideObject.holder.isWaiting = true;
				setPreloader();
				currSlideObject.holder.slideId = -99;
			}
			
			function appendContent() {
				if(!currSlideObject.isAppended) {

					var visibleNearby = self.st.visibleNearby,
					bId = currSlideObject.id - self._newSlideId;
					if(!beforeTransition && !currSlideObject.appendOnLoaded && self.st.fadeinLoadedSlide  && ( bId === 0 || ( (visibleNearby || self._isAnimating || self._isDragging) && (bId === -1 || bId === 1) ) ) ) {
						var css = {
							visibility: 'visible', 
							opacity: 0
						};
						css[self._vendorPref + 'transition'] = 'opacity 400ms ease-in-out';
						currSlideObject.content.css(css);

						setTimeout(function() {
							currSlideObject.content.css('opacity', 1);
						}, 16);
					}

					if(currSlideObject.holder.find('.rsPreloader').length) {
						currSlideObject.holder.append( currSlideObject.content );
					} else {
						currSlideObject.holder.html( currSlideObject.content );
					}
					

					currSlideObject.isAppended = true;
					if(currSlideObject.isLoaded) {
						self._resizeImage(currSlideObject);
						triggerLoaded();
					}
					if(!currSlideObject.sizeReady) {
						currSlideObject.sizeReady = true;
						setTimeout(function() {
							// triggers after content is added, usually is true when page is refreshed from cache
							self.ev.trigger('rsMaybeSizeReady', currSlideObject);
						}, 100);
					}
					
				}
			}
			function triggerLoaded() {
				if(!currSlideObject.loadedTriggered) {
					currSlideObject.isLoaded = currSlideObject.loadedTriggered = true;
					currSlideObject.holder.trigger('rsAfterContentSet');
		 			self.ev.trigger('rsAfterContentSet', currSlideObject);
				}
			}
			function setPreloader() {
				if(self.st.usePreloader)
					currSlideObject.holder.html(self._preloader.clone());
			}
			function removePreloader(now) {
				if(self.st.usePreloader) {
					var preloader = currSlideObject.holder.find('.rsPreloader');
					if(preloader.length) {
						preloader.remove();
					}
				}
			}

		},
		_addBlockToContainer: function(slideObject, content, dontFade) {
			var self = this;
			var holder = slideObject.holder;
			var bId = slideObject.id - self._newSlideId;
			
			var visibleNearby = false;
			// if(self._isMove && !dontFade && self.st.fadeinLoadedSlide  && ( bId === 0 || ( (visibleNearby || self._isAnimating || self._isDragging) && (bId === -1 || bId === 1) ) ) ) {
			// 	var content = slideObject.content;
			// 	content.css(self._vendorPref + 'transition', 'opacity 400ms ease-in-out').css({visibility: 'visible', opacity: 0});
			// 	//holder.css('opacity', 0);
			// 	self._slidesContainer.append(holder);
			// 	setTimeout(function() {
			// 		content.css('opacity', 1);
			// 		//self.ev.trigger('rsAfterContentSet', holder);
			// 	}, 6);
			// } else {
				self._slidesContainer.append(holder);
			//}
			slideObject.appendOnLoaded = false;
		},
	
		_onDragStart:function(e, isThumbs) {
			var self = this,
				point,
				wasAnimating,
				isTouch = (e.type === 'touchstart');

			self._isTouchGesture = isTouch;	

			self.ev.trigger('rsDragStart');
			if($(e.target).closest('.rsNoDrag', self._currHolder).length) {
				 self.dragSuccess = false;
				 return true;
			}

			

			if(!isThumbs) {
				if(self._isAnimating) {
					self._wasAnimating = true;

					self._stopAnimation();
				}
			}
			self.dragSuccess = false;
			if(self._isDragging) {
				if(isTouch) {
					self._multipleTouches = true;
				}
				return;
			} else {
				if(isTouch) {
					self._multipleTouches = false;
				}
			}

			self._setGrabbingCursor();
			
			if(isTouch) {
				//parsing touch event
				var touches = e.originalEvent.touches;
				if(touches && touches.length > 0) {
					point = touches[0];
					if(touches.length > 1) {
						self._multipleTouches = true;
					}
				}					
				else {	
					return;						
				}
			} else {
				e.preventDefault();				
				point = e;
				if(self.msEnabled) point = point.originalEvent;		
			}

			self._isDragging = true;
			self._doc.on(self._moveEvent, function(e) { self._onDragMove(e, isThumbs); })
						.on(self._upEvent, function(e) { self._onDragRelease(e, isThumbs); });
			
			self._currMoveAxis = '';
			self._hasMoved = false;
			self._pageX = point.pageX;
			self._pageY = point.pageY;
			self._startPagePos = self._accelerationPos = (!isThumbs ? self._slidesHorizontal : self._thumbsHorizontal) ? point.pageX : point.pageY;
			
			self._horDir = 0;
			self._verDir = 0;


			self._currRenderPosition = !isThumbs ? self._sPosition : self._thumbsPosition;

			self._startTime = new Date().getTime();
			if(isTouch) {
				self._sliderOverflow.on(self._cancelEvent, function(e) { self._onDragRelease(e, isThumbs); });	
			}
		},
		_renderMovement:function(point, isThumbs) {
			var self = this;
			if(self._checkedAxis) {

				var timeStamp = self._renderMoveTime,
					deltaX = point.pageX - self._pageX,
					deltaY = point.pageY - self._pageY,
					newX = self._currRenderPosition + deltaX,
					newY = self._currRenderPosition + deltaY,
					isHorizontal = (!isThumbs ? self._slidesHorizontal : self._thumbsHorizontal),
					newPos = isHorizontal ? newX : newY,
					mAxis = self._currMoveAxis;

				self._hasMoved = true;
				self._pageX = point.pageX;
				self._pageY = point.pageY;

				if(mAxis === 'x' && deltaX !== 0) {
					self._horDir = deltaX > 0 ? 1 : -1;
				} else if(mAxis === 'y' && deltaY !== 0) {
					self._verDir = deltaY > 0 ? 1 : -1;
				}

				var pointPos = isHorizontal ? self._pageX : self._pageY,
					deltaPos = isHorizontal ? deltaX : deltaY;
				if(!isThumbs) {
					if(!self._loop) {
						if(self.currSlideId <= 0) {
							if(pointPos - self._startPagePos > 0) {
								newPos = self._currRenderPosition + deltaPos * self._lastItemFriction;
							}
						}
						if(self.currSlideId >= self.numSlides - 1) {
							if(pointPos - self._startPagePos < 0) {
								newPos = self._currRenderPosition + deltaPos * self._lastItemFriction ;
							}
						}
					}
				} else {
					if(newPos > self._thumbsMinPosition) {
						newPos = self._currRenderPosition + deltaPos * self._lastItemFriction;
					} else if(newPos < self._thumbsMaxPosition) {
						newPos = self._currRenderPosition + deltaPos * self._lastItemFriction ;
					}
				}

				self._currRenderPosition = newPos;
				
				if (timeStamp - self._startTime > 200) {
			 		self._startTime = timeStamp;
					self._accelerationPos = pointPos;						
				}

				if(!isThumbs) {
					if(self._isMove) {
						self._setPosition(self._currRenderPosition);
					}
				} else {
					self._setThumbsPosition(self._currRenderPosition);
				}
			}
			
		},
		_onDragMove:function(e, isThumbs) {
			var self = this,
				point,
				isTouch = (e.type === 'touchmove');

			if(self._isTouchGesture && !isTouch) {
				return;
			}

			if(isTouch) {
				if(self._lockAxis) {
					return;
				}	
				var touches = e.originalEvent.touches;
				if(touches) {
					if(touches.length > 1) {
						return;
					} else {
						point = touches[0];	
					}
				} else {
					return;
				}
			} else {
				point = e;
				if(self.msEnabled) point = point.originalEvent;	
			}
			

			if(!self._hasMoved) {
				if(self._useCSS3Transitions) {
					(!isThumbs ? self._slidesContainer : self._thumbsContainer).css((self._vendorPref + self._TD), '0s');
				}
				(function animloop(){
					if(self._isDragging) {
						self._animFrame = requestAnimationFrame(animloop);
						if(self._renderMoveEvent)
							self._renderMovement(self._renderMoveEvent, isThumbs);
					}
					
			    })();
			}
				
			if(!self._checkedAxis) {
				
				var dir = (!isThumbs ? self._slidesHorizontal : self._thumbsHorizontal),
					diff = (Math.abs(point.pageX - self._pageX) - Math.abs(point.pageY - self._pageY) ) - (dir ? -7 : 7);

				if(diff > 7) {
					// hor movement
					if(dir) {
						e.preventDefault();
						self._currMoveAxis = 'x';
					} else if(isTouch) {
						self._completeGesture();
						return;
					} 
					self._checkedAxis = true;
				} else if(diff < -7) {
					// ver movement
					if(!dir) {
						e.preventDefault();
						self._currMoveAxis = 'y';
					} else if(isTouch) {
						self._completeGesture();
						return;
					} 
					self._checkedAxis = true;
				}
				return;
			}
			
			e.preventDefault();	
			self._renderMoveTime = new Date().getTime();
			self._renderMoveEvent = point;
		},
		_completeGesture: function() {
			var self = this;
			self._lockAxis = true;
			self._hasMoved = self._isDragging = false;
			self._onDragRelease();
		},
		_onDragRelease:function(e, isThumbs) {
			var self = this,
				totalMoveDist,
				accDist,
				duration,
				v0,
				newPos,
				newDist,
				newDuration,
				blockLink,
				isTouch = (e.type === 'touchend' || e.type === 'touchcancel');


			if(self._isTouchGesture && !isTouch) {
				return;
			}
			self._isTouchGesture = false;
			self.ev.trigger('rsDragRelease');

			self._renderMoveEvent = null;
			self._isDragging = false;
			self._lockAxis = false;
			self._checkedAxis = false;
			self._renderMoveTime = 0;
			cancelAnimationFrame(self._animFrame);
			if(self._hasMoved) {
				if(!isThumbs) {
					if(self._isMove) {
						self._setPosition(self._currRenderPosition);
					}
				} else {
					self._setThumbsPosition(self._currRenderPosition);
				}
			}


			self._doc.off(self._moveEvent).off(self._upEvent);

			if(isTouch) {
				self._sliderOverflow.off(self._cancelEvent);	
			}

			
			self._setGrabCursor();
			if (!self._hasMoved && !self._multipleTouches) {
				if(isThumbs && self._thumbsEnabled) {
					var item = $(e.target).closest('.rsNavItem');
					if(item.length) {
						self.goTo(item.index());
					}	
					return;
				}
			}
			var orient = (!isThumbs ? self._slidesHorizontal : self._thumbsHorizontal);
			if(!self._hasMoved || (self._currMoveAxis === 'y' && orient) || (self._currMoveAxis === 'x' && !orient) ) {
				if(!isThumbs && self._wasAnimating) {
					self._wasAnimating = false;
					if(!self.st.navigateByClick) {
						self.dragSuccess = true;
					} else {
						self._mouseNext( (self.msEnabled ? e.originalEvent : e) );
						self.dragSuccess = true;
						return;
					}
				} else {
					self._wasAnimating = false;
					self.dragSuccess = false;
					return;
				}
				
			} else {
				self.dragSuccess = true;
			}

			self._wasAnimating = false;
			
			
			self._currMoveAxis = '';

			
			function getCorrectSpeed(newSpeed) {
				if(newSpeed < 100) {
					return 100;
				} else if(newSpeed > 500) {
					return 500;
				} 
				return newSpeed;
			}
			function returnToCurrent(isSlow, v0) {
				if(self._isMove || isThumbs) {

					newPos = (-self._realId - self._idOffset) * self._slideSize;
					newDist = Math.abs(self._sPosition  - newPos);
					self._currAnimSpeed = newDist / v0;
					if(isSlow) {
						self._currAnimSpeed += 250; 
					}
					self._currAnimSpeed = getCorrectSpeed(self._currAnimSpeed);

					self._animateTo(newPos, false);
				}
			}

			var snapDist = self.st.minSlideOffset,
				point = isTouch ? e.originalEvent.changedTouches[0] : (self.msEnabled ? e.originalEvent : e),
				pPos = orient ? point.pageX : point.pageY,
				sPos = self._startPagePos,
				axPos = self._accelerationPos,
				axCurrItem = self.currSlideId,
				axNumItems = self.numSlides,
				dir = orient ? self._horDir : self._verDir,
				loop = self._loop,
				changeHash = false,
				distOffset = 0;
			
			totalMoveDist = Math.abs(pPos - sPos);
			accDist = pPos - axPos;


			duration = (new Date().getTime()) - self._startTime;
			v0 = Math.abs(accDist) / duration;	

			if(dir === 0 || axNumItems <= 1) {
				returnToCurrent(true, v0);
				return;
			}

			if(!loop && !isThumbs) {
				if(axCurrItem <= 0) {
					if(dir > 0) {
						returnToCurrent(true, v0);
						return;
					}
				} else if(axCurrItem >= axNumItems - 1) {
					if(dir < 0) {
						returnToCurrent(true, v0);
						return;
					}
				}
			}

			if(!isThumbs) {
				if(sPos + snapDist < pPos) {
					if(dir < 0) {		
						returnToCurrent(false, v0);
						return;					
					}
					self._moveTo('prev', getCorrectSpeed(Math.abs(self._sPosition  - (-self._realId - self._idOffset + 1) * self._slideSize) / v0), changeHash, true, true);
				} else if(sPos - snapDist > pPos) {
					if(dir > 0) {		
						returnToCurrent(false, v0);
						return;					
					}
					self._moveTo('next', getCorrectSpeed(Math.abs(self._sPosition  - (-self._realId - self._idOffset - 1) * self._slideSize) / v0), changeHash, true, true);
				} else {
					returnToCurrent(false, v0);
				}
			} else {
				var newPos = self._thumbsPosition;
				var transitionSpeed;
				
				if(newPos > self._thumbsMinPosition) {
					newPos = self._thumbsMinPosition;
				} else if(newPos < self._thumbsMaxPosition) {
					newPos = self._thumbsMaxPosition;
				} else {
					var friction = 0.003,
						S = (v0 * v0) / (friction * 2),
						minXDist = -self._thumbsPosition,
						maxXDist = self._thumbsContainerSize - self._thumbsViewportSize + self._thumbsPosition;

					if (accDist > 0 && S > minXDist) {
						minXDist = minXDist + self._thumbsViewportSize / (15 / (S / v0 * friction));
						v0 = v0 * minXDist / S;
						S = minXDist;
					} else if (accDist < 0 && S > maxXDist) {
						maxXDist = maxXDist + self._thumbsViewportSize / (15 / (S / v0 * friction));
						v0 = v0 * maxXDist / S;
						S = maxXDist;
					}




					transitionSpeed =  Math.max(Math.round(v0 / friction), 50);
					newPos = newPos + S * (accDist < 0 ? -1 : 1);


					if(newPos > self._thumbsMinPosition) {
						self._animateThumbsTo(newPos, transitionSpeed, true, self._thumbsMinPosition, 200);
						return;
					 } else if(newPos < self._thumbsMaxPosition) {
						self._animateThumbsTo( newPos, transitionSpeed, true, self._thumbsMaxPosition, 200);
						return;
					}
				}

				self._animateThumbsTo(newPos, transitionSpeed, true);

			}
		},
		_setPosition: function(pos) {
			var self = this;
			pos = self._sPosition = pos;
			if(self._useCSS3Transitions) {
				self._slidesContainer.css(self._xProp, self._tPref1 + ( self._slidesHorizontal ? (pos + self._tPref2 + 0) : (0 + self._tPref2 + pos) ) + self._tPref3 );		
			} else {
				self._slidesContainer.css(self._slidesHorizontal ? self._xProp : self._yProp, pos);
			}
		},
		
		
		updateSliderSize: function(force) {
			var self = this,
				newWidth,
				newHeight;

			if(self.st.autoScaleSlider) {
				var asw = self.st.autoScaleSliderWidth,
					ash = self.st.autoScaleSliderHeight;

				if(self.st.autoScaleHeight) {
					newWidth = self.slider.width();
					if(newWidth != self.width) {
						self.slider.css("height", newWidth * (ash / asw) );
						newWidth = self.slider.width();
					}	
					newHeight = self.slider.height();
				} else {
					newHeight = self.slider.height();
					if(newHeight != self.height) {
						self.slider.css("width", newHeight * (asw / ash));
						newHeight = self.slider.height();
					}		
					newWidth = self.slider.width();
				}
			
			} else {
				newWidth = self.slider.width();
				newHeight = self.slider.height();
			}
			


			if(force || newWidth != self.width || newHeight != self.height) {
				self.width = newWidth;
				self.height = newHeight;

				self._wrapWidth = newWidth;
				self._wrapHeight = newHeight;

				self.ev.trigger('rsBeforeSizeSet');
				self.ev.trigger('rsAfterSizePropSet');

				self._sliderOverflow.css({
					width: self._wrapWidth,
					height: self._wrapHeight
				});


				self._slideSize = (self._slidesHorizontal ? self._wrapWidth : self._wrapHeight) + self.st.slidesSpacing;
				

				self._imagePadding = self.st.imageScalePadding;
				var item,
					slideItem,
					i,
					img;
				for(i = 0; i < self.slides.length; i++) {
					item = self.slides[i];
					item.positionSet = false;

					if(item && item.images && item.isLoaded) {
						item.isRendered = false;
						self._resizeImage(item);
					} 
				}
				if(self._cloneHolders) {
					for(i = 0; i < self._cloneHolders.length; i++) {
						item = self._cloneHolders[i];
						item.holder.css(self._reorderProp, (item.id + self._idOffset) * self._slideSize);
					}
				}
				
				self._updateBlocksContent();

				if(self._isMove) {
					if(self._useCSS3Transitions) {
						self._slidesContainer.css(self._vendorPref + 'transition-duration', '0s');
					}
					self._setPosition( (-self._realId - self._idOffset) * self._slideSize);
				}
				self.ev.trigger('rsOnUpdateNav');
			}
			self._sliderOffset = self._sliderOverflow.offset();
			self._sliderOffset = self._sliderOffset[self._reorderProp];


		},
		//setSlidesOrientation: function(orient) {
			// TODO
			// var self = this,
			// 	newHor = Boolean(orient === 'horizontal');
			// if(self._slidesHorizontal !== newHor) {
			// 	self._setPosition(0);
			// 	if(self._isMove) {
			// 		for(var i = 0; i < self._slideHolders.length; i++) {
			// 			self._slideHolders[i].block.css(self._reorderProp, '');
			// 		}
			// 	}
			// 	self.slider.removeClass(self._slidesHorizontal ? 'rsHor' : 'rsVer').addClass(newHor ? 'rsHor' : 'rsVer');
			// 	self._slidesHorizontal = newHor;
			// 	self._reorderProp = newHor ? 'left' : 'top';
			// 	self.updateSliderSize(true);
			// }
		//},
		/**
		 * Adds slide
		 * @param  {jQuery object or raw HTML} htmltext 
		 * @param  {int} index    (optional) Index where item should be added (last item is removed of not specified)
		 */
		appendSlide: function(htmltext, index) {
			var self = this,
				parsedSlide = self._parseNode(htmltext);

			if(isNaN(index) || index > self.numSlides) {
				index = self.numSlides;
			}
			self.slides.splice(index, 0, parsedSlide);
			self.slidesJQ.splice(index, 0, '<div style="'+ (self._isMove ? 'position:absolute;' : self._opacityCSS ) +'" class="rsSlide"></div>');

			if(index < self.currSlideId) {
				self.currSlideId++;
			}
			self.ev.trigger('rsOnAppendSlide', [parsedSlide, index]);
			
			self._refreshSlides(index);

			if(index === self.currSlideId) {
				self.ev.trigger('rsAfterSlideChange');
			}
		},

		/**
		 * Removes slide
		 * @param  {int} Index of item that should be removed
		 */
		removeSlide: function(index) {
			var self = this,
				slideToRemove = self.slides[index];

			if(slideToRemove) {
				if(slideToRemove.holder) {
					slideToRemove.holder.remove();
				}
				if(index < self.currSlideId) {
					self.currSlideId--;
				}
				self.slides.splice(index, 1);
				self.slidesJQ.splice(index, 1);

				self.ev.trigger('rsOnRemoveSlide', [index]);
				self._refreshSlides(index);

				if(index === self.currSlideId) {
					self.ev.trigger('rsAfterSlideChange');
				}
			}
		},
		_refreshSlides: function(refreshIndex) {

			// todo: optimize this stuff
			var self = this;

			var oldNumSlides = self.numSlides;
			var numLoops = self._realId <= 0 ? 0 : Math.floor(self._realId / oldNumSlides);

			self.numSlides = self.slides.length;
			if(self.numSlides === 0) {
				self.currSlideId = self._idOffset = self._realId = 0;
				self.currSlide = self._oldHolder = null;
			} else {
				self._realId = numLoops * self.numSlides + self.currSlideId;
			}

			for(var i = 0; i < self.numSlides; i++) {
				self.slides[i].id = i;
			}

			self.currSlide = self.slides[self.currSlideId];
			self._currHolder = self.slidesJQ[self.currSlideId];

			if(self.currSlideId >= self.numSlides) {
				self.goTo(self.numSlides - 1);
			} else if(self.currSlideId < 0) {
				self.goTo(0);
			}

			self._refreshNumPreloadImages();

			if(self._isMove && self._loop) {
				self._slidesContainer.css((self._vendorPref + self._TD), '0ms');
			}
			if(self._refreshSlidesTimeout) {
				clearTimeout(self._refreshSlidesTimeout);
			}


			self._refreshSlidesTimeout = setTimeout(function() {
				if(self._isMove) {
					self._setPosition( (-self._realId - self._idOffset) * self._slideSize);	
				}
				self._updateBlocksContent();
				if(!self._isMove) {
					self._currHolder.css({
						display: 'block',
						opacity: 1
					});
				}
				
			}, 14);
			self.ev.trigger('rsOnUpdateNav');
		},
		_setGrabCursor:function() {	
			var self = this;
			if(self._hasDrag && self._isMove) {
				if(self._grabCursor) {
					self._sliderOverflow.css('cursor', self._grabCursor);
				} else {
					self._sliderOverflow.removeClass('grabbing-cursor');
					self._sliderOverflow.addClass('grab-cursor');	
				}
			}
		},
		_setGrabbingCursor:function() {		
			var self = this;
			if(self._hasDrag && self._isMove) {
				if(self._grabbingCursor) {
					self._sliderOverflow.css('cursor', self._grabbingCursor);
				} else {
					self._sliderOverflow.removeClass('grab-cursor');
					self._sliderOverflow.addClass('grabbing-cursor');	
				}	
			}
		},
		next: function(notUserAction) {
			var self = this;
			self._moveTo('next',  self.st.transitionSpeed, true, !notUserAction);
		},
		prev: function(notUserAction) {
			var self = this;
			self._moveTo('prev', self.st.transitionSpeed, true, !notUserAction);
		},
		_moveTo:function(type,  speed, inOutEasing, userAction, fromSwipe) {
			var self = this,
				newPos,
				difference,
				i;
			
			
			self.ev.trigger('rsBeforeMove', [type, userAction]);
			if(type === 'next') {
				newItemId = self.currSlideId+1;
			} else if(type === 'prev') {
				newItemId = self.currSlideId-1;
			} else {
				newItemId = type = parseInt(type, 10);
			}

			if(!self._loop) {
				if(newItemId < 0) {
					self._doBackAndForthAnim('left', !userAction);
					return;
				} else if(newItemId >= self.numSlides ) {
					self._doBackAndForthAnim('right', !userAction);
					return;
				}
			}
			
			if(self._isAnimating) {
				self._stopAnimation(true);
				inOutEasing = false;
			}

			difference = newItemId - self.currSlideId;



			self._prevSlideId = self.currSlideId;
			var prevId = self.currSlideId;
			var id = self.currSlideId + difference;
			var realId = self._realId;
			var temp;
			var delayed;
			if(self._loop) {
				id = self._updateBlocksContent(false, id);
				realId += difference;
			} else {
				realId = id;
			}
			self._newSlideId = id;

			self._oldHolder = self.slidesJQ[self.currSlideId];

			
			self._realId = realId;
			self.currSlideId = self._newSlideId;

			self.currSlide = self.slides[self.currSlideId];
			self._currHolder = self.slidesJQ[self.currSlideId];

			
			var checkDist = self.st.slidesDiff;
			var next = Boolean(difference > 0);
			var absDiff = Math.abs(difference);
			var g1 = Math.floor( prevId / self._numPreloadImages);
			var g2 = Math.floor( ( prevId + (next ? checkDist : -checkDist  ) ) / self._numPreloadImages);
			var biggest = next ? Math.max(g1,g2) : Math.min(g1,g2);
			var biggestId = biggest * self._numPreloadImages +  ( next ? (self._numPreloadImages - 1) : 0 );
			if(biggestId > self.numSlides - 1) {
				biggestId = self.numSlides - 1;
			} else if(biggestId < 0) {
				biggestId = 0;
			}
			var toLast =  next ? (biggestId - prevId) :  (prevId - biggestId);
			if(toLast > self._numPreloadImages) {
				toLast = self._numPreloadImages;
			}
			if(absDiff > toLast + checkDist) {
				self._idOffset +=  ( absDiff - (toLast + checkDist) ) * ( next ? -1 : 1 );
				speed = speed * 1.4;
				for(i = 0; i < self.numSlides; i++) {
					self.slides[i].positionSet = false;
				}
			}
			self._currAnimSpeed = speed;

			self._updateBlocksContent(true);
			if(!fromSwipe) {
				delayed = true;
			}


			newPos = (-realId - self._idOffset) * self._slideSize;

			

			if(delayed) {
				setTimeout(function() {
					self._isWorking = false;
					self._animateTo(newPos, type, false, inOutEasing);
					self.ev.trigger('rsOnUpdateNav');
				}, 0);
			} else {
				self._animateTo(newPos, type, false, inOutEasing);
				self.ev.trigger('rsOnUpdateNav');
			}
			
			
			function isSetToCurrent(testId) {
				if(testId < 0) {
					testId = self.numSlides + testId;
				} else if(testId > self.numSlides - 1) {
					testId = testId - self.numSlides;
				}
				if(testId !== self.currSlideId) {
					return false;
				}
				return true;
			}
			
		},
		_updateArrowsNav: function() {
			var self = this,
				arrDisClass = 'rsArrowDisabled';
			if(self.st.arrowsNav) {
				if(self.numSlides <= 1) {
					self._arrowLeft.css('display', 'none');
					self._arrowRight.css('display', 'none');
					return;
				} else {
					self._arrowLeft.css('display', 'block');
					self._arrowRight.css('display', 'block');
				}
				if(!self._loop && !self.st.loopRewind) {
					if(self.currSlideId === 0) {
						self._arrowLeft.addClass(arrDisClass);
					} else {
						self._arrowLeft.removeClass(arrDisClass);
					}
					if(self.currSlideId === self.numSlides - 1) {
						self._arrowRight.addClass(arrDisClass);
					} else {
						self._arrowRight.removeClass(arrDisClass);
					}
				}
			}
		},
		_animateTo:function(pos, dir,  loadAll, inOutEasing, customComplete) {
			var self = this,
				moveProp,
				oldBlock,
				animBlock;

			var animObj = {};
			if(isNaN(self._currAnimSpeed)) {
				self._currAnimSpeed = 400;
			} 
			


			self._sPosition = self._currRenderPosition = pos;

			self.ev.trigger('rsBeforeAnimStart');

			if(!self._useCSS3Transitions) {
				if(self._isMove) {
					animObj[self._slidesHorizontal ? self._xProp : self._yProp] = pos + 'px';


					self._slidesContainer.animate(animObj, self._currAnimSpeed, /*'easeOutQuart'*/ inOutEasing ? self.st.easeInOut : self.st.easeOut);
				} else {
					oldBlock = self._oldHolder;
					animBlock = self._currHolder;					

					animBlock.stop(true, true).css({
						opacity: 0,
						display: 'block',
						zIndex: self._fadeZIndex
					});
					self._currAnimSpeed = self.st.transitionSpeed;
					animBlock.animate({opacity: 1}, self._currAnimSpeed, self.st.easeInOut);

					
					clearTimeouts();
					if(oldBlock) {
	 					oldBlock.data('rsTimeout', setTimeout(function() {
							oldBlock.stop(true, true).css({
								opacity: 0,
								display: 'none',
								zIndex: 0
							});
						}, self._currAnimSpeed + 60) );
					}
				}
				
			} else {
				if(self._isMove) {
					
					

						self._currAnimSpeed = parseInt(self._currAnimSpeed);
						var td = self._vendorPref + self._TD;
						var ttf = self._vendorPref + self._TTF;

						animObj[td] = self._currAnimSpeed+'ms';
						animObj[ttf] = inOutEasing ? $.rsCSS3Easing[self.st.easeInOut] : $.rsCSS3Easing[self.st.easeOut];
						
						self._slidesContainer.css(animObj);
					if(inOutEasing || !self.hasTouch) {
						setTimeout(function() {
							self._setPosition(pos);
						}, 5);
					} else {
						self._setPosition(pos);
					} 
					
					

				} else {
					//self._currAnimSpeed = 10
					self._currAnimSpeed = self.st.transitionSpeed;
					oldBlock = self._oldHolder;
					animBlock = self._currHolder;		
					if(animBlock.data('rsTimeout')) {
						animBlock.css('opacity', 0);
					}
					clearTimeouts();
					if(oldBlock) {
						//if(oldBlock)
						oldBlock.data('rsTimeout', setTimeout(function() {
							animObj[self._vendorPref + self._TD] = '0ms';
							animObj.zIndex = 0;
							animObj.display = 'none';
							oldBlock.data('rsTimeout', '');
							oldBlock.css(animObj);
							setTimeout(function() {
								oldBlock.css('opacity', 0);
							}, 16);
						}, self._currAnimSpeed + 60) );
					}

					animObj.display = 'block';
					animObj.zIndex = self._fadeZIndex;
					animObj.opacity = 0;
					animObj[self._vendorPref + self._TD] = '0ms';
					animObj[self._vendorPref + self._TTF] = $.rsCSS3Easing[self.st.easeInOut];
					animBlock.css(animObj);
					animBlock.data('rsTimeout', setTimeout(function() {
						//animBlock.css('opacity', 0);
						animBlock.css(self._vendorPref + self._TD,  self._currAnimSpeed+'ms');

						//oldBlock.css(self._vendorPref + self._TD,  '0ms');
						animBlock.data('rsTimeout', setTimeout(function() {
							animBlock.css('opacity', 1);
							animBlock.data('rsTimeout', '');
						}, 20) );
					}, 20) );
				}
			}
			self._isAnimating = true;
			if(self.loadingTimeout) {
				clearTimeout(self.loadingTimeout);
			}
			if(customComplete) {
				self.loadingTimeout = setTimeout(function() {
					self.loadingTimeout = null;
					customComplete.call();

				}, self._currAnimSpeed + 60);
			} else {
				self.loadingTimeout = setTimeout(function() {
					self.loadingTimeout = null;
					self._animationComplete(dir);
				}, self._currAnimSpeed + 60);
			}

			function clearTimeouts() {
				var t;
				if(oldBlock) {
					t = oldBlock.data('rsTimeout');
					if(t) {
						if(oldBlock !== animBlock) {
							oldBlock.css({
									opacity: 0,
									display: 'none',
									zIndex: 0
								});
						}
						clearTimeout(t);
						oldBlock.data('rsTimeout', '');
					}
				}
				
				t = animBlock.data('rsTimeout');
				if(t) {
					clearTimeout(t);
					animBlock.data('rsTimeout', '');
				}
			}
		},
		_stopAnimation: function(noCSS3) {
			var self = this;
			self._isAnimating = false;
			clearTimeout(self.loadingTimeout);
			if(self._isMove) {

				if(!self._useCSS3Transitions) {
					self._slidesContainer.stop(true);
					self._sPosition = parseInt(self._slidesContainer.css(self._xProp), 10);
				} else if (!noCSS3) {
					var oldPos = self._sPosition;
					var newPos =  self._currRenderPosition = self._getTransformProp();
					self._slidesContainer.css((self._vendorPref + self._TD), '0ms');
					if(oldPos !==newPos) {
						self._setPosition(newPos);
					}
				}
			} else {
				// kung fu
				if(self._fadeZIndex > 20) {
					self._fadeZIndex = 10;
				} else {
					self._fadeZIndex++;
				}
			}
			
			
		},
		// Thanks to @benpbarnett
		_getTransformProp:function(){
			var self = this,
				transform = window.getComputedStyle(self._slidesContainer.get(0), null).getPropertyValue(self._vendorPref + 'transform'),			
				explodedMatrix = transform.replace(/^matrix\(/i, '').split(/, |\)$/g),
				isMatrix3d = (explodedMatrix[0].indexOf('matrix3d') === 0);
			return parseInt(explodedMatrix[(self._slidesHorizontal ? (isMatrix3d ? 12 : 4) : (isMatrix3d ? 13 : 5) )], 10);
		},
		_getCSS3Prop: function(pos, hor) {
			var self = this;
			return self._useCSS3Transitions ? self._tPref1 + ( hor ? (pos + self._tPref2 + 0) : (0 + self._tPref2 + pos) ) + self._tPref3 : pos;
		},
		_animationComplete: function(dir) {
			var self = this;
			if(!self._isMove) {
				self._currHolder.css('z-index', 0);
				self._fadeZIndex = 10;
			}
			self._isAnimating = false;
			
			self.staticSlideId = self.currSlideId;
			self._updateBlocksContent();


			self._slidesMoved = false;
			
			self.ev.trigger('rsAfterSlideChange');
		},
		_doBackAndForthAnim:function(type, userAction) {
			var self = this,
				newPos = (-self._realId - self._idOffset) * self._slideSize;

			if(self.numSlides === 0 || self._isAnimating) {
				return;
			} 
			if(self.st.loopRewind) {
				self.goTo(type === 'left' ? self.numSlides - 1 : 0, userAction);
				return;
			}

			if(self._isMove) {
				self._currAnimSpeed = 200;

				function allAnimComplete() {
					self._isAnimating = false;
				}
				function firstAnimComplete() {
					self._isAnimating = false;
					self._animateTo(newPos, '', false, true, allAnimComplete);
				}
				self._animateTo(newPos + (type === 'left' ? 30 : -30),'', false, true, firstAnimComplete);
			}
			
		},
		_resizeImage:function(slideObject, useClone) {

			var isRoot = true;
			if(slideObject.isRendered) {
				return;
			}
			var img = slideObject.content;
			var classToFind = 'rsMainSlideImage';
			var isVideo;
			var self = this,
				imgAlignCenter = self.st.imageAlignCenter,
				imgScaleMode = self.st.imageScaleMode,
				tempEl;

			if(slideObject.videoURL) {
				classToFind = 'rsVideoContainer';
				if(imgScaleMode !== 'fill') {
					isVideo = true;
				} else {
					tempEl = img;
					if(!tempEl.hasClass(classToFind)) {
						tempEl = tempEl.find('.'+classToFind);
					}
					tempEl.css({width:'100%',height: '100%'});
					classToFind = 'rsMainSlideImage';
				}
			}
			if(!img.hasClass(classToFind)) {
				isRoot = false;
				img = img.find('.'+classToFind);
			}
			if(!img) {
				return;
			}

			var baseImageWidth = slideObject.iW,
				baseImageHeight = slideObject.iH;

			slideObject.isRendered = true;
			if(imgScaleMode === 'none' && !imgAlignCenter) {
				return;
			}
			if(imgScaleMode !== 'fill') {
				bMargin = self._imagePadding;
			} else {
				bMargin = 0;
			}
			//var block = img.parent('.block-inside').css('margin', bMargin);
			var containerWidth = self._wrapWidth - bMargin * 2,
				containerHeight = self._wrapHeight - bMargin * 2,
				hRatio,
				vRatio,
				ratio,
				nWidth,
				nHeight,
				cssObj = {};

			if(imgScaleMode === 'fit-if-smaller') {
				if(baseImageWidth > containerWidth || baseImageHeight > containerHeight) {
					imgScaleMode = 'fit';
				}
			}
			if(imgScaleMode === 'fill' || imgScaleMode === 'fit') {		
				hRatio = containerWidth / baseImageWidth;
				vRatio = containerHeight / baseImageHeight;

				if (imgScaleMode  == "fill") {
					ratio = hRatio > vRatio ? hRatio : vRatio;                    			
				} else if (imgScaleMode  == "fit") {
					ratio = hRatio < vRatio ? hRatio : vRatio;             		   	
				} else {
					ratio = 1;
				}

				nWidth = Math.ceil(baseImageWidth * ratio, 10);
				nHeight = Math.ceil(baseImageHeight * ratio, 10);
			} else {								
				nWidth = baseImageWidth;
				nHeight = baseImageHeight;		
			}
			if(imgScaleMode !== 'none') {
				cssObj.width = nWidth;
				cssObj.height = nHeight;
				if(isVideo) {
					img.find('.rsImg').css({width: '100%', height:'100%'});
				}
			}
			if (imgAlignCenter) {     
				cssObj.marginLeft = Math.floor((containerWidth - nWidth) / 2) +  bMargin;
				cssObj.marginTop = Math.floor((containerHeight - nHeight) / 2) +  bMargin;
			}
			img.css(cssObj);
		}
	}; /* RoyalSlider core prototype end */
	$.rsProto = RoyalSlider.prototype;

	$.fn.royalSlider = function(options) {    	
		var args = arguments;
		return this.each(function(){
			var self = $(this);
			if (typeof options === "object" ||  !options) {
				if( !self.data('royalSlider') ) {
					self.data('royalSlider', new RoyalSlider(self, options));
				}
			} else {
				var royalSlider = self.data('royalSlider');
				if (royalSlider && royalSlider[options]) {
					return royalSlider[options].apply(royalSlider, Array.prototype.slice.call(args, 1));
				}
			}
		});
	};

	$.fn.royalSlider.defaults = {    
		slidesSpacing: 8,
		startSlideId: 0,
		loop: false,
		loopRewind: false,
		numImagesToPreload: 4,
		fadeinLoadedSlide: true,
		slidesOrientation: 'horizontal', 
		transitionType: 'move', 
		transitionSpeed: 600,
		controlNavigation: 'bullets',
		controlsInside: true, 
		arrowsNav: true,
		arrowsNavAutoHide: true,
		navigateByClick: true,
		randomizeSlides: false,
		sliderDrag: true, 
		sliderTouch: true,
		keyboardNavEnabled: false,
		fadeInAfterLoaded: true,

		allowCSS3: true,
		allowCSS3OnWebkit: true,

		
		addActiveClass: false,
		autoHeight: false,

		easeOut: 'easeOutSine',
		easeInOut: 'easeInOutSine',

		minSlideOffset: 10,

		imageScaleMode:"fit-if-smaller",                 
		imageAlignCenter:true,				
		imageScalePadding: 4,
		usePreloader: true,

		autoScaleSlider: false,               
   					
   		autoScaleSliderWidth: 800,       
   		autoScaleSliderHeight: 400,   

   		autoScaleHeight: true,	    

   		arrowsNavHideOnTouch: false,
   		globalCaption: false,

   		slidesDiff: 2
	}; /* default options end */

	$.rsCSS3Easing = {
		easeOutSine: 'cubic-bezier(0.390, 0.575, 0.565, 1.000)',
		easeInOutSine: 'cubic-bezier(0.445, 0.050, 0.550, 0.950)'
	};

	$.extend(jQuery.easing, {
		easeInOutSine: function (x, t, b, c, d) {
			return -c/2 * (Math.cos(Math.PI*t/d) - 1) + b;
		},
		easeOutSine: function (x, t, b, c, d) {
			return c * Math.sin(t/d * (Math.PI/2)) + b;
		},
		easeOutCubic: function (x, t, b, c, d) {
			return c*((t=t/d-1)*t*t + 1) + b;
		}
	});


})(jQuery, window);
(function($) {
	/**
	 *
	 * RoyalSlider module that makes nearby slides visible
	 * @version 1.0.2:
	 *
	 * 1.0.1
	 * - Added navigateByCenterClick, breakpoint options
	 *
	 * 1.0.2
	 * - Added hiddenOverflow option
	 *
	 */ 
	$.rsProto._initVisibleNearby = function() {
		var self = this;
		if(self.st.visibleNearby && self.st.visibleNearby.enabled) {
			self._vnDefaults = {
				enabled: true,
				centerArea: 0.6, // Area of center image. By default 60% will get center image, 20% for each image on side

				center: true,

				breakpoint: 0, // this option will be trigger change of centerArea parameter
				breakpointCenterArea: 0.8,

				hiddenOverflow: true,
				navigateByCenterClick: false
			};
			self.st.visibleNearby = $.extend({}, self._vnDefaults, self.st.visibleNearby);

			self.ev.one('rsAfterPropsSetup', function() {
				self._sliderVisibleNearbyWrap = self._sliderOverflow.css('overflow', 'visible').wrap('<div class="rsVisibleNearbyWrap"></div>').parent();
				if(!self.st.visibleNearby.hiddenOverflow) {
					self._sliderVisibleNearbyWrap.css('overflow', 'visible');
				}
				self._controlsContainer = self.st.controlsInside ? self._sliderVisibleNearbyWrap : self.slider;
			});

			self.ev.on('rsAfterSizePropSet', function() {
				var centerRatio,
					o = self.st.visibleNearby;

				if(o.breakpoint && self.width < o.breakpoint) {
					centerRatio = o.breakpointCenterArea;
				} else {
					centerRatio = o.centerArea;
				}
				if(self._slidesHorizontal) {
					self._wrapWidth = self._wrapWidth * centerRatio;
					self._sliderVisibleNearbyWrap.css({
						height: self._wrapHeight,
						width: self._wrapWidth / centerRatio
					});
					self._minPosOffset = self._wrapWidth * (1 - centerRatio) / 2 / centerRatio;
				} else {
					self._wrapHeight = self._wrapHeight * centerRatio;
					self._sliderVisibleNearbyWrap.css({
						height: self._wrapHeight / centerRatio,
						width: self._wrapWidth
					});
					self._minPosOffset = self._wrapHeight * (1 - centerRatio) / 2 / centerRatio;
				}
				if(!o.navigateByCenterClick) {
					self._nextSlidePos = self._slidesHorizontal ? self._wrapWidth : self._wrapHeight;
				}
				if(o.center) {
					self._sliderOverflow.css('margin-' + (self._slidesHorizontal ? 'left' : 'top' ), self._minPosOffset);
				}
			});

		}
	};
	$.rsModules.visibleNearby = $.rsProto._initVisibleNearby;
})(jQuery);
(function($) {
	/**
	 *
	 * RoyalSlider global caption module
	 * @version 1.0:
	 * 
	 */ 
	$.extend($.rsProto, {
		_initGlobalCaption: function() {
			var self = this;
			if(self.st.globalCaption) {
				self.ev.on('rsAfterInit', function() {
					self.globalCaption = $('<div class="rsGCaption"></div>').appendTo( !self.st.globalCaptionInside ? self.slider : self._sliderOverflow );
					setCurrCaptionHTML();
				});
				self.ev.on('rsBeforeAnimStart' , function() {
					setCurrCaptionHTML();
				});
				function setCurrCaptionHTML() {
					self.globalCaption.html(self.currSlide.caption);
				}
			}
		}
	});
	$.rsModules.globalCaption = $.rsProto._initGlobalCaption;
})(jQuery);
(function($) {
	/**
	 *
	 * RoyalSlider active class module 
	 * @version 1.0.1:
	 *
	 * 1.0.1
	 * - Simplified code
	 * - Fixed bug when slide with activeClass is removed
	 */ 
	$.rsProto._initActiveClass = function() {
		var updClassTimeout,
			self = this,
			aSlideClass = 'rsActiveSlide';
		if(self.st.addActiveClass) {

			self.ev.on('rsOnUpdateNav', function() {

				if(updClassTimeout) clearTimeout(updClassTimeout);
				updClassTimeout = setTimeout(function() {
					if(self._oldHolder) self._oldHolder.removeClass(aSlideClass);
					if(self._currHolder) self._currHolder.addClass(aSlideClass);
					updClassTimeout = null;
				}, 50);
			});

		}
	};
	$.rsModules.activeClass = $.rsProto._initActiveClass;
})(jQuery);
(function($) {
	/**
	 *
	 * RoyalSlider thumbnails module
	 * @version 1.0.5:
	 *
	 * 1.0.1
	 * - Fixed bug with vertical thumbs caused by latest update
	 * 
	 * 1.0.2:
	 * - Dynamic adding/removing tabs.
	 *
	 * 1.0.3
	 * - Removed first transition at slider initialization
	 *
	 * 1.0.4
	 * - Added paddingTop & bottom
	 * - firstMargin now accepts number which is min distance of first/last thumbnail
	 *
	 * 1.0.5
	 * - IE10 touch support
	 *
	 */ 
	$.extend($.rsProto, {
		_initThumbs: function() {
			var self = this;
			if(self.st.controlNavigation === 'thumbnails') {

				self._thumbsDefaults = {
					drag: true,
					touch: true,
					orientation: 'horizontal',
					navigation: true,
					arrows: true,
					arrowLeft: null,
					arrowRight: null,
					spacing: 4,
					arrowsAutoHide: false,
					appendSpan: false,
					transitionSpeed:600,
					autoCenter: true,
					fitInViewport: true, 
					firstMargin: true,
					paddingTop: 0,
					paddingBottom: 0
				};

				self.st.thumbs = $.extend({}, self._thumbsDefaults, self.st.thumbs);
				self._firstThumbMoved = true;
				if(self.st.thumbs.firstMargin === false) { self.st.thumbs.firstMargin = 0; }
				else if(self.st.thumbs.firstMargin === true) { self.st.thumbs.firstMargin = self.st.thumbs.spacing; }

				self.ev.on('rsBeforeParseNode', function(e, content, obj) {
					content = $(content);
					obj.thumbnail = content.find('.rsTmb').remove();
					if(!obj.thumbnail.length) {
						obj.thumbnail = content.attr('data-rsTmb');
						if(!obj.thumbnail) {
							obj.thumbnail = content.find('.rsImg').attr('data-rsTmb');
						}
						if(!obj.thumbnail) {
							obj.thumbnail = '';
						} else {
							obj.thumbnail = '<img src="'+obj.thumbnail+'"/>';
						}
					} else {
						obj.thumbnail = $(document.createElement('div')).append(obj.thumbnail).html();
					}
				});

				self.ev.one('rsAfterPropsSetup', function() {
					self._createThumbs();
				});

				self._prevNavItem = null;
				
				self.ev.on('rsOnUpdateNav', function() {
					var currItem = $(self._controlNavItems[self.currSlideId]);
					if(currItem === self._prevNavItem) {
						return;
					}
					if(self._prevNavItem) {
						self._prevNavItem.removeClass('rsNavSelected');
						self._prevNavItem = null;
					}
					if(self._thumbsNavigation) {					
						self._setCurrentThumb(self.currSlideId);
					}
					self._prevNavItem = currItem.addClass('rsNavSelected');
				});

				self.ev.on('rsOnAppendSlide', function(e, parsedSlide, index) {
					var html = '<div'+self._thumbsMargin+' class="rsNavItem rsThumb">'+self._addThumbHTML+parsedSlide.thumbnail+'</div>';
					if(index >= self.numSlides) {
						self._thumbsContainer.append(html);
					} else {
						self._controlNavItems.eq(index).before(html);
					}
					self._controlNavItems = self._thumbsContainer.children();
					self.updateThumbsSize();
				});
				self.ev.on('rsOnRemoveSlide', function(e, index) {
					var itemToRemove = self._controlNavItems.eq(index);
					if(itemToRemove) {
						itemToRemove.remove();
						self._controlNavItems = self._thumbsContainer.children();
						self.updateThumbsSize();
					}
				});	
				

			}	
		},
		_createThumbs: function() {
			var self = this, 
				tText = 'rsThumbs',
				thumbSt = self.st.thumbs,
				out = '',
				style,
				item,
				spacing = thumbSt.spacing;
			
			self._controlNavEnabled = true;
			self._thumbsHorizontal = (thumbSt.orientation === 'vertical') ? false : true;
			
			self._thumbsMargin = style = spacing ? ' style="margin-' + (self._thumbsHorizontal ? 'right' : 'bottom') + ':'+ spacing+'px;"' : ''; 
			
			self._thumbsPosition = 0;
			self._isThumbsAnimating = false;
			self._thumbsDrag = false;
			self._thumbsNavigation = false;

			self._thumbsArrows = (thumbSt.arrows && thumbSt.navigation);

			var pl = (self._thumbsHorizontal ? 'Hor' : 'Ver');
			self.slider.addClass('rsWithThumbs' + ' rsWithThumbs'+ pl );
			
			out += '<div class="rsNav rsThumbs rsThumbs'+pl +'"><div class="'+tText+'Container">';
			self._addThumbHTML = thumbSt.appendSpan ? '<span class="thumbIco"></span>' : '';
			for(var i = 0; i < self.numSlides; i++) {
				item = self.slides[i];
				out += '<div'+style+' class="rsNavItem rsThumb">'+item.thumbnail+self._addThumbHTML+'</div>';
			}
			out = $(out +'</div></div>');

			var o = {};
			if(thumbSt.paddingTop) {
				o[self._thumbsHorizontal ? 'paddingTop' : 'paddingLeft'] = thumbSt.paddingTop;
			} 
			if(thumbSt.paddingBottom) {
				o[self._thumbsHorizontal ? 'paddingBottom' : 'paddingRight'] = thumbSt.paddingBottom;
			} 
			out.css(o);

			self._thumbsContainer = $(out).find('.' + tText + 'Container');

			if(self._thumbsArrows) {
				tText += 'Arrow';
				if(thumbSt.arrowLeft) {
					self._thumbsArrowLeft = thumbSt.arrowLeft;
				} else {
					self._thumbsArrowLeft = $('<div class="'+ tText +' ' + tText +'Left"><div class="'+tText+'Icn"></div></div>');
					out.append(self._thumbsArrowLeft);
				}

				if(thumbSt.arrowRight) {
					self._thumbsArrowRight = thumbSt.arrowRight;
				} else {
					self._thumbsArrowRight = $('<div class="'+ tText +' ' + tText +'Right"><div class="'+tText+'Icn"></div></div>');
					out.append(self._thumbsArrowRight);
				}

				
				self._thumbsArrowLeft.click(function() {
					var viewportSize = Math.floor(self._thumbsViewportSize / self._thumbSize),
						thumbId = Math.floor(self._thumbsPosition / self._thumbSize),
						newPos = (thumbId + self._visibleThumbsPerView) * self._thumbSize;
					self._animateThumbsTo( newPos > self._thumbsMinPosition ? self._thumbsMinPosition : newPos );
				});
				self._thumbsArrowRight.click(function() {
					var viewportSize = Math.floor(self._thumbsViewportSize / self._thumbSize),
						thumbId = Math.floor(self._thumbsPosition / self._thumbSize),
						newPos = (thumbId - self._visibleThumbsPerView) * self._thumbSize;
					self._animateThumbsTo( newPos < self._thumbsMaxPosition ? self._thumbsMaxPosition : newPos );
				});
				if(thumbSt.arrowsAutoHide && !self.hasTouch) {
					self._thumbsArrowLeft.css('opacity', 0);
					self._thumbsArrowRight.css('opacity', 0);

					out.one("mousemove.rsarrowshover",function() {
						if(self._thumbsNavigation) {
							self._thumbsArrowLeft.css('opacity', 1);
							self._thumbsArrowRight.css('opacity', 1);		
						}		
					});

					out.hover(
						function() {
							if(self._thumbsNavigation) {
								self._thumbsArrowLeft.css('opacity', 1);
								self._thumbsArrowRight.css('opacity', 1);
							}
						},
						function() {
							if(self._thumbsNavigation) {
								self._thumbsArrowLeft.css('opacity', 0);
								self._thumbsArrowRight.css('opacity', 0);
							}
						}
					);	
				}	
			}

			self._controlNav = out;
			self._controlNavItems = self._thumbsContainer.children();
			

			if(self.msEnabled && self.st.thumbs.navigation) {
				self._thumbsContainer.css('-ms-touch-action', self._thumbsHorizontal ? 'pan-y' : 'pan-x');
			}

			self.slider.append(out);
			
			self._thumbsEnabled = true;
			self._thumbsSpacing = spacing;

			
			if(thumbSt.navigation) {
				if(self._useCSS3Transitions) {
					self._thumbsContainer.css(self._vendorPref + 'transition-property', self._vendorPref + 'transform');
				}
			}
			
			self._controlNav.on('click.rs','.rsNavItem',function(e) {
				if(!self._thumbsDrag ) {
					self.goTo( $(this).index() );
				}
			});

			self.ev.off('rsBeforeSizeSet.thumbs').on('rsBeforeSizeSet.thumbs', function() {
				self._realWrapSize = self._thumbsHorizontal ? self._wrapHeight : self._wrapWidth;
				self.updateThumbsSize(true);

			});

			
		},
		updateThumbsSize: function(isResize) {
			var self = this,
				firstThumb = self._controlNavItems.first(),
				cssObj = {};

			var numItems = self._controlNavItems.length;
			self._thumbSize = ( self._thumbsHorizontal ? firstThumb.outerWidth() : firstThumb.outerHeight() ) + self._thumbsSpacing;
			self._thumbsContainerSize = numItems * self._thumbSize - self._thumbsSpacing;
			cssObj[self._thumbsHorizontal ? 'width' : 'height'] = self._thumbsContainerSize + self._thumbsSpacing;
			self._thumbsViewportSize = self._thumbsHorizontal ? self._controlNav.width() : self._controlNav.height();
			self._thumbsMaxPosition = -(self._thumbsContainerSize - self._thumbsViewportSize) - (self.st.thumbs.firstMargin);
			self._thumbsMinPosition = self.st.thumbs.firstMargin;
			self._visibleThumbsPerView = Math.floor(self._thumbsViewportSize / self._thumbSize);

			if(self._thumbsContainerSize < self._thumbsViewportSize) {
				if(self.st.thumbs.autoCenter) {
					self._setThumbsPosition((self._thumbsViewportSize - self._thumbsContainerSize) / 2);
				}
				if(self.st.thumbs.arrows && self._thumbsArrowLeft) {
					var arrDisClass = 'rsThumbsArrowDisabled';
					self._thumbsArrowLeft.addClass(arrDisClass);
					self._thumbsArrowRight.addClass(arrDisClass);
				}
				self._thumbsNavigation = false;
				self._thumbsDrag = false;
				self._controlNav.off(self._downEvent);	

			} else if(self.st.thumbs.navigation && !self._thumbsNavigation) {
				self._thumbsNavigation = true;
				if( (!self.hasTouch && self.st.thumbs.drag) ||  (self.hasTouch && self.st.thumbs.touch)) {
					self._thumbsDrag = true;
					self._controlNav.on(self._downEvent, function(e) { self._onDragStart(e, true); });	
				}
			}

			if(self._useCSS3Transitions) {
				cssObj[(self._vendorPref + 'transition-duration')] = '0ms';
			}



			self._thumbsContainer.css(cssObj);

			if(self._thumbsEnabled && (self.isFullscreen || self.st.thumbs.fitInViewport)) {
				if(self._thumbsHorizontal) {
					self._wrapHeight = self._realWrapSize - self._controlNav.outerHeight();
				} else {
					self._wrapWidth = self._realWrapSize - self._controlNav.outerWidth();
				}
			}
		},
		setThumbsOrientation: function(newPlacement, dontUpdateSize) {
			var self = this;
			if(self._thumbsEnabled) {
				self.st.thumbs.orientation = newPlacement;
				self._controlNav.remove();
				self.slider.removeClass('rsWithThumbsHor rsWithThumbsVer');
				self._createThumbs();
				self._controlNav.off(self._downEvent);	
				if(!dontUpdateSize) {
					self.updateSliderSize(true);
				}
			}
		},
		_setThumbsPosition: function(pos) {
			var self = this;
			self._thumbsPosition = pos;
			if(self._useCSS3Transitions) {
				self._thumbsContainer.css(self._xProp, self._tPref1 + ( self._thumbsHorizontal ? (pos + self._tPref2 + 0) : (0 + self._tPref2 + pos) ) + self._tPref3 );		
			} else {
				self._thumbsContainer.css(self._thumbsHorizontal ? self._xProp : self._yProp, pos);
			}
		},
		_animateThumbsTo: function(pos, speed, outEasing, bounceAnimPosition, bounceAnimSpeed) {
			var self = this;
			if(!self._thumbsNavigation) {
				return;
			}
			if(!speed) {
				speed = self.st.thumbs.transitionSpeed;
			}
			self._thumbsPosition = pos;
			if(self._thumbsAnimTimeout) {
				clearTimeout(self._thumbsAnimTimeout);
			}
			if(self._isThumbsAnimating) {
				if(!self._useCSS3Transitions) {
					self._thumbsContainer.stop();
				}
				outEasing = true;
			}
			var animObj = {};
			self._isThumbsAnimating = true;
			if(!self._useCSS3Transitions) {
				animObj[self._thumbsHorizontal ? self._xProp : self._yProp] = pos + 'px';
				self._thumbsContainer.animate(animObj, speed, outEasing ? 'easeOutCubic' : self.st.easeInOut);
			} else { 
				animObj[(self._vendorPref + 'transition-duration')] = speed+'ms';
				animObj[(self._vendorPref + 'transition-timing-function')] = outEasing ? $.rsCSS3Easing[self.st.easeOut] : $.rsCSS3Easing[self.st.easeInOut];
				self._thumbsContainer.css(animObj);
				self._setThumbsPosition(pos);
			}
			if(bounceAnimPosition) {
				self._thumbsPosition = bounceAnimPosition;
			}
			self._updateThumbsArrows();
			
			
			self._thumbsAnimTimeout = setTimeout(function() {
				self._isThumbsAnimating = false;
				if(bounceAnimSpeed) {
					self._animateThumbsTo(bounceAnimPosition, bounceAnimSpeed, true);
					bounceAnimSpeed = null;
				}
			}, speed);
		},
		_updateThumbsArrows: function() {
			var self = this;
			if(self._thumbsArrows) {
				var arrDisClass = 'rsThumbsArrowDisabled';
				
				if(self._thumbsPosition === self._thumbsMinPosition) {
					self._thumbsArrowLeft.addClass(arrDisClass);
				} else {
					self._thumbsArrowLeft.removeClass(arrDisClass);
				}
				if(self._thumbsPosition === self._thumbsMaxPosition) {
					self._thumbsArrowRight.addClass(arrDisClass);
				} else {
					self._thumbsArrowRight.removeClass(arrDisClass);
				}
			}
		},
		_setCurrentThumb: function(id, justSet) {
			
			var self = this,
				incr = 0,
				newPos,
				nextThumbEndPos = (id * self._thumbSize + self._thumbSize * 2 - self._thumbsSpacing + self._thumbsMinPosition),
				thumbId = Math.floor(self._thumbsPosition / self._thumbSize);
			
			if(!self._thumbsNavigation) {
				return;
			}
			if(self._firstThumbMoved) {
				justSet = true;
				self._firstThumbMoved = false;
			}

			if(nextThumbEndPos  + self._thumbsPosition > self._thumbsViewportSize) {
				if(id === self.numSlides - 1) {
					incr = 1;
				}
				thumbId = -id + self._visibleThumbsPerView - 2 + incr;
				newPos = thumbId * self._thumbSize + (self._thumbsViewportSize % self._thumbSize) + self._thumbsSpacing - self._thumbsMinPosition;
			} else {
				if(id !== 0) {
					if( (id-1) * self._thumbSize <= -self._thumbsPosition + self._thumbsMinPosition && (id-1) <= self.numSlides - self._visibleThumbsPerView) {
						thumbId = -id + 1;
						newPos = thumbId * self._thumbSize + self._thumbsMinPosition;
					}
				} else {
					thumbId = 0;
					newPos = self._thumbsMinPosition;
				}
			}

			if(newPos !== self._thumbsPosition) {
				var checkPos = (newPos === undefined) ? self._thumbsPosition : newPos;
				if(checkPos > self._thumbsMinPosition) {
					self._setThumbsPosition(self._thumbsMinPosition);
				} else if(checkPos < self._thumbsMaxPosition) {
					self._setThumbsPosition(self._thumbsMaxPosition);
				} else  if(newPos !== undefined) {
					if(!justSet) {
						self._animateThumbsTo(newPos);
					} else {
						self._setThumbsPosition(newPos);
					}
				}
			}
			self._updateThumbsArrows();
		}
	});
	$.rsModules.thumbnails = $.rsProto._initThumbs;
})(jQuery);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//













;
