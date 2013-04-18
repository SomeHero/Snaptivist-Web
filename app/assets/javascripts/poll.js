$(document).ready(function() {
	var api_root_url = location.protocol + "//" + location.hostname + 
      (location.port && ":" + location.port) + "/api";

    var poll_services = new PollServices(api_root_url);
	var target_services = new TargetServices(api_root_url);

	var poll = {};

	var createPoll = function() {
		poll_services.create(poll, function(result) {
			poll_id = result.poll_id;

				 var source   = $("#share-poll-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = {}; //result.result;
        		 var html = template(context);

        		$("#wrap").append(html);

        		$("#share-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
				$('#create-action-sign-in-panel').animate({
					left: -($('#create-action-sign-in-panel').width() + windowWidth/2)
				}, 400, function() {
    			
    			$('#share-poll-panel').animate({
    				left:windowWidth/2-$("#share-poll-panel").width()/2
    			});
    		});
		}, function() {
			alert('unable to create poll');
		});
	};

	 $("#wrap").on("submit", "#create-poll-form", function(e) {
		e.preventDefault();

		var question = $("#question").val();
		var choices = [];

		var choice = {};
		choice = {
			choice: $("#choice1").val()
		}
		choices.push(choice);

		choice = {
			choice: $("#choice2").val()
		}
		choices.push(choice);
		
		poll.question = question;
		poll.choices = choices;

		var source   = $("#launch-poll-template").html();
				var template = Handlebars.compile(source);

				var windowWidth = $(window).width();
				var context = poll;
				var html = template(context);

				$("#wrap").append(html);

				$("#launch-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");

				$('#start-poll-panel').animate({
					left: -($("#create-poll").width() + windowWidth/2)
				}, 400, function() {

					$('#launch-poll-panel').animate({
						left:windowWidth/2-$("#create-poll").width()/2
					});
				});
			
	});
    $("#wrap").on("click", "#launch-poll", function(e) {
    	e.preventDefault();

    	//var url = api_root_url + '/phonecampaings/' + petition_id;

			var source   = $("#create-action-sign-in").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = {}; //result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#create-action-sign-in-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-poll-panel').animate({
    			left: -($('#launch-poll-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#create-action-sign-in-panel').animate({
    				left:windowWidth/2-$('#create-action-sign-in-panel').width()/2
				});
    			facebook_connect = new FacebookConnect($("#facebook-connect").attr('href'), function() {
				createPoll();
			}, 
			function() {
				alert('Sorry, unable to create poll.')
			});
			twitter_connect = new TwitterConnect($("#twitter-connect").attr('href'), function() {
				createPoll();
			}, 
			function() {
				alert('Sorry, unable to create poll.')
			});
    		});
    });
    $("#wrap").on("click", "#share-poll", function(e) {
    	e.preventDefault();

    		var windowWidth = $(window).width();

    		$('#share-poll-panel').animate({
    			left: -($(this).width() + windowWidth/2)
    		}, 400, function() {
    			$("#start-poll-panel").remove();
				$("#launch-poll-panel").remove();
				$("#share-poll-panel").remove();
    		});
    });

});