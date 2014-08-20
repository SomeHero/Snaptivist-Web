// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require bootstrap-sprockets
//= require lazyload
//= require spin
//= require lightbox
//= require jquery
//= require jquery.history
//= require main
//= require ngDialog
/*
 * VARIABLES
 * Description: All Global Vars
 */
// Impacts the responce rate of some of the responsive elements (lower value affects CPU but improves speed)
$.throttle_delay = 350;

// The rate at which the menu expands revealing child elements on click
$.menu_speed = 235;

// Note: You will also need to change this variable in the "variable.less" file.
$.navbar_height = 49;

/*
 * APP DOM REFERENCES
 * Description: Obj DOM reference, please try to avoid changing these
 */
$.root_ = $('body');
$.left_panel = $('#left-panel');
$.shortcut_dropdown = $('#shortcut');

/*
 * APP CONFIGURATION
 * Description: Enable / disable certain theme features here
 */
$.navAsAjax = true; // Your left nav in your app will no longer fire ajax calls

// Please make sure you have included "jarvis.widget.js" for this below feature to work
$.enableJarvisWidgets = true;
// $.enableJarvisWidgets needs to be true it to work (could potentially
// crash your webApp if you have too many widgets running on mobile view)
$.enableMobileWidgets = false;

// Plugin dependency "smartclick.js"
$.enableFastClick = false; // remove the 300 ms delay in iDevices


/*
 * DETECT MOBILE DEVICES
 * Description: Detects mobile device - if any of the listed device is detected
 * a class is inserted to $.root_ and the variable $.device is decleard. 
 */

/* so far this is covering most hand held devices */
var ismobile = (/iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase()));

if (!ismobile) {
    // Desktop
    $.root_.addClass("desktop-detected");
    $.device = "desktop";
} else {
    // Mobile
    $.root_.addClass("mobile-detected");
    $.device = "mobile";

    // remove 300ms delay from apple touch devices
    // dependency: plugin/smartclick/smartclick.js
    if ($.enableFastClick){
        $('nav ul a').noClickDelay();
        $('#hide-menu a').noClickDelay();
    }
}

/* ~ END: CHECK MOBILE DEVICE */

/*
 * DOCUMENT LOADED EVENT
 * Description: Fire when DOM is ready
 */

$(document).ready(function() {
    /*
     * Fire tooltips
     */
    if ($("[rel=tooltip]").length) {
        $("[rel=tooltip]").tooltip();
    }

    //TODO: was moved from window.load due to IE not firing consist
    nav_page_height()
});

 /*
 * NAV OR #LEFT-BAR RESIZE DETECT
 * Description: changes the page min-width of #CONTENT and NAV when navigation is resized.
 * This is to counter bugs for min page width on many desktop and mobile devices.
 * Note: This script uses JSthrottle technique so don't worry about memory/CPU usage
 */

// Fix page and nav height
function nav_page_height() {
    setHeight = $('#main').height();
    menuHeight = $.left_panel.height();
    windowHeight = $(window).height() - $.navbar_height;
    //set height

    if (setHeight > windowHeight) {// if content height exceedes actual window height and menuHeight
        $.left_panel.css('min-height', setHeight + 'px');
        $.root_.css('min-height', setHeight + $.navbar_height + 'px');
        $("#push").css('height', 2000);
        
    } else {
        $.left_panel.css('min-height', windowHeight + 'px');
        $.root_.css('min-height', windowHeight + 'px');
    }
}

$('#main').resize(function() {
    nav_page_height();
    check_if_mobile_width();
})

$('nav').resize(function() {
    nav_page_height();
})

function check_if_mobile_width() {
    if ($(window).width() < 979) {
        $.root_.addClass('mobile-view-activated')
    } else if ($.root_.hasClass('mobile-view-activated')) {
        $.root_.removeClass('mobile-view-activated');
    }
}

/* ~ END: NAV OR #LEFT-BAR RESIZE DETECT */