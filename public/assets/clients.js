(function() {

  this.app = angular.module('clients', ['contenteditable']);

  this.app.config([
    '$routeProvider', function($routeProvider) {
      var base_page_url;
      base_page_url = '/home';
      return $routeProvider.when('/home', {
        templateUrl: 'clients/home'
      }).when('/petition_setup', {
        templateUrl: 'clients/petition_setup'
      }).when('/petition_pages', {
        templateUrl: 'clients/pages'
      }).when('/customers', {
        templateUrl: 'clients/customers'
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

  this.app.run(['$q', '$rootScope', function($q, $rootScope) {}]);

}).call(this);
(function() {

  this.ClientsController = function($scope, $rootScope) {
    window.scope = $scope;
    return $scope.client = {
      name: "Test Client"
    };
  };

  ClientsController.$inject = ['$scope', '$rootScope'];

}).call(this);
(function() {

  this.PetitionSetupController = function($scope, $rootScope) {
    window.scope = $scope;
    $scope.step = 1;
    $scope.petition = {
      name: 'New Campaign Name',
      title: 'Petition Headline',
      sub_heading: 'Sub-Headline Text',
      summary: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum.<br /><br />Typi non habent claritatem insitam; est usus legentis in iis qui facit eorum claritatem. Investigationes demonstraverunt lectores legere me lius quod ii legunt saepius. Claritas est etiam processus dynamicus, qui sequitur mutationem consuetudium lectorum. Mirum est notare quam littera gothica, quam nunc putamus parum claram, anteposuerit litterarum formas humanitatis per seacula quarta decima et quinta decima. Eodem modo typi, qui nunc nobis videntur parum clari, fiant sollemnes in futurum.',
      sign_with_facebook_cta_button_text: 'Sign with Facebook',
      sign_with_email_cta_button_text: 'Add My Name',
      target_count: 1000,
      more_signers_button_text: 'More Signers Button Text',
      redemption_url: '',
      default_tweet_text: 'Hey @Barack',
      delivery: {
        headline: 'Thanks for Signing!',
        sub_headline: 'Delivery Sub Heading',
        tweet_call_to_action_text: 'Send Tweet Call to Action',
        tweet_skip_text: 'Skip Text',
        more_tweets_button_text: 'More Tweets Button Text'
      }
    };
    $scope.content_template_urls = function() {
      if ($scope.step === 5) {
        return "clients/partials/email_config";
      } else if ($scope.step === 4) {
        return "clients/partials/pages";
      } else if ($scope.step === 3) {
        return "clients/partials/theme";
      } else if ($scope.step === 2) {
        return "clients/partials/layout";
      } else if ($scope.step === 1) {
        return "clients/partials/configure";
      }
    };
    $scope.sidebar_template_urls = function() {
      if ($scope.step === 5) {
        return "clients/partials/email_config_sidebar";
      } else if ($scope.step === 4) {
        return "clients/partials/pages_sidebar";
      } else if ($scope.step === 3) {
        return "clients/partials/theme_sidebar";
      } else if ($scope.step === 2) {
        return "clients/partials/layout_sidebar";
      } else if ($scope.step === 1) {
        return "clients/partials/configure_sidebar";
      }
    };
    return $scope.next_step_clicked = function() {
      console.log("next clicked");
      return $scope.step += 1;
    };
  };

  PetitionSetupController.$inject = ['$scope', '$rootScope'];

}).call(this);
/**
 * @see http://docs.angularjs.org/guide/concepts
 * @see http://docs.angularjs.org/api/ng.directive:ngModel.NgModelController
 * @see https://github.com/angular/angular.js/issues/528#issuecomment-7573166
 */


angular.module('contenteditable', [])
  .directive('contenteditable', ['$timeout', function($timeout) { return {
    restrict: 'A',
    require: '?ngModel',
    link: function($scope, $element, attrs, ngModel) {
      // don't do anything unless this is actually bound to a model
      if (!ngModel) {
        return
      }

      // view -> model
      $element.bind('input', function(e) {
        $scope.$apply(function() {
          var html, html2, rerender
          html = $element.html()
          rerender = false
          if (attrs.stripBr && attrs.stripBr !== "false") {
            html = html.replace(/<br>$/, '')
          }
          if (attrs.noLineBreaks && attrs.noLineBreaks !== "false") {
            html2 = html.replace(/<div>/g, '').replace(/<br>/g, '').replace(/<\/div>/g, '')
            if (html2 !== html) {
              rerender = true
              html = html2
            }
          }
          ngModel.$setViewValue(html)
          if (rerender) {
            ngModel.$render()
          }
          if (html === '') {
            // the cursor disappears if the contents is empty
            // so we need to refocus
            $timeout(function(){
              $element[0].blur()
              $element[0].focus()
            })
          }
        })
      })

      // model -> view
      var oldRender = ngModel.$render
      ngModel.$render = function() {
        var el, el2, range, sel
        if (!!oldRender) {
          oldRender()
        }
        $element.html(ngModel.$viewValue || '')
        el = $element[0]
        range = document.createRange()
        sel = window.getSelection()
        if (el.childNodes.length > 0) {
          el2 = el.childNodes[el.childNodes.length - 1]
          range.setStartAfter(el2)
        } else {
          range.setStartAfter(el)
        }
        range.collapse(true)
        sel.removeAllRanges()
        sel.addRange(range)
      }
      if (attrs.selectNonEditable && attrs.selectNonEditable !== "false") {
        $element.bind('click', function(e) {
          var range, sel, target
          target = e.toElement
          if (target !== this && angular.element(target).attr('contenteditable') === 'false') {
            range = document.createRange()
            sel = window.getSelection()
            range.setStartBefore(target)
            range.setEndAfter(target)
            sel.removeAllRanges()
            sel.addRange(range)
          }
        })
      }
    }
  }}])
;
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//






;
