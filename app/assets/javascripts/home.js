$(document).ready(function() {
    var activeOverlay;

    $("#wrap").on("click", "#twitter-connect", function(e) {
        e.preventDefault();

        twitter_connect.exec();
    });
    $("#wrap").on("click", "#facebook-connect", function(e) {
        e.preventDefault();

        facebook_connect.exec();
    });
	$("#login-button").click(function(e) {
		e.preventDefault();

		var source   = $("#create-action-sign-in").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#create-action-sign-in-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
	
    	$('#create-action-sign-in-panel').animate({
    		left:windowWidth/2-$('#create-action-sign-in-panel').width()/2
		});

	});
	$("#signup-button").click(function(e) {
		e.preventDefault();

		var source   = $("#create-account-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#create-account-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
	
    	$('#create-account-panel').animate({
    		left:windowWidth/2-$('#create-account-panel').width()/2
		});

	});
	$("#tour-button").click(function(e) {
		e.preventDefault();

		var source   = $("#tour-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#tour-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
	
    	$('#tour-panel').animate({
    		left:windowWidth/2-$('#tour-panel').width()/2
		});
	});
	$("#pricing-button").click(function(e) {
		e.preventDefault();

		var source   = $("#pricing-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#pricing-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
	
    	$('#pricing-panel').animate({
    		left:windowWidth/2-$('#pricing-panel').width()/2
		});
	});
	$("#about-button").click(function(e) {
		e.preventDefault();

		var source   = $("#about-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#about-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
	
    	$('#about-panel').animate({
    		left:windowWidth/2-$('#about-panel').width()/2
		});
	});
	$("#contact-button").click(function(e) {
		e.preventDefault();

		var source   = $("#contact-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#contact-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
	
    	$('#contact-panel').animate({
    		left:windowWidth/2-$('#contact-panel').width()/2
		});
	});
	$("#start-petition").click(function() {

        var source   = $("#create-petition-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#start-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#start-petition-panel').animate({
    			left:windowWidth/2-$('#start-petition-panel').width()/2
		});
    });
    $("#start-phone-campaign").click(function() {

        var source   = $("#create-phone-campaign-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#start-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#start-phone-campaign-panel').animate({
    			left:windowWidth/2-$('#start-phone-campaign-panel').width()/2
		});
    });
    $("#start-poll").click(function() {

        var source   = $("#create-poll-template").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#start-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#start-poll-panel').animate({
    			left:windowWidth/2-$('#start-poll-panel').width()/2
		});
    });
});