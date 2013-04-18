$(document).ready(function() {

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
		
		poll_services.create(question, choices, function(result) {
			poll_id = result.poll_id;

				 var source   = $("#launch-poll-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = result.result;
        		 var html = template(context);

        		$("#wrap").append(html);

        		$("#launch-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    			$('#start-poll-panel').animate({
    				left: -($("#start-poll-panel").width() + windowWidth/2)
    			}, 400, function() {
    			
    			$('#launch-poll-panel').animate({
    				left:windowWidth/2-$("#launch-poll-panel").width()/2
    			});
    		});
		}, function() {
			alert('unable to create poll');
		});
			
	});
    $("#wrap").on("click", "#launch-poll", function(e) {
    	e.preventDefault();

    	//var url = api_root_url + '/phonecampaings/' + petition_id;

    		var source   = $("#share-poll-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = {}; //result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-poll-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-poll-panel').animate({
    			left: -($('#launch-poll-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#share-poll-panel').animate({
    				left:windowWidth/2-$('#share-poll-panel').width()/2
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