$(document).ready(function() {
	var api_root_url = location.protocol + "//" + location.hostname + 
      (location.port && ":" + location.port) + "/api";

    var phonecampaign_services = new PhoneCampaignServices(api_root_url);
	var target_services = new TargetServices(api_root_url);

	var twitter_connect = new TwitterConnect($("#twitter-connect").attr('href'));

	var phone_campaign = {};

	var createPhoneCampaign = function() {
		phonecampaign_services.create(phone_campaign, function(result) {
		phonecampaign_id = result.phonecampaign_id;

			var source   = $("#share-phone-campaign-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = {}; //result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#create-action-sign-in-panel').animate({
				left: -($('#create-action-sign-in-panel').width() + windowWidth/2)
			}, 400, function() {
    			
    			$('#share-phone-campaign-panel').animate({
    				left:windowWidth/2-$('#share-phone-campaign-panel').width()/2
    			});
    		});
    	}, function() {
    		alert('unable to create phone campaign');
    	});	
	};
	$("#wrap").on("submit", "#create-phone-campaign-form", function(e) {
		e.preventDefault();

		var target_id = $("#target_id").val();
		var title = $("#title").val();
		var summary = $("#summary").val();
		var goal = 1000;
		var rewrite_url_key = title.split(' ').join('-');

		//get target information
		phone_campaign = {
			target_id: target_id,
			title: title,
			summary: summary,
			target_count: goal,
			rewrite_url_key: rewrite_url_key
		};

		target_services.get(phone_campaign.target_id, function(result) {
			phone_campaign.target = result;

				var source   = $("#launch-phone-campaign-template").html();
        		var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = phone_campaign;
        		 var html = template(context);

        		$("#wrap").append(html);

        		$("#launch-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    			$('#start-phone-campaign-panel').animate({
    				left: -($("#start-phone-campaign-panel").width() + windowWidth/2)
    			}, 400, function() {
    			
    			$('#launch-phone-campaign-panel').animate({
    				left:windowWidth/2-$("#launch-phone-campaign-panel").width()/2
    			});
    		});
		}, function() {
			alert('unable to find target')
		});	
	});
	$("#wrap").on("click", "#launch-phone-campaign", function(e) {
    	e.preventDefault();

		var source   = $("#create-action-sign-in").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#create-action-sign-in-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#launch-phone-campaign-panel').animate({
     			left: -($('#launch-phone-campaign-panel').width() + windowWidth/2)
     		}, 400, function() {
    			
    		$('#create-action-sign-in-panel').animate({
    			left:windowWidth/2-$('#create-action-sign-in-panel').width()/2
			});
			facebook_connect = new FacebookConnect($("#facebook-connect").attr('href'), function() {
				createPhoneCampaign();
			}, 
			function() {
				alert('Sorry, unable to create petition.')
			});
			twitter_connect = new TwitterConnect($("#twitter-connect").attr('href'), function() {
				createPhoneCampaign();
			}, 
			function() {
				alert('Sorry, unable to create petition.')
			});

     	});
    });
    $("#wrap").on("click", "#share-phone-campaign", function(e) {
    	e.preventDefault();

    		var windowWidth = $(window).width();

    		$('#share-phone-campaign-panel').animate({
    			left: -($(this).width() + windowWidth/2)
    		}, 400, function() {
    			$("#start-phone-campaign-panel").remove();
				$("#launch-phone-campaign-panel").remove();
				$("#share-phone-campaign-panel").remove();
    		});
    });
});