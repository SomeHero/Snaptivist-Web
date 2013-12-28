/* ============================================================
 * bootstrap-dropdown.js v2.2.1
 * http://twitter.github.com/bootstrap/javascript.html#dropdowns
 * ============================================================
 * Copyright 2012 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ============================================================ */



!function ($) {

  "use strict"; // jshint ;_;


 /* DROPDOWN CLASS DEFINITION
  * ========================= */

  var toggle = '[data-toggle=dropdown]'
    , Dropdown = function (element) {
        var $el = $(element).on('click.dropdown.data-api', this.toggle)
        $('html').on('click.dropdown.data-api', function () {
          $el.parent().removeClass('open')
        })
      }

  Dropdown.prototype = {

    constructor: Dropdown

  , toggle: function (e) {
      var $this = $(this)
        , $parent
        , isActive

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      clearMenus()

      if (!isActive) {
        $parent.toggleClass('open')
        $this.focus()
      }

      return false
    }

  , keydown: function (e) {
      var $this
        , $items
        , $active
        , $parent
        , isActive
        , index

      if (!/(38|40|27)/.test(e.keyCode)) return

      $this = $(this)

      e.preventDefault()
      e.stopPropagation()

      if ($this.is('.disabled, :disabled')) return

      $parent = getParent($this)

      isActive = $parent.hasClass('open')

      if (!isActive || (isActive && e.keyCode == 27)) return $this.click()

      $items = $('[role=menu] li:not(.divider) a', $parent)

      if (!$items.length) return

      index = $items.index($items.filter(':focus'))

      if (e.keyCode == 38 && index > 0) index--                                        // up
      if (e.keyCode == 40 && index < $items.length - 1) index++                        // down
      if (!~index) index = 0

      $items
        .eq(index)
        .focus()
    }

  }

  function clearMenus() {
    $(toggle).each(function () {
      getParent($(this)).removeClass('open')
    })
  }

  function getParent($this) {
    var selector = $this.attr('data-target')
      , $parent

    if (!selector) {
      selector = $this.attr('href')
      selector = selector && /#/.test(selector) && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
    }

    $parent = $(selector)
    $parent.length || ($parent = $this.parent())

    return $parent
  }


  /* DROPDOWN PLUGIN DEFINITION
   * ========================== */

  $.fn.dropdown = function (option) {
    return this.each(function () {
      var $this = $(this)
        , data = $this.data('dropdown')
      if (!data) $this.data('dropdown', (data = new Dropdown(this)))
      if (typeof option == 'string') data[option].call($this)
    })
  }

  $.fn.dropdown.Constructor = Dropdown


  /* APPLY TO STANDARD DROPDOWN ELEMENTS
   * =================================== */

  $(document)
    .on('click.dropdown.data-api touchstart.dropdown.data-api', clearMenus)
    .on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() })
    .on('click.dropdown.data-api touchstart.dropdown.data-api'  , toggle, Dropdown.prototype.toggle)
    .on('keydown.dropdown.data-api touchstart.dropdown.data-api', toggle + ', [role=menu]' , Dropdown.prototype.keydown)

}(window.jQuery);
(function() {

  this.app = angular.module('clients', ['contenteditable', 'angularFileUpload', 'ui.bootstrap', 'toggle-switch']);

  this.app.config([
    '$routeProvider', function($routeProvider) {
      var base_page_url;
      base_page_url = '/home';
      return $routeProvider.when('/home', {
        templateUrl: 'clients/home'
      }).when('/petitions', {
        templateUrl: 'clients/petitions',
        controller: PetitionController,
        resolve: PetitionController.resolve
      }).when('/petition_setup', {
        templateUrl: 'clients/petition_setup',
        controller: PetitionSetupController,
        resolve: PetitionSetupController.resolve
      }).when('/petition_pages', {
        templateUrl: 'clients/pages'
      }).when('/supporters', {
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

  this.app.filter("fromNow", function() {
    return function(dateString) {
      return moment(new Date(dateString)).fromNow();
    };
  });

  this.app.run(['$q', '$rootScope', function($q, $rootScope) {}]);

}).call(this);
(function() {

  this.ClientsController = function($scope, $rootScope, ClientFactory, Util) {
    window.scope = $scope;
    $scope.client = client;
    $scope.styles = {
      stylesheet_list: []
    };
    $scope.stylesheets = function() {
      return $scope.styles.stylesheet_list;
    };
    return $scope.new_petition_clicked = function() {
      ClientFactory.petition = {};
      return Util.navigate_absolute('/clients/' + $scope.client.client_id + '/', 'petition_setup', false);
    };
  };

  ClientsController.$inject = ['$scope', '$rootScope', 'ClientFactory', 'Util'];

}).call(this);
(function() {

  this.CommentController = function($scope, $rootScope) {};

}).call(this);
(function() {

  this.EmailConfigurationController = function($scope, $rootScope) {};

}).call(this);
(function() {

  this.ModalInstanceController = function($scope, $modalInstance, items) {
    $scope.errors = items;
    $scope.selected = {
      item: $scope.errors[0]
    };
    $scope.ok = function() {
      return $modalInstance.close($scope.selected.item);
    };
    return $scope.cancel = function() {
      return $modalInstance.dismiss("cancel");
    };
  };

}).call(this);
(function() {

  this.NavigationController = function($scope, $rootScope, $location) {
    var validate_step;
    validate_step = function(step) {
      if (step === 1) {
        return $scope.petition.name && $scope.petition.subdomain || false;
      } else if (step === 2) {
        return $scope.settings.layout || false;
      } else if (step === 3) {
        return $scope.settings.theme || false;
      } else if (step === 4) {
        return $scope.settings.pages_list.length > 0;
      } else if (step === 5) {
        return $scope.settings.pages_list.length > 0;
      } else if (step === 6) {
        return $scope.settings.pages_list.length > 0;
      }
      return true;
    };
    $scope.disabled_step_styling = function(step) {
      if (step === 2 && !validate_step(1)) {
        return {
          'color': 'gray'
        };
      } else if (step === 3 && !(validate_step(1) && validate_step(2))) {
        return {
          'color': 'gray'
        };
      } else if (step === 4 && !(validate_step(1) && validate_step(2) && validate_step(3))) {
        return {
          'color': 'gray'
        };
      } else if (step === 5 && !(validate_step(1) && validate_step(2) && validate_step(3) && validate_step(4))) {
        return {
          'color': 'gray'
        };
      } else if (step === 6 && !(validate_step(1) && validate_step(2) && validate_step(3) && validate_step(4) && validate_step(5))) {
        return {
          'color': 'gray'
        };
      }
    };
    return $scope.goto_step_clicked = function(step) {
      console.log("step clicked");
      if (!validate_step(step - 1)) {
        return;
      }
      $scope.settings.step = step;
      return $location.hash($scope.settings.step);
    };
  };

}).call(this);
(function() {

  this.PagesConfigurationController = function($scope, $rootScope, $location) {
    return $scope.add_page = function(page) {
      page.expanded = true;
      $scope.settings.pages_list.push(page);
      return $scope.update_petition_pages();
    };
  };

}).call(this);
(function() {

  this.PagesController = function($scope, $rootScope, $location) {
    $scope.remove_page = function(page) {
      var i, page_item, _i, _len, _ref, _results;
      _ref = scope.settings.pages_list;
      _results = [];
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        page_item = _ref[i];
        if (page_item === page) {
          _results.push($scope.settings.pages_list.splice(i, 1));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
    return $scope.toggle_page = function(page) {
      return page.expanded = !page.expanded;
    };
  };

}).call(this);
(function() {

  this.PetitionController = function($scope, $route, $modal, $log, $rootScope, $location, petitions, ClientFactory, Util) {
    window.scope = $scope;
    $scope.petitions = petitions;
    ClientFactory.petitions = petitions;
    return $scope.edit_petition = function(petition) {
      ClientFactory.petition = petition;
      $location.hash("");
      return Util.navigate('/petition_setup');
    };
  };

  PetitionController.resolve = {
    petitions: [
      'PetitionServices', '$q', function(PetitionServices, $q) {
        var deferred;
        deferred = $q.defer();
        PetitionServices.get(client.client_id).then(function(response) {
          return deferred.resolve(response);
        });
        return deferred.promise;
      }
    ]
  };

}).call(this);
(function() {

  this.PetitionSetupController = function($scope, $route, $modal, $log, $rootScope, $location, fileReader, ClientFactory, PetitionServices, Util, email_types, layouts, pages, themes) {
    var email_type, lastRoute, page, tag, validate_step, _i, _j, _k, _len, _len1, _len2, _ref, _ref1, _ref2;
    window.scope = $scope;
    $scope.client_id = $scope.client.client_id;
    $scope.is_admin = true;
    $scope.email_types = email_types;
    $scope.layouts = layouts;
    $scope.themes = themes;
    $scope.pages = pages;
    $scope.settings = {
      layout: null,
      theme: null,
      step: 1,
      pages_list: []
    };
    $scope.update_petition_pages = function() {
      var i, page_item, _i, _len, _ref, _results;
      $scope.petition.petition_pages_attributes = [];
      i = 1;
      _ref = $scope.settings.pages_list;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        page_item = _ref[_i];
        $scope.petition.petition_pages_attributes.push({
          page_id: page_item.id,
          position: i
        });
        _results.push(i++);
      }
      return _results;
    };
    $scope.update_stylesheet_list = function() {
      $scope.styles.stylesheet_list = [];
      if ($scope.settings.layout) {
        $scope.styles.stylesheet_list.push({
          href: '/assets/layouts/' + $scope.settings.layout.url_fragment + '.css'
        });
        $scope.styles.stylesheet_list.push({
          href: '/assets/layouts/' + $scope.settings.layout.url_fragment + '-responsive.css'
        });
        if ($scope.settings.theme) {
          $scope.styles.stylesheet_list.push({
            href: '/assets/themes/' + $scope.settings.layout.url_fragment + '/' + $scope.settings.theme.url_fragment + '/style.css'
          });
          return $scope.styles.stylesheet_list.push({
            href: '/assets/themes/' + $scope.settings.layout.url_fragment + '/' + $scope.settings.theme.url_fragment + '/style-responsive.css'
          });
        }
      }
    };
    $scope.petition = ClientFactory.petition;
    if (!$scope.petition.petition_pages_attributes) {
      $scope.petition.petition_pages_attributes = [];
    }
    if (!$scope.settings.pages_list) {
      $scope.settings.pages_list = [];
    }
    if ($scope.petition.layout) {
      $scope.settings.layout = $scope.petition.layout;
      $scope.update_stylesheet_list();
    }
    if ($scope.petition.theme) {
      $scope.settings.theme = $scope.petition.theme;
      $scope.update_stylesheet_list();
    }
    if ($scope.petition.pages) {
      _ref = $scope.petition.pages;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        page = _ref[_i];
        $scope.settings.pages_list.push(page);
      }
    }
    $scope.action_tags = {
      new_tag: "",
      list: []
    };
    if ($scope.petition.action_tags) {
      _ref1 = $scope.petition.action_tags.split(',');
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        tag = _ref1[_j];
        $scope.action_tags.list.push({
          name: tag
        });
      }
    }
    if (!$scope.petition.email_configurations_attributes || $scope.petition.email_configurations_attributes.length === 0) {
      $scope.petition.email_configurations_attributes = [];
      _ref2 = $scope.email_types;
      for (_k = 0, _len2 = _ref2.length; _k < _len2; _k++) {
        email_type = _ref2[_k];
        $scope.petition.email_configurations_attributes.push({
          email_type: email_type,
          email_type_id: email_type.id,
          enabled: email_type.default_state,
          from_address: $scope.client.email || "admin@snaptivist.com",
          from_name: $scope.client.name,
          subject: email_type.default_subject
        });
      }
    }
    if ($location.hash()) {
      $scope.settings.step = parseInt($location.hash());
    } else {
      $scope.settings.step = 1;
    }
    $scope.set_layout_item_styling = function(layout) {
      if ($scope.settings.layout === layout) {
        return {
          'border': 'dashed 1px green'
        };
      }
    };
    $scope.set_theme_item_styling = function(theme) {
      if ($scope.settings.theme === theme) {
        return {
          'border': 'dashed 1px green'
        };
      }
    };
    $scope.save_clicked = function() {
      return console.log("save clicked");
    };
    $scope.cancel_clicked = function() {
      console.log("cancel clicked");
      return Util.navigate('petitions');
    };
    $scope.publish_clicked = function() {
      return console.log("publish clicked");
    };
    $scope.highlight_step = function(step) {
      if (step === $scope.settings.step) {
        return {
          'color': '#eae874'
        };
      }
    };
    $scope.content_template_urls = function() {
      if ($scope.settings.step === 6) {
        return "clients/partials/publish";
      } else if ($scope.settings.step === 5) {
        return "clients/partials/email_config";
      } else if ($scope.settings.step === 4) {
        return "clients/partials/pages";
      } else if ($scope.settings.step === 3) {
        return "clients/partials/theme";
      } else if ($scope.settings.step === 2) {
        return "clients/partials/layout";
      } else {
        return "clients/partials/configure";
      }
    };
    $scope.sidebar_template_urls = function() {
      if ($scope.settings.step === 6) {
        return "clients/partials/publish_sidebar";
      } else if ($scope.settings.step === 5) {
        return "clients/partials/email_config_sidebar";
      } else if ($scope.settings.step === 4) {
        return "clients/partials/pages_sidebar";
      } else if ($scope.settings.step === 3) {
        return "clients/partials/theme_sidebar";
      } else if ($scope.settings.step === 2) {
        return "clients/partials/layout_sidebar";
      } else {
        return "clients/partials/configure_sidebar";
      }
    };
    $scope.items = ['item1', 'item2', 'item3'];
    $scope.next_step_clicked = function(form) {
      var errors, modalInstance;
      console.log("next clicked");
      if (form.$valid && validate_step($scope.settings.step)) {
        if ($scope.settings.step === 5) {
          $scope.petition.layout_id = $scope.settings.layout.id;
          $scope.petition.theme_id = $scope.settings.theme.id;
          delete $scope.petition["layout"];
          delete $scope.petition["theme"];
          delete $scope.petition["pages"];
          return $scope.submit_petition();
        } else {
          $scope.settings.step = parseInt($scope.settings.step) + 1;
          return $location.hash($scope.settings.step);
        }
      } else {
        errors = [];
        if ($scope.settings.step === 1) {
          if (form.petition_name.$error['required']) {
            errors.push("You must specify a name for your petition.");
          }
          if (form.subdomain.$error['required']) {
            errors.push("You must specify a subdomain fom your petition.");
          }
        } else if ($scope.settings.step === 2) {
          errors.push("You must select a layout for your petition from the layouts on the right.");
        } else if ($scope.settings.step === 3) {
          errors.push("You must select a theme for your petition from the themes on the right.");
        } else if ($scope.settings.step === 4) {
          if ($scope.settings.pages_list.length === 0) {
            errors.push("You must add atleast 1 page to your petition. Select a page to add from the list of pages on the right.");
          } else {
            if (form.headline_primary.$error['required']) {
              errors.push("You must specify the text for the 'Petition Headline'.");
            }
            if (form.sign_with_facebook_cta_button_text.$error['required']) {
              errors.push("You must specify the text for the 'Sign with Facebook' button.");
            }
            if (form.sign_with_email_cta_button_text.$error['required']) {
              errors.push("You must specify the text for the 'Sign with Email Address' button.");
            }
            if (form.target_count.$error['required']) {
              errors.push("You must specify the target number of signatures your petition is attempting to collect.");
            }
            if (form.summary.$error['required']) {
              errors.push("You must specify the summary text for your petition.");
            }
            if (form.signature_more_signers_button_text.$error['required']) {
              errors.push("You must specify the text for the 'More Signers' button.");
            }
          }
        }
        modalInstance = $modal.open({
          templateUrl: 'clients/partials/modal_template',
          controller: ModalInstanceController,
          resolve: {
            items: function() {
              return errors;
            }
          }
        });
        return modalInstance.result.then((function(selectedItem) {
          return $scope.selected = selectedItem;
        }), function() {
          return $log.info("Modal dismissed at: " + new Date());
        });
      }
    };
    $scope.onFileSelect = function($files) {
      var $file, i, _results;
      i = 0;
      _results = [];
      while (i < $files.length) {
        $file = $files[i];
        $scope.file = $file;
        $scope.getFile();
        _results.push(i++);
      }
      return _results;
    };
    $scope.getFile = function() {
      $scope.progress = 0;
      return fileReader.readAsDataUrl($scope.file, $scope).then(function(result) {
        $scope[$scope.file.file_name + "_url"] = result;
        return $scope[$scope.file.file_name] = $scope.file;
      });
    };
    $scope.submit_petition = function() {
      if ($scope.petition.id) {
        console.log("update petition");
        return PetitionServices.update($scope.client_id, $scope.petition, $scope.image_full, $scope.premium_image).success(function(response) {
          console.log("petition update success");
          return Util.navigate('petitions');
        }).error(function() {
          return console.log("petition update failed");
        });
      } else {
        return PetitionServices.create($scope.client_id, $scope.petition, $scope.image_full, $scope.premium_image).success(function(response) {
          console.log("petition created");
          return Util.navigate('petitions');
        }).error(function() {
          console.log("create petition failed".success(function(response) {}));
          console.log("petition created");
          return Util.navigate('petitions');
        }).error(function() {
          return console.log("create petition failed");
        });
      }
    };
    $scope.client_image_url = function() {
      return $scope.client.image_large;
    };
    $scope.get_tweet_message_length = function() {
      if ($scope.petition.default_tweet_text) {
        return $scope.petition.default_tweet_text.length;
      } else {
        return 0;
      }
    };
    $scope.signature_image_styling = function() {
      if ($scope.image_full_url) {
        return {
          'background-image': 'url(' + $scope.image_full_url + ')'
        };
      } else {
        return {
          'background-image': 'url(' + $scope.petition.image_full_url + ')'
        };
      }
    };
    $scope.premium_image_styling = function() {
      return {
        'background-image': 'url(' + $scope.premium_image_url + ')'
      };
    };
    $scope.petition_url = function() {
      return $location.protocol() + "://" + $location.host() + "/petitions/" + $scope.petition.id;
    };
    $scope.set_layout = function(layout) {
      $scope.settings.layout = layout;
      return $scope.update_stylesheet_list();
    };
    $scope.set_theme = function(theme) {
      $scope.settings.theme = theme;
      return $scope.update_stylesheet_list();
    };
    $scope.get_page_template = function(template_name) {
      return "/client_views/" + $scope.settings.layout.url_fragment + "/" + template_name;
    };
    $scope.add_action_tag = function() {
      var new_tag;
      new_tag = $scope.action_tags.new_tag;
      $scope.action_tags.list.push({
        name: new_tag
      });
      $scope.action_tags.new_tag = "";
      if ($scope.petition.action_tags) {
        return $scope.petition.action_tags += "," + new_tag;
      } else {
        return $scope.petition.action_tags = new_tag;
      }
    };
    $scope.delete_action_tag = function(tag) {
      var _l, _len3, _ref3, _results;
      $scope.action_tags.list.splice($scope.action_tags.list.indexOf(tag), 1);
      $scope.petition.action_tags = "";
      _ref3 = $scope.action_tags.list;
      _results = [];
      for (_l = 0, _len3 = _ref3.length; _l < _len3; _l++) {
        tag = _ref3[_l];
        if ($scope.petition.action_tags) {
          _results.push($scope.petition.action_tags += "," + tag.name);
        } else {
          _results.push($scope.petition.action_tags = tag.name);
        }
      }
      return _results;
    };
    validate_step = function(step) {
      if (step === 1) {
        return $scope.petition.name && $scope.petition.subdomain || false;
      } else if (step === 2) {
        return $scope.settings.layout || false;
      } else if (step === 3) {
        return $scope.settings.theme || false;
      } else if (step === 4) {
        return $scope.settings.pages_list.length > 0;
      } else if (step === 5) {
        return $scope.settings.pages_list.length > 0;
      } else if (step === 6) {
        return $scope.settings.pages_list.length > 0;
      }
      return true;
    };
    lastRoute = $route.current;
    return $scope.$on("$locationChangeSuccess", function(event) {
      if ($route.current.templateUrl === 'clients/petition_setup') {
        return $route.current = lastRoute;
      }
    });
  };

  PetitionSetupController.$inject = ['$scope', '$route', '$modal', '$log', '$rootScope', '$location', 'fileReader', 'ClientFactory', 'PetitionServices', 'Util', 'email_types', 'layouts', 'pages', 'themes'];

  PetitionSetupController.resolve = {
    email_types: [
      'EmailTypeServices', '$q', function(EmailTypeServices, $q) {
        var deferred;
        deferred = $q.defer();
        EmailTypeServices.get_email_types().then(function(response) {
          return deferred.resolve(response);
        });
        return deferred.promise;
      }
    ],
    layouts: [
      'LayoutServices', '$q', function(LayoutServices, $q) {
        var deferred;
        deferred = $q.defer();
        LayoutServices.get_layouts().then(function(response) {
          return deferred.resolve(response);
        });
        return deferred.promise;
      }
    ],
    pages: [
      'PageServices', '$q', function(PageServices, $q) {
        var deferred;
        deferred = $q.defer();
        PageServices.get_pages(2).then(function(response) {
          return deferred.resolve(response);
        });
        return deferred.promise;
      }
    ],
    themes: [
      'ThemeServices', '$q', function(ThemeServices, $q) {
        var deferred;
        deferred = $q.defer();
        ThemeServices.get_themes(2).then(function(response) {
          return deferred.resolve(response);
        });
        return deferred.promise;
      }
    ]
  };

}).call(this);
(function() {

  this.SamplePetitionController = function($scope, $rootScope) {
    $scope.is_admin = false;
    $scope.petition = {
      headline_primary: 'Tell Barack Obama',
      headline_secondary: 'Stop the Drone Assassinations of American Citizens',
      subheadline: 'Demand Your Right to Due Process',
      sign_with_facebook_cta_button_text: 'Sign with Facebook',
      sign_with_email_cta_button_text: 'Sign with Email Address',
      target_count: 1000,
      signature_count: 345,
      signature_more_signers_button_text: 'More Signers',
      summary: 'The IRS has been targeting Americans for their political beliefs and using their power to intimidate law-abiding citizens and chill their freedom of speech. It is time to get rid of this corrupt agency and start over again with a flat or fair tax system.',
      disclaimer_text: 'Paid for by Texans for John Cornyn'
    };
    return $scope.sample_page_template = function() {
      return "/client_views/" + $scope.settings.layout.url_fragment + "/signature_template";
    };
  };

}).call(this);
(function() {

  this.SidebarController = function($scope, $rootScope, Util) {
    window.scope = $scope;
    $scope.client = {};
    return $scope.new_campaign = function() {
      return Util.navigate('/setup');
    };
  };

  SidebarController.$inject = ['$scope', '$rootScope', 'Util'];

}).call(this);
(function() {

  this.TweetController = function($scope, $rootScope) {};

}).call(this);

/*
@see http://docs.angularjs.org/guide/concepts
@see http://docs.angularjs.org/api/ng.directive:ngModel.NgModelController
@see https://github.com/angular/angular.js/issues/528#issuecomment-7573166
*/


(function() {

  angular.module("contenteditable", []).directive("contenteditable", [
    "$timeout", function($timeout) {
      return {
        restrict: "A",
        require: "?ngModel",
        link: function($scope, $element, attrs, ngModel) {
          var oldRender;
          if (!ngModel) {
            return;
          }
          if (!$scope.is_admin) {
            $element.removeAttr('contenteditable');
          }
          $element.bind("input", function(e) {
            return $scope.$apply(function() {
              var html, html2, rerender;
              html = void 0;
              html2 = void 0;
              rerender = void 0;
              html = $element.html();
              rerender = false;
              if (attrs.stripBr && attrs.stripBr !== "false") {
                html = html.replace(/<br>$/, "");
              }
              html = html.replace(/<br>/g, "<br><br>");
              html = html.replace(/<div>/g, "").replace(/<\/div>/g, "");
              if (attrs.noLineBreaks && attrs.noLineBreaks !== "false") {
                html2 = html.replace(/<div>/g, "").replace(/<br>/g, "").replace(/<\/div>/g, "");
                if (html2 !== html) {
                  rerender = true;
                  html = html2;
                }
              }
              ngModel.$setViewValue(html);
              if (rerender) {
                ngModel.$render();
              }
              if (html === "") {
                $element.addClass("placeholder-showing");
                return $timeout(function() {
                  $element[0].blur();
                  return $element[0].focus();
                });
              } else {
                return $element.removeClass("placeholder-showing");
              }
            });
          });
          oldRender = ngModel.$render;
          ngModel.$render = function() {
            var el, el2, range, sel;
            el = void 0;
            el2 = void 0;
            range = void 0;
            sel = void 0;
            if (!!oldRender) {
              oldRender();
            }
            $element.html(ngModel.$viewValue || "");
            el = $element[0];
            if ($element.html() === "") {
              $element.addClass("placeholder-showing");
              return $timeout(function() {
                $element[0].blur();
                return $element[0].focus();
              });
            } else {
              return $element.removeClass("placeholder-showing");
            }
          };
          if (attrs.selectNonEditable && attrs.selectNonEditable !== "false") {
            return $element.bind("click", function(e) {
              var range, sel, target;
              range = void 0;
              sel = void 0;
              target = void 0;
              target = e.toElement;
              if (target !== this && angular.element(target).attr("contenteditable") === "false") {
                range = document.createRange();
                sel = window.getSelection();
                range.setStartBefore(target);
                range.setEndAfter(target);
                sel.removeAllRanges();
                return sel.addRange(range);
              }
            });
          }
        }
      };
    }
  ]);

}).call(this);

/*
!
AngularJS file upload/drop directive with http post and progress
@author  Danial  <danial.farid@gmail.com>
@version 1.1.2
*/


(function() {

  (function() {
    var angularFileUpload;
    angularFileUpload = angular.module("angularFileUpload", []);
    angularFileUpload.service("$upload", [
      "$http", function($http) {
        return this.upload = function(config) {
          var formData, key, response;
          config.method = config.method || "POST";
          config.headers = config.headers || {};
          config.headers["Content-Type"] = undefined;
          config.transformRequest = angular.identity;
          formData = new FormData();
          if (config.data) {
            for (key in config.data) {
              formData.append(key, config.data[key]);
            }
          }
          formData.append(config.fileFormDataName || "file", config.file, config.file.name);
          formData["__uploadProgress_"] = function(e) {
            if (e) {
              return config.progress(e);
            }
          };
          config.data = formData;
          response = $http(config);
          response.abort = function() {
            throw "upload is not started yet";
          };
          formData["__setAbortFunction_"] = function(fn) {
            return response.abort = fn;
          };
          return response;
        };
      }
    ]);
    angularFileUpload.directive("ngFileSelect", [
      "$parse", "$http", function($parse, $http) {
        return function(scope, elem, attr) {
          var fileName, fn;
          fn = $parse(attr["ngFileSelect"]);
          fileName = attr["imageName"];
          elem.bind("change", function(evt) {
            var fileList, files, i;
            files = [];
            fileList = void 0;
            i = void 0;
            fileList = evt.target.files;
            if (fileList != null) {
              i = 0;
              while (i < fileList.length) {
                fileList.item(i).file_name = scope.imageName;
                files.push(fileList.item(i));
                i++;
              }
            }
            return scope.$parent.$apply(function() {
              return fn(scope.$parent, {
                $files: files,
                $event: evt
              });
            });
          });
          return elem.bind("click", function() {
            return this.value = null;
          });
        };
      }
    ]);
    angularFileUpload.directive("ngFileDropAvailable", [
      "$parse", "$http", function($parse, $http) {
        return function(scope, elem, attr) {
          var fn;
          if ("draggable" in document.createElement("span")) {
            fn = $parse(attr["ngFileDropAvailable"]);
            if (!scope.$$phase) {
              return scope.$apply(function() {
                return fn(scope);
              });
            } else {
              return fn(scope);
            }
          }
        };
      }
    ]);
    return angularFileUpload.directive("ngFileDrop", [
      "$parse", "$http", function($parse, $http) {
        return function(scope, elem, attr) {
          var fn;
          if ("draggable" in document.createElement("span")) {
            fn = $parse(attr["ngFileDrop"]);
            elem[0].addEventListener("dragover", (function(evt) {
              evt.stopPropagation();
              evt.preventDefault();
              return elem.addClass(attr["ngFileDragOverClass"] || "dragover");
            }), false);
            elem[0].addEventListener("dragleave", (function(evt) {
              return elem.removeClass(attr["ngFileDragOverClass"] || "dragover");
            }), false);
            return elem[0].addEventListener("drop", (function(evt) {
              var fileList, files, i;
              evt.stopPropagation();
              evt.preventDefault();
              elem.removeClass(attr["ngFileDragOverClass"] || "dragover");
              files = [];
              fileList = evt.dataTransfer.files;
              i = void 0;
              if (fileList != null) {
                i = 0;
                while (i < fileList.length) {
                  files.push(fileList.item(i));
                  i++;
                }
              }
              return scope.$apply(function() {
                return fn(scope, {
                  $files: files,
                  $event: evt
                });
              });
            }), false);
          }
        };
      }
    ]);
  })();

}).call(this);
(function() {

  this.app.directive("imageUploadOverlay", function() {
    return {
      restrict: "A",
      replace: false,
      transclude: true,
      scope: {
        imageName: '@',
        title: '@',
        notes: '@'
      },
      templateUrl: 'clients/partials/image_upload_overlay',
      link: function(scope, element, attr) {
        element.bind('mouseover', function() {
          var overlay;
          overlay = element.find(".image-upload-overlay");
          overlay.css('top', '-' + overlay.height() + 'px');
          return element.find(".image-upload-overlay").show();
        });
        return element.bind('mouseleave', function() {
          return element.find(".image-upload-overlay").hide();
        });
      }
    };
  });

}).call(this);
(function() {

  this.app.directive('panel', [
    '$timeout', '$window', function($timeout, $window) {
      var postLink;
      return {
        restrict: 'EA',
        templateUrl: 'clients/partials/panel',
        replace: false,
        scope: {
          petition: '='
        },
        link: postLink = function(scope, element, attrs) {
          var set_value;
          element.find('i').addClass(attrs.icon).addClass(attrs.color);
          element.find('.title').text(attrs.title);
          set_value = function() {
            return element.find('.value').text(scope.$eval(attrs.panel) || 0);
          };
          return scope.$watch('give_flow', function() {
            return set_value();
          });
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.directive("emHeightSource", [
    "$timeout", function($timeout) {
      return {
        link: function(scope, elem, attrs) {
          return scope.$watch(function() {
            return scope.__height = elem.height();
          });
        }
      };
    }
  ]);

  this.app.directive("sizeColumn", function() {
    return function(scope, element, attrs) {
      var equaliseHeight;
      attrs.$observe("equaliseHeightsDir", function(value) {
        var items;
        return items = angular.element(value);
      });
      equaliseHeight = function() {
        return element.parent().children().css("height", element.closest(".row").height());
      };
      equaliseHeight();
      return angular.element(window).resize(equaliseHeight);
    };
  });

}).call(this);
(function (module) {
     
    var fileReader = function ($q, $log) {
 
        var onLoad = function(reader, deferred, scope) {
            return function () {
                scope.$apply(function () {
                    deferred.resolve(reader.result);
                });
            };
        };
 
        var onError = function (reader, deferred, scope) {
            return function () {
                scope.$apply(function () {
                    deferred.reject(reader.result);
                });
            };
        };
 
        var onProgress = function(reader, scope) {
            return function (event) {
                scope.$broadcast("fileProgress",
                    {
                        total: event.total,
                        loaded: event.loaded
                    });
            };
        };
 
        var getReader = function(deferred, scope) {
            var reader = new FileReader();
            reader.onload = onLoad(reader, deferred, scope);
            reader.onerror = onError(reader, deferred, scope);
            reader.onprogress = onProgress(reader, scope);
            return reader;
        };
 
        var readAsDataURL = function (file, scope) {
            var deferred = $q.defer();
             
            var reader = getReader(deferred, scope);         
            reader.readAsDataURL(file);
             
            return deferred.promise;
        };
 
        return {
            readAsDataUrl: readAsDataURL  
        };
    };
 
    module.factory("fileReader",
                   ["$q", "$log", fileReader]);
 
}(app));
(function() {

  this.app.factory("PetitionServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get: function(client_id) {
          var deferred;
          console.log("Getting Petitions for client");
          deferred = $q.defer();
          $http.get('/api/clients/' + client_id + '/petitions').success(function(response) {
            return deferred.resolve(response);
          });
          return deferred.promise;
        },
        create: function(client_id, petition, signature_image, premium_image) {
          var data, files;
          data = {};
          data = $.extend(true, data, {
            'petition': petition
          });
          files = [];
          if (signature_image) {
            files.push({
              name: 'image',
              file: signature_image
            });
          }
          if (premium_image) {
            files.push({
              name: 'premium_image',
              file: premium_image
            });
          }
          return $http({
            method: 'POST',
            url: '/api/clients/' + client_id + '/petitions',
            headers: {
              "Content-Type": false
            },
            transformRequest: function(data) {
              var formData, i;
              formData = new FormData();
              formData.append("petition", angular.toJson(data.model.petition));
              i = 0;
              while (i < data.files.length) {
                formData.append("file_" + data.files[i].name, data.files[i].file);
                i++;
              }
              return formData;
            },
            data: {
              model: {
                'petition': petition
              },
              files: files
            }
          });
        },
        update: function(client_id, petition, signature_image, premium_image) {
          var data, files;
          data = {};
          data = $.extend(true, data, {
            'petition': petition
          });
          files = [];
          if (signature_image) {
            files.push({
              name: 'image',
              file: signature_image
            });
          }
          if (premium_image) {
            files.push({
              name: 'premium_image',
              file: premium_image
            });
          }
          return $http({
            method: 'PUT',
            url: '/api/clients/' + client_id + '/petitions/' + petition.id,
            headers: {
              "Content-Type": false
            },
            transformRequest: function(data) {
              var formData, i;
              formData = new FormData();
              formData.append("petition", angular.toJson(data.model.petition));
              i = 0;
              while (i < data.files.length) {
                formData.append("file_" + data.files[i].name, data.files[i].file);
                i++;
              }
              return formData;
            },
            data: {
              model: {
                'petition': petition
              },
              files: files
            }
          });
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.factory("ClientFactory", function() {
    return {
      petition: {},
      action_tags: {}
    };
  });

}).call(this);
(function() {
  var enable_dropmenu, toggle_sidebar;

  toggle_sidebar = function() {
    var content, icon, logo, sidebar;
    icon = $('#main-menu-toggle');
    sidebar = $('#sidebar-left');
    content = $('#content');
    logo = $('.brand');
    return icon.bind('click', function() {
      console.log('toggling sidebar');
      if (icon.hasClass('open')) {
        icon.removeClass('open').addClass('close');
        sidebar.hide();
      } else {
        icon.removeClass('close').addClass('open');
        sidebar.show();
      }
      content.toggleClass('full');
      return logo.toggleClass('noBg');
    });
  };

  enable_dropmenu = function() {
    return $('.dropmenu').bind('click', function(e) {
      e.preventDefault();
      return $(this).parent().find('ul').slideToggle();
    });
  };

  $(function() {
    toggle_sidebar();
    return enable_dropmenu();
  });

}).call(this);
(function() {

  this.app.factory("EmailTypeServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get_email_types: function() {
          var deferred;
          console.log("Getting Email Types");
          deferred = $q.defer();
          $http.get('/api/email_types').success(function(response) {
            return deferred.resolve(response);
          });
          return deferred.promise;
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.factory("LayoutServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get_layouts: function() {
          var deferred;
          console.log("Getting Layouts");
          deferred = $q.defer();
          $http.get('/api/layouts').success(function(response) {
            return deferred.resolve(response);
          });
          return deferred.promise;
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.factory("PageServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get_pages: function(layout_id) {
          var deferred;
          console.log("Getting Pages");
          deferred = $q.defer();
          $http.get('/api/pages?layout_id=' + layout_id).success(function(response) {
            return deferred.resolve(response);
          });
          return deferred.promise;
        }
      };
    }
  ]);

}).call(this);
(function() {

  this.app.factory("ThemeServices", [
    '$http', '$q', '$rootScope', function($http, $q, $rootScope) {
      return {
        get_themes: function(layout_id) {
          var deferred;
          console.log("Getting Themes");
          deferred = $q.defer();
          $http.get('/api/themes?layout_id=' + layout_id).success(function(response) {
            return deferred.resolve(response);
          });
          return deferred.promise;
        }
      };
    }
  ]);

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
            url += "#" + hash;
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
// moment.js
// version : 2.0.0
// author : Tim Wood
// license : MIT
// momentjs.com

(function (undefined) {

    /************************************
        Constants
    ************************************/

    var moment,
        VERSION = "2.0.0",
        round = Math.round, i,
        // internal storage for language config files
        languages = {},

        // check for nodeJS
        hasModule = (typeof module !== 'undefined' && module.exports),

        // ASP.NET json date format regex
        aspNetJsonRegex = /^\/?Date\((\-?\d+)/i,

        // format tokens
        formattingTokens = /(\[[^\[]*\])|(\\)?(Mo|MM?M?M?|Do|DDDo|DD?D?D?|ddd?d?|do?|w[o|w]?|W[o|W]?|YYYYY|YYYY|YY|a|A|hh?|HH?|mm?|ss?|SS?S?|X|zz?|ZZ?|.)/g,
        localFormattingTokens = /(\[[^\[]*\])|(\\)?(LT|LL?L?L?|l{1,4})/g,

        // parsing tokens
        parseMultipleFormatChunker = /([0-9a-zA-Z\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+)/gi,

        // parsing token regexes
        parseTokenOneOrTwoDigits = /\d\d?/, // 0 - 99
        parseTokenOneToThreeDigits = /\d{1,3}/, // 0 - 999
        parseTokenThreeDigits = /\d{3}/, // 000 - 999
        parseTokenFourDigits = /\d{1,4}/, // 0 - 9999
        parseTokenSixDigits = /[+\-]?\d{1,6}/, // -999,999 - 999,999
        parseTokenWord = /[0-9]*[a-z\u00A0-\u05FF\u0700-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]+|[\u0600-\u06FF]+\s*?[\u0600-\u06FF]+/i, // any word (or two) characters or numbers including two word month in arabic.
        parseTokenTimezone = /Z|[\+\-]\d\d:?\d\d/i, // +00:00 -00:00 +0000 -0000 or Z
        parseTokenT = /T/i, // T (ISO seperator)
        parseTokenTimestampMs = /[\+\-]?\d+(\.\d{1,3})?/, // 123456789 123456789.123

        // preliminary iso regex
        // 0000-00-00 + T + 00 or 00:00 or 00:00:00 or 00:00:00.000 + +00:00 or +0000
        isoRegex = /^\s*\d{4}-\d\d-\d\d((T| )(\d\d(:\d\d(:\d\d(\.\d\d?\d?)?)?)?)?([\+\-]\d\d:?\d\d)?)?/,
        isoFormat = 'YYYY-MM-DDTHH:mm:ssZ',

        // iso time formats and regexes
        isoTimes = [
            ['HH:mm:ss.S', /(T| )\d\d:\d\d:\d\d\.\d{1,3}/],
            ['HH:mm:ss', /(T| )\d\d:\d\d:\d\d/],
            ['HH:mm', /(T| )\d\d:\d\d/],
            ['HH', /(T| )\d\d/]
        ],

        // timezone chunker "+10:00" > ["10", "00"] or "-1530" > ["-15", "30"]
        parseTimezoneChunker = /([\+\-]|\d\d)/gi,

        // getter and setter names
        proxyGettersAndSetters = 'Month|Date|Hours|Minutes|Seconds|Milliseconds'.split('|'),
        unitMillisecondFactors = {
            'Milliseconds' : 1,
            'Seconds' : 1e3,
            'Minutes' : 6e4,
            'Hours' : 36e5,
            'Days' : 864e5,
            'Months' : 2592e6,
            'Years' : 31536e6
        },

        // format function strings
        formatFunctions = {},

        // tokens to ordinalize and pad
        ordinalizeTokens = 'DDD w W M D d'.split(' '),
        paddedTokens = 'M D H h m s w W'.split(' '),

        formatTokenFunctions = {
            M    : function () {
                return this.month() + 1;
            },
            MMM  : function (format) {
                return this.lang().monthsShort(this, format);
            },
            MMMM : function (format) {
                return this.lang().months(this, format);
            },
            D    : function () {
                return this.date();
            },
            DDD  : function () {
                return this.dayOfYear();
            },
            d    : function () {
                return this.day();
            },
            dd   : function (format) {
                return this.lang().weekdaysMin(this, format);
            },
            ddd  : function (format) {
                return this.lang().weekdaysShort(this, format);
            },
            dddd : function (format) {
                return this.lang().weekdays(this, format);
            },
            w    : function () {
                return this.week();
            },
            W    : function () {
                return this.isoWeek();
            },
            YY   : function () {
                return leftZeroFill(this.year() % 100, 2);
            },
            YYYY : function () {
                return leftZeroFill(this.year(), 4);
            },
            YYYYY : function () {
                return leftZeroFill(this.year(), 5);
            },
            a    : function () {
                return this.lang().meridiem(this.hours(), this.minutes(), true);
            },
            A    : function () {
                return this.lang().meridiem(this.hours(), this.minutes(), false);
            },
            H    : function () {
                return this.hours();
            },
            h    : function () {
                return this.hours() % 12 || 12;
            },
            m    : function () {
                return this.minutes();
            },
            s    : function () {
                return this.seconds();
            },
            S    : function () {
                return ~~(this.milliseconds() / 100);
            },
            SS   : function () {
                return leftZeroFill(~~(this.milliseconds() / 10), 2);
            },
            SSS  : function () {
                return leftZeroFill(this.milliseconds(), 3);
            },
            Z    : function () {
                var a = -this.zone(),
                    b = "+";
                if (a < 0) {
                    a = -a;
                    b = "-";
                }
                return b + leftZeroFill(~~(a / 60), 2) + ":" + leftZeroFill(~~a % 60, 2);
            },
            ZZ   : function () {
                var a = -this.zone(),
                    b = "+";
                if (a < 0) {
                    a = -a;
                    b = "-";
                }
                return b + leftZeroFill(~~(10 * a / 6), 4);
            },
            X    : function () {
                return this.unix();
            }
        };

    function padToken(func, count) {
        return function (a) {
            return leftZeroFill(func.call(this, a), count);
        };
    }
    function ordinalizeToken(func) {
        return function (a) {
            return this.lang().ordinal(func.call(this, a));
        };
    }

    while (ordinalizeTokens.length) {
        i = ordinalizeTokens.pop();
        formatTokenFunctions[i + 'o'] = ordinalizeToken(formatTokenFunctions[i]);
    }
    while (paddedTokens.length) {
        i = paddedTokens.pop();
        formatTokenFunctions[i + i] = padToken(formatTokenFunctions[i], 2);
    }
    formatTokenFunctions.DDDD = padToken(formatTokenFunctions.DDD, 3);


    /************************************
        Constructors
    ************************************/

    function Language() {

    }

    // Moment prototype object
    function Moment(config) {
        extend(this, config);
    }

    // Duration Constructor
    function Duration(duration) {
        var data = this._data = {},
            years = duration.years || duration.year || duration.y || 0,
            months = duration.months || duration.month || duration.M || 0,
            weeks = duration.weeks || duration.week || duration.w || 0,
            days = duration.days || duration.day || duration.d || 0,
            hours = duration.hours || duration.hour || duration.h || 0,
            minutes = duration.minutes || duration.minute || duration.m || 0,
            seconds = duration.seconds || duration.second || duration.s || 0,
            milliseconds = duration.milliseconds || duration.millisecond || duration.ms || 0;

        // representation for dateAddRemove
        this._milliseconds = milliseconds +
            seconds * 1e3 + // 1000
            minutes * 6e4 + // 1000 * 60
            hours * 36e5; // 1000 * 60 * 60
        // Because of dateAddRemove treats 24 hours as different from a
        // day when working around DST, we need to store them separately
        this._days = days +
            weeks * 7;
        // It is impossible translate months into days without knowing
        // which months you are are talking about, so we have to store
        // it separately.
        this._months = months +
            years * 12;

        // The following code bubbles up values, see the tests for
        // examples of what that means.
        data.milliseconds = milliseconds % 1000;
        seconds += absRound(milliseconds / 1000);

        data.seconds = seconds % 60;
        minutes += absRound(seconds / 60);

        data.minutes = minutes % 60;
        hours += absRound(minutes / 60);

        data.hours = hours % 24;
        days += absRound(hours / 24);

        days += weeks * 7;
        data.days = days % 30;

        months += absRound(days / 30);

        data.months = months % 12;
        years += absRound(months / 12);

        data.years = years;
    }


    /************************************
        Helpers
    ************************************/


    function extend(a, b) {
        for (var i in b) {
            if (b.hasOwnProperty(i)) {
                a[i] = b[i];
            }
        }
        return a;
    }

    function absRound(number) {
        if (number < 0) {
            return Math.ceil(number);
        } else {
            return Math.floor(number);
        }
    }

    // left zero fill a number
    // see http://jsperf.com/left-zero-filling for performance comparison
    function leftZeroFill(number, targetLength) {
        var output = number + '';
        while (output.length < targetLength) {
            output = '0' + output;
        }
        return output;
    }

    // helper function for _.addTime and _.subtractTime
    function addOrSubtractDurationFromMoment(mom, duration, isAdding) {
        var ms = duration._milliseconds,
            d = duration._days,
            M = duration._months,
            currentDate;

        if (ms) {
            mom._d.setTime(+mom + ms * isAdding);
        }
        if (d) {
            mom.date(mom.date() + d * isAdding);
        }
        if (M) {
            currentDate = mom.date();
            mom.date(1)
                .month(mom.month() + M * isAdding)
                .date(Math.min(currentDate, mom.daysInMonth()));
        }
    }

    // check if is an array
    function isArray(input) {
        return Object.prototype.toString.call(input) === '[object Array]';
    }

    // compare two arrays, return the number of differences
    function compareArrays(array1, array2) {
        var len = Math.min(array1.length, array2.length),
            lengthDiff = Math.abs(array1.length - array2.length),
            diffs = 0,
            i;
        for (i = 0; i < len; i++) {
            if (~~array1[i] !== ~~array2[i]) {
                diffs++;
            }
        }
        return diffs + lengthDiff;
    }


    /************************************
        Languages
    ************************************/


    Language.prototype = {
        set : function (config) {
            var prop, i;
            for (i in config) {
                prop = config[i];
                if (typeof prop === 'function') {
                    this[i] = prop;
                } else {
                    this['_' + i] = prop;
                }
            }
        },

        _months : "January_February_March_April_May_June_July_August_September_October_November_December".split("_"),
        months : function (m) {
            return this._months[m.month()];
        },

        _monthsShort : "Jan_Feb_Mar_Apr_May_Jun_Jul_Aug_Sep_Oct_Nov_Dec".split("_"),
        monthsShort : function (m) {
            return this._monthsShort[m.month()];
        },

        monthsParse : function (monthName) {
            var i, mom, regex, output;

            if (!this._monthsParse) {
                this._monthsParse = [];
            }

            for (i = 0; i < 12; i++) {
                // make the regex if we don't have it already
                if (!this._monthsParse[i]) {
                    mom = moment([2000, i]);
                    regex = '^' + this.months(mom, '') + '|^' + this.monthsShort(mom, '');
                    this._monthsParse[i] = new RegExp(regex.replace('.', ''), 'i');
                }
                // test the regex
                if (this._monthsParse[i].test(monthName)) {
                    return i;
                }
            }
        },

        _weekdays : "Sunday_Monday_Tuesday_Wednesday_Thursday_Friday_Saturday".split("_"),
        weekdays : function (m) {
            return this._weekdays[m.day()];
        },

        _weekdaysShort : "Sun_Mon_Tue_Wed_Thu_Fri_Sat".split("_"),
        weekdaysShort : function (m) {
            return this._weekdaysShort[m.day()];
        },

        _weekdaysMin : "Su_Mo_Tu_We_Th_Fr_Sa".split("_"),
        weekdaysMin : function (m) {
            return this._weekdaysMin[m.day()];
        },

        _longDateFormat : {
            LT : "h:mm A",
            L : "MM/DD/YYYY",
            LL : "MMMM D YYYY",
            LLL : "MMMM D YYYY LT",
            LLLL : "dddd, MMMM D YYYY LT"
        },
        longDateFormat : function (key) {
            var output = this._longDateFormat[key];
            if (!output && this._longDateFormat[key.toUpperCase()]) {
                output = this._longDateFormat[key.toUpperCase()].replace(/MMMM|MM|DD|dddd/g, function (val) {
                    return val.slice(1);
                });
                this._longDateFormat[key] = output;
            }
            return output;
        },

        meridiem : function (hours, minutes, isLower) {
            if (hours > 11) {
                return isLower ? 'pm' : 'PM';
            } else {
                return isLower ? 'am' : 'AM';
            }
        },

        _calendar : {
            sameDay : '[Today at] LT',
            nextDay : '[Tomorrow at] LT',
            nextWeek : 'dddd [at] LT',
            lastDay : '[Yesterday at] LT',
            lastWeek : '[last] dddd [at] LT',
            sameElse : 'L'
        },
        calendar : function (key, mom) {
            var output = this._calendar[key];
            return typeof output === 'function' ? output.apply(mom) : output;
        },

        _relativeTime : {
            future : "in %s",
            past : "%s ago",
            s : "a few seconds",
            m : "a minute",
            mm : "%d minutes",
            h : "an hour",
            hh : "%d hours",
            d : "a day",
            dd : "%d days",
            M : "a month",
            MM : "%d months",
            y : "a year",
            yy : "%d years"
        },
        relativeTime : function (number, withoutSuffix, string, isFuture) {
            var output = this._relativeTime[string];
            return (typeof output === 'function') ?
                output(number, withoutSuffix, string, isFuture) :
                output.replace(/%d/i, number);
        },
        pastFuture : function (diff, output) {
            var format = this._relativeTime[diff > 0 ? 'future' : 'past'];
            return typeof format === 'function' ? format(output) : format.replace(/%s/i, output);
        },

        ordinal : function (number) {
            return this._ordinal.replace("%d", number);
        },
        _ordinal : "%d",

        preparse : function (string) {
            return string;
        },

        postformat : function (string) {
            return string;
        },

        week : function (mom) {
            return weekOfYear(mom, this._week.dow, this._week.doy);
        },
        _week : {
            dow : 0, // Sunday is the first day of the week.
            doy : 6  // The week that contains Jan 1st is the first week of the year.
        }
    };

    // Loads a language definition into the `languages` cache.  The function
    // takes a key and optionally values.  If not in the browser and no values
    // are provided, it will load the language file module.  As a convenience,
    // this function also returns the language values.
    function loadLang(key, values) {
        values.abbr = key;
        if (!languages[key]) {
            languages[key] = new Language();
        }
        languages[key].set(values);
        return languages[key];
    }

    // Determines which language definition to use and returns it.
    //
    // With no parameters, it will return the global language.  If you
    // pass in a language key, such as 'en', it will return the
    // definition for 'en', so long as 'en' has already been loaded using
    // moment.lang.
    function getLangDefinition(key) {
        if (!key) {
            return moment.fn._lang;
        }
        if (!languages[key] && hasModule) {
            require('./lang/' + key);
        }
        return languages[key];
    }


    /************************************
        Formatting
    ************************************/


    function removeFormattingTokens(input) {
        if (input.match(/\[.*\]/)) {
            return input.replace(/^\[|\]$/g, "");
        }
        return input.replace(/\\/g, "");
    }

    function makeFormatFunction(format) {
        var array = format.match(formattingTokens), i, length;

        for (i = 0, length = array.length; i < length; i++) {
            if (formatTokenFunctions[array[i]]) {
                array[i] = formatTokenFunctions[array[i]];
            } else {
                array[i] = removeFormattingTokens(array[i]);
            }
        }

        return function (mom) {
            var output = "";
            for (i = 0; i < length; i++) {
                output += typeof array[i].call === 'function' ? array[i].call(mom, format) : array[i];
            }
            return output;
        };
    }

    // format date using native date object
    function formatMoment(m, format) {
        var i = 5;

        function replaceLongDateFormatTokens(input) {
            return m.lang().longDateFormat(input) || input;
        }

        while (i-- && localFormattingTokens.test(format)) {
            format = format.replace(localFormattingTokens, replaceLongDateFormatTokens);
        }

        if (!formatFunctions[format]) {
            formatFunctions[format] = makeFormatFunction(format);
        }

        return formatFunctions[format](m);
    }


    /************************************
        Parsing
    ************************************/


    // get the regex to find the next token
    function getParseRegexForToken(token) {
        switch (token) {
        case 'DDDD':
            return parseTokenThreeDigits;
        case 'YYYY':
            return parseTokenFourDigits;
        case 'YYYYY':
            return parseTokenSixDigits;
        case 'S':
        case 'SS':
        case 'SSS':
        case 'DDD':
            return parseTokenOneToThreeDigits;
        case 'MMM':
        case 'MMMM':
        case 'dd':
        case 'ddd':
        case 'dddd':
        case 'a':
        case 'A':
            return parseTokenWord;
        case 'X':
            return parseTokenTimestampMs;
        case 'Z':
        case 'ZZ':
            return parseTokenTimezone;
        case 'T':
            return parseTokenT;
        case 'MM':
        case 'DD':
        case 'YY':
        case 'HH':
        case 'hh':
        case 'mm':
        case 'ss':
        case 'M':
        case 'D':
        case 'd':
        case 'H':
        case 'h':
        case 'm':
        case 's':
            return parseTokenOneOrTwoDigits;
        default :
            return new RegExp(token.replace('\\', ''));
        }
    }

    // function to convert string input to date
    function addTimeToArrayFromToken(token, input, config) {
        var a, b,
            datePartArray = config._a;

        switch (token) {
        // MONTH
        case 'M' : // fall through to MM
        case 'MM' :
            datePartArray[1] = (input == null) ? 0 : ~~input - 1;
            break;
        case 'MMM' : // fall through to MMMM
        case 'MMMM' :
            a = getLangDefinition(config._l).monthsParse(input);
            // if we didn't find a month name, mark the date as invalid.
            if (a != null) {
                datePartArray[1] = a;
            } else {
                config._isValid = false;
            }
            break;
        // DAY OF MONTH
        case 'D' : // fall through to DDDD
        case 'DD' : // fall through to DDDD
        case 'DDD' : // fall through to DDDD
        case 'DDDD' :
            if (input != null) {
                datePartArray[2] = ~~input;
            }
            break;
        // YEAR
        case 'YY' :
            datePartArray[0] = ~~input + (~~input > 68 ? 1900 : 2000);
            break;
        case 'YYYY' :
        case 'YYYYY' :
            datePartArray[0] = ~~input;
            break;
        // AM / PM
        case 'a' : // fall through to A
        case 'A' :
            config._isPm = ((input + '').toLowerCase() === 'pm');
            break;
        // 24 HOUR
        case 'H' : // fall through to hh
        case 'HH' : // fall through to hh
        case 'h' : // fall through to hh
        case 'hh' :
            datePartArray[3] = ~~input;
            break;
        // MINUTE
        case 'm' : // fall through to mm
        case 'mm' :
            datePartArray[4] = ~~input;
            break;
        // SECOND
        case 's' : // fall through to ss
        case 'ss' :
            datePartArray[5] = ~~input;
            break;
        // MILLISECOND
        case 'S' :
        case 'SS' :
        case 'SSS' :
            datePartArray[6] = ~~ (('0.' + input) * 1000);
            break;
        // UNIX TIMESTAMP WITH MS
        case 'X':
            config._d = new Date(parseFloat(input) * 1000);
            break;
        // TIMEZONE
        case 'Z' : // fall through to ZZ
        case 'ZZ' :
            config._useUTC = true;
            a = (input + '').match(parseTimezoneChunker);
            if (a && a[1]) {
                config._tzh = ~~a[1];
            }
            if (a && a[2]) {
                config._tzm = ~~a[2];
            }
            // reverse offsets
            if (a && a[0] === '+') {
                config._tzh = -config._tzh;
                config._tzm = -config._tzm;
            }
            break;
        }

        // if the input is null, the date is not valid
        if (input == null) {
            config._isValid = false;
        }
    }

    // convert an array to a date.
    // the array should mirror the parameters below
    // note: all values past the year are optional and will default to the lowest possible value.
    // [year, month, day , hour, minute, second, millisecond]
    function dateFromArray(config) {
        var i, date, input = [];

        if (config._d) {
            return;
        }

        for (i = 0; i < 7; i++) {
            config._a[i] = input[i] = (config._a[i] == null) ? (i === 2 ? 1 : 0) : config._a[i];
        }

        // add the offsets to the time to be parsed so that we can have a clean array for checking isValid
        input[3] += config._tzh || 0;
        input[4] += config._tzm || 0;

        date = new Date(0);

        if (config._useUTC) {
            date.setUTCFullYear(input[0], input[1], input[2]);
            date.setUTCHours(input[3], input[4], input[5], input[6]);
        } else {
            date.setFullYear(input[0], input[1], input[2]);
            date.setHours(input[3], input[4], input[5], input[6]);
        }

        config._d = date;
    }

    // date from string and format string
    function makeDateFromStringAndFormat(config) {
        // This array is used to make a Date, either with `new Date` or `Date.UTC`
        var tokens = config._f.match(formattingTokens),
            string = config._i,
            i, parsedInput;

        config._a = [];

        for (i = 0; i < tokens.length; i++) {
            parsedInput = (getParseRegexForToken(tokens[i]).exec(string) || [])[0];
            if (parsedInput) {
                string = string.slice(string.indexOf(parsedInput) + parsedInput.length);
            }
            // don't parse if its not a known token
            if (formatTokenFunctions[tokens[i]]) {
                addTimeToArrayFromToken(tokens[i], parsedInput, config);
            }
        }
        // handle am pm
        if (config._isPm && config._a[3] < 12) {
            config._a[3] += 12;
        }
        // if is 12 am, change hours to 0
        if (config._isPm === false && config._a[3] === 12) {
            config._a[3] = 0;
        }
        // return
        dateFromArray(config);
    }

    // date from string and array of format strings
    function makeDateFromStringAndArray(config) {
        var tempConfig,
            tempMoment,
            bestMoment,

            scoreToBeat = 99,
            i,
            currentDate,
            currentScore;

        while (config._f.length) {
            tempConfig = extend({}, config);
            tempConfig._f = config._f.pop();
            makeDateFromStringAndFormat(tempConfig);
            tempMoment = new Moment(tempConfig);

            if (tempMoment.isValid()) {
                bestMoment = tempMoment;
                break;
            }

            currentScore = compareArrays(tempConfig._a, tempMoment.toArray());

            if (currentScore < scoreToBeat) {
                scoreToBeat = currentScore;
                bestMoment = tempMoment;
            }
        }

        extend(config, bestMoment);
    }

    // date from iso format
    function makeDateFromString(config) {
        var i,
            string = config._i;
        if (isoRegex.exec(string)) {
            config._f = 'YYYY-MM-DDT';
            for (i = 0; i < 4; i++) {
                if (isoTimes[i][1].exec(string)) {
                    config._f += isoTimes[i][0];
                    break;
                }
            }
            if (parseTokenTimezone.exec(string)) {
                config._f += " Z";
            }
            makeDateFromStringAndFormat(config);
        } else {
            config._d = new Date(string);
        }
    }

    function makeDateFromInput(config) {
        var input = config._i,
            matched = aspNetJsonRegex.exec(input);

        if (input === undefined) {
            config._d = new Date();
        } else if (matched) {
            config._d = new Date(+matched[1]);
        } else if (typeof input === 'string') {
            makeDateFromString(config);
        } else if (isArray(input)) {
            config._a = input.slice(0);
            dateFromArray(config);
        } else {
            config._d = input instanceof Date ? new Date(+input) : new Date(input);
        }
    }


    /************************************
        Relative Time
    ************************************/


    // helper function for moment.fn.from, moment.fn.fromNow, and moment.duration.fn.humanize
    function substituteTimeAgo(string, number, withoutSuffix, isFuture, lang) {
        return lang.relativeTime(number || 1, !!withoutSuffix, string, isFuture);
    }

    function relativeTime(milliseconds, withoutSuffix, lang) {
        var seconds = round(Math.abs(milliseconds) / 1000),
            minutes = round(seconds / 60),
            hours = round(minutes / 60),
            days = round(hours / 24),
            years = round(days / 365),
            args = seconds < 45 && ['s', seconds] ||
                minutes === 1 && ['m'] ||
                minutes < 45 && ['mm', minutes] ||
                hours === 1 && ['h'] ||
                hours < 22 && ['hh', hours] ||
                days === 1 && ['d'] ||
                days <= 25 && ['dd', days] ||
                days <= 45 && ['M'] ||
                days < 345 && ['MM', round(days / 30)] ||
                years === 1 && ['y'] || ['yy', years];
        args[2] = withoutSuffix;
        args[3] = milliseconds > 0;
        args[4] = lang;
        return substituteTimeAgo.apply({}, args);
    }


    /************************************
        Week of Year
    ************************************/


    // firstDayOfWeek       0 = sun, 6 = sat
    //                      the day of the week that starts the week
    //                      (usually sunday or monday)
    // firstDayOfWeekOfYear 0 = sun, 6 = sat
    //                      the first week is the week that contains the first
    //                      of this day of the week
    //                      (eg. ISO weeks use thursday (4))
    function weekOfYear(mom, firstDayOfWeek, firstDayOfWeekOfYear) {
        var end = firstDayOfWeekOfYear - firstDayOfWeek,
            daysToDayOfWeek = firstDayOfWeekOfYear - mom.day();


        if (daysToDayOfWeek > end) {
            daysToDayOfWeek -= 7;
        }

        if (daysToDayOfWeek < end - 7) {
            daysToDayOfWeek += 7;
        }

        return Math.ceil(moment(mom).add('d', daysToDayOfWeek).dayOfYear() / 7);
    }


    /************************************
        Top Level Functions
    ************************************/

    function makeMoment(config) {
        var input = config._i,
            format = config._f;

        if (input === null || input === '') {
            return null;
        }

        if (typeof input === 'string') {
            config._i = input = getLangDefinition().preparse(input);
        }

        if (moment.isMoment(input)) {
            config = extend({}, input);
            config._d = new Date(+input._d);
        } else if (format) {
            if (isArray(format)) {
                makeDateFromStringAndArray(config);
            } else {
                makeDateFromStringAndFormat(config);
            }
        } else {
            makeDateFromInput(config);
        }

        return new Moment(config);
    }

    moment = function (input, format, lang) {
        return makeMoment({
            _i : input,
            _f : format,
            _l : lang,
            _isUTC : false
        });
    };

    // creating with utc
    moment.utc = function (input, format, lang) {
        return makeMoment({
            _useUTC : true,
            _isUTC : true,
            _l : lang,
            _i : input,
            _f : format
        });
    };

    // creating with unix timestamp (in seconds)
    moment.unix = function (input) {
        return moment(input * 1000);
    };

    // duration
    moment.duration = function (input, key) {
        var isDuration = moment.isDuration(input),
            isNumber = (typeof input === 'number'),
            duration = (isDuration ? input._data : (isNumber ? {} : input)),
            ret;

        if (isNumber) {
            if (key) {
                duration[key] = input;
            } else {
                duration.milliseconds = input;
            }
        }

        ret = new Duration(duration);

        if (isDuration && input.hasOwnProperty('_lang')) {
            ret._lang = input._lang;
        }

        return ret;
    };

    // version number
    moment.version = VERSION;

    // default format
    moment.defaultFormat = isoFormat;

    // This function will load languages and then set the global language.  If
    // no arguments are passed in, it will simply return the current global
    // language key.
    moment.lang = function (key, values) {
        var i;

        if (!key) {
            return moment.fn._lang._abbr;
        }
        if (values) {
            loadLang(key, values);
        } else if (!languages[key]) {
            getLangDefinition(key);
        }
        moment.duration.fn._lang = moment.fn._lang = getLangDefinition(key);
    };

    // returns language data
    moment.langData = function (key) {
        if (key && key._lang && key._lang._abbr) {
            key = key._lang._abbr;
        }
        return getLangDefinition(key);
    };

    // compare moment object
    moment.isMoment = function (obj) {
        return obj instanceof Moment;
    };

    // for typechecking Duration objects
    moment.isDuration = function (obj) {
        return obj instanceof Duration;
    };


    /************************************
        Moment Prototype
    ************************************/


    moment.fn = Moment.prototype = {

        clone : function () {
            return moment(this);
        },

        valueOf : function () {
            return +this._d;
        },

        unix : function () {
            return Math.floor(+this._d / 1000);
        },

        toString : function () {
            return this.format("ddd MMM DD YYYY HH:mm:ss [GMT]ZZ");
        },

        toDate : function () {
            return this._d;
        },

        toJSON : function () {
            return moment.utc(this).format('YYYY-MM-DD[T]HH:mm:ss.SSS[Z]');
        },

        toArray : function () {
            var m = this;
            return [
                m.year(),
                m.month(),
                m.date(),
                m.hours(),
                m.minutes(),
                m.seconds(),
                m.milliseconds()
            ];
        },

        isValid : function () {
            if (this._isValid == null) {
                if (this._a) {
                    this._isValid = !compareArrays(this._a, (this._isUTC ? moment.utc(this._a) : moment(this._a)).toArray());
                } else {
                    this._isValid = !isNaN(this._d.getTime());
                }
            }
            return !!this._isValid;
        },

        utc : function () {
            this._isUTC = true;
            return this;
        },

        local : function () {
            this._isUTC = false;
            return this;
        },

        format : function (inputString) {
            var output = formatMoment(this, inputString || moment.defaultFormat);
            return this.lang().postformat(output);
        },

        add : function (input, val) {
            var dur;
            // switch args to support add('s', 1) and add(1, 's')
            if (typeof input === 'string') {
                dur = moment.duration(+val, input);
            } else {
                dur = moment.duration(input, val);
            }
            addOrSubtractDurationFromMoment(this, dur, 1);
            return this;
        },

        subtract : function (input, val) {
            var dur;
            // switch args to support subtract('s', 1) and subtract(1, 's')
            if (typeof input === 'string') {
                dur = moment.duration(+val, input);
            } else {
                dur = moment.duration(input, val);
            }
            addOrSubtractDurationFromMoment(this, dur, -1);
            return this;
        },

        diff : function (input, units, asFloat) {
            var that = this._isUTC ? moment(input).utc() : moment(input).local(),
                zoneDiff = (this.zone() - that.zone()) * 6e4,
                diff, output;

            if (units) {
                // standardize on singular form
                units = units.replace(/s$/, '');
            }

            if (units === 'year' || units === 'month') {
                diff = (this.daysInMonth() + that.daysInMonth()) * 432e5; // 24 * 60 * 60 * 1000 / 2
                output = ((this.year() - that.year()) * 12) + (this.month() - that.month());
                output += ((this - moment(this).startOf('month')) - (that - moment(that).startOf('month'))) / diff;
                if (units === 'year') {
                    output = output / 12;
                }
            } else {
                diff = (this - that) - zoneDiff;
                output = units === 'second' ? diff / 1e3 : // 1000
                    units === 'minute' ? diff / 6e4 : // 1000 * 60
                    units === 'hour' ? diff / 36e5 : // 1000 * 60 * 60
                    units === 'day' ? diff / 864e5 : // 1000 * 60 * 60 * 24
                    units === 'week' ? diff / 6048e5 : // 1000 * 60 * 60 * 24 * 7
                    diff;
            }
            return asFloat ? output : absRound(output);
        },

        from : function (time, withoutSuffix) {
            return moment.duration(this.diff(time)).lang(this.lang()._abbr).humanize(!withoutSuffix);
        },

        fromNow : function (withoutSuffix) {
            return this.from(moment(), withoutSuffix);
        },

        calendar : function () {
            var diff = this.diff(moment().startOf('day'), 'days', true),
                format = diff < -6 ? 'sameElse' :
                diff < -1 ? 'lastWeek' :
                diff < 0 ? 'lastDay' :
                diff < 1 ? 'sameDay' :
                diff < 2 ? 'nextDay' :
                diff < 7 ? 'nextWeek' : 'sameElse';
            return this.format(this.lang().calendar(format, this));
        },

        isLeapYear : function () {
            var year = this.year();
            return (year % 4 === 0 && year % 100 !== 0) || year % 400 === 0;
        },

        isDST : function () {
            return (this.zone() < moment([this.year()]).zone() ||
                this.zone() < moment([this.year(), 5]).zone());
        },

        day : function (input) {
            var day = this._isUTC ? this._d.getUTCDay() : this._d.getDay();
            return input == null ? day :
                this.add({ d : input - day });
        },

        startOf: function (units) {
            units = units.replace(/s$/, '');
            // the following switch intentionally omits break keywords
            // to utilize falling through the cases.
            switch (units) {
            case 'year':
                this.month(0);
                /* falls through */
            case 'month':
                this.date(1);
                /* falls through */
            case 'week':
            case 'day':
                this.hours(0);
                /* falls through */
            case 'hour':
                this.minutes(0);
                /* falls through */
            case 'minute':
                this.seconds(0);
                /* falls through */
            case 'second':
                this.milliseconds(0);
                /* falls through */
            }

            // weeks are a special case
            if (units === 'week') {
                this.day(0);
            }

            return this;
        },

        endOf: function (units) {
            return this.startOf(units).add(units.replace(/s?$/, 's'), 1).subtract('ms', 1);
        },

        isAfter: function (input, units) {
            units = typeof units !== 'undefined' ? units : 'millisecond';
            return +this.clone().startOf(units) > +moment(input).startOf(units);
        },

        isBefore: function (input, units) {
            units = typeof units !== 'undefined' ? units : 'millisecond';
            return +this.clone().startOf(units) < +moment(input).startOf(units);
        },

        isSame: function (input, units) {
            units = typeof units !== 'undefined' ? units : 'millisecond';
            return +this.clone().startOf(units) === +moment(input).startOf(units);
        },

        zone : function () {
            return this._isUTC ? 0 : this._d.getTimezoneOffset();
        },

        daysInMonth : function () {
            return moment.utc([this.year(), this.month() + 1, 0]).date();
        },

        dayOfYear : function (input) {
            var dayOfYear = round((moment(this).startOf('day') - moment(this).startOf('year')) / 864e5) + 1;
            return input == null ? dayOfYear : this.add("d", (input - dayOfYear));
        },

        isoWeek : function (input) {
            var week = weekOfYear(this, 1, 4);
            return input == null ? week : this.add("d", (input - week) * 7);
        },

        week : function (input) {
            var week = this.lang().week(this);
            return input == null ? week : this.add("d", (input - week) * 7);
        },

        // If passed a language key, it will set the language for this
        // instance.  Otherwise, it will return the language configuration
        // variables for this instance.
        lang : function (key) {
            if (key === undefined) {
                return this._lang;
            } else {
                this._lang = getLangDefinition(key);
                return this;
            }
        }
    };

    // helper for adding shortcuts
    function makeGetterAndSetter(name, key) {
        moment.fn[name] = moment.fn[name + 's'] = function (input) {
            var utc = this._isUTC ? 'UTC' : '';
            if (input != null) {
                this._d['set' + utc + key](input);
                return this;
            } else {
                return this._d['get' + utc + key]();
            }
        };
    }

    // loop through and add shortcuts (Month, Date, Hours, Minutes, Seconds, Milliseconds)
    for (i = 0; i < proxyGettersAndSetters.length; i ++) {
        makeGetterAndSetter(proxyGettersAndSetters[i].toLowerCase().replace(/s$/, ''), proxyGettersAndSetters[i]);
    }

    // add shortcut for year (uses different syntax than the getter/setter 'year' == 'FullYear')
    makeGetterAndSetter('year', 'FullYear');

    // add plural methods
    moment.fn.days = moment.fn.day;
    moment.fn.weeks = moment.fn.week;
    moment.fn.isoWeeks = moment.fn.isoWeek;

    /************************************
        Duration Prototype
    ************************************/


    moment.duration.fn = Duration.prototype = {
        weeks : function () {
            return absRound(this.days() / 7);
        },

        valueOf : function () {
            return this._milliseconds +
              this._days * 864e5 +
              this._months * 2592e6;
        },

        humanize : function (withSuffix) {
            var difference = +this,
                output = relativeTime(difference, !withSuffix, this.lang());

            if (withSuffix) {
                output = this.lang().pastFuture(difference, output);
            }

            return this.lang().postformat(output);
        },

        lang : moment.fn.lang
    };

    function makeDurationGetter(name) {
        moment.duration.fn[name] = function () {
            return this._data[name];
        };
    }

    function makeDurationAsGetter(name, factor) {
        moment.duration.fn['as' + name] = function () {
            return +this / factor;
        };
    }

    for (i in unitMillisecondFactors) {
        if (unitMillisecondFactors.hasOwnProperty(i)) {
            makeDurationAsGetter(i, unitMillisecondFactors[i]);
            makeDurationGetter(i.toLowerCase());
        }
    }

    makeDurationAsGetter('Weeks', 6048e5);


    /************************************
        Default Lang
    ************************************/


    // Set default language, other languages will inherit from English.
    moment.lang('en', {
        ordinal : function (number) {
            var b = number % 10,
                output = (~~ (number % 100 / 10) === 1) ? 'th' :
                (b === 1) ? 'st' :
                (b === 2) ? 'nd' :
                (b === 3) ? 'rd' : 'th';
            return number + output;
        }
    });


    /************************************
        Exposing Moment
    ************************************/


    // CommonJS module is defined
    if (hasModule) {
        module.exports = moment;
    }
    /*global ender:false */
    if (typeof ender === 'undefined') {
        // here, `this` means `window` in the browser, or `global` on the server
        // add `moment` as a global object via a string identifier,
        // for Closure Compiler "advanced" mode
        this['moment'] = moment;
    }
    /*global define:false */
    if (typeof define === "function" && define.amd) {
        define("moment", [], function () {
            return moment;
        });
    }
}).call(this);
angular.module("toggle-switch",["ng"]).directive("toggleSwitch",function(){return{restrict:"EA",replace:!0,scope:{model:"=",onLabel:"@",offLabel:"@",knobLabel:"@"},template:'<div class="switch" ng-click="toggle()"><div ng-class="{\'switch-off\': !model, \'switch-on\': model}"><span class="switch-left" ng-bind="onLabel">On</span><span class="knob" ng-bind="knobLabel">&nbsp;</span><span class="switch-right" ng-bind="offLabel">Off</span></div></div>',link:function($scope,element,attrs){return attrs.$observe("onLabel",function(val){$scope.onLabel=angular.isDefined(val)?val:"On"}),attrs.$observe("offLabel",function(val){$scope.offLabel=angular.isDefined(val)?val:"Off"}),attrs.$observe("knobLabel",function(val){$scope.knobLabel=angular.isDefined(val)?val:" "}),$scope.toggle=function(){return element.children().addClass("switch-animate"),$scope.model=!$scope.model}}}});
// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//










;
