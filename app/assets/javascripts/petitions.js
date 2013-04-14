$(document).ready(function() {

	var api_root_url = location.protocol + "//" + location.hostname + 
      (location.port && ":" + location.port) + "/api";

    var petition_services = new PetitionServices(api_root_url);
    var phonecampaign_services = new PhoneCampaignServices(api_root_url);
	var poll_services = new PollServices(api_root_url);
	var target_services = new TargetServices(api_root_url);

	var twitter_connect = new TwitterConnect($("#twitter-connect").attr('href'));

    var petition = {};
	var petition_id;
	var signature_id;
	var phonecampaign_id;
	var poll_id;

	Handlebars.registerPartial("selectTarget", $("#select-target-template").html());

	$("#wrap").on("submit", "#create-petition-form", function(e) {
		e.preventDefault();

		var target_id = $("#target_id").val();
		var title = $("#title").val();
		var summary = $("#summary").val();
		var goal = 1000;
		var rewrite_url_key = title.split(' ').join('-');

		//get target information
		petition = {
			target_id: target_id,
			title: title,
			summary: summary,
			target_count: goal,
			rewrite_url_key: rewrite_url_key
		};

		target_services.get(petition.target_id, function(result) {
			petition.target = result;

				var source   = $("#launch-petition-template").html();
				var template = Handlebars.compile(source);

				var windowWidth = $(window).width();
				var context = petition;
				var html = template(context);

				$("#wrap").append(html);

				$("#launch-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");

				$('#start-petition-panel').animate({
					left: -($("#create-petition").width() + windowWidth/2)
				}, 400, function() {

					$('#launch-petition-panel').animate({
						left:windowWidth/2-$("#create-petition").width()/2
					});
				});
		}, function() {
			alert('unable to find target')
		});
	});
    $("#wrap").on("click", "#launch-petition", function(e) {
    	e.preventDefault();

		        var source   = $("#create-action-sign-in").html();
        var template = Handlebars.compile(source);

    	var windowWidth = $(window).width();
        var context = "";
        var html = template(context);

        $("#wrap").append(html);

        $("#create-action-sign-in-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
    	
    	$('#launch-petition-panel').animate({
     			left: -($('#launch-petition-panel').width() + windowWidth/2)
     		}, 400, function() {
    			
    		$('#create-action-sign-in-panel').animate({
    			left:windowWidth/2-$('#create-action-sign-in-panel').width()/2
			});

     		});

		// 	},
		// 	error: function(jqXHR, textStatus, errorThrown) {

		// 		return false;
		// 	}
		// });


    });
	$("#wrap").on("click", "#twitter-connect", function(e) {
		e.preventDefault();

		var twitter_connect = new TwitterConnect($("#twitter-connect").attr('href'));

  		twitter_connect.exec(function() {
  			//Add Petetion and slide in share screen
  			petition_services.create(petition, function(result) {
  				petition_id = result.petition_id;

				var source   = $("#share-petition-template").html();
				var template = Handlebars.compile(source);

				var windowWidth = $(window).width();

   				var context = {}; //result.result;
   				var html = template(context);

   				$("#wrap").append(html);
   				$("#share-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");

   				$('#create-action-sign-in-panel').animate({
   					left: -($('#create-action-sign-in-panel').width() + windowWidth/2)
   				}, 400, function() {

   					$('#share-petition-panel').animate({
   						left:windowWidth/2-$('#share-petition-panel').width()/2
   					});
   				});
  			}, function() {
  				alert('sorry, error happened')
  			});	
  		});
	});
	$("#wrap").on("click", "#facebook-connect", function(e) {
		e.preventDefault();

		var facebook_connect = new FacebookConnect($("#facebook-connect").attr('href'));

  		facebook_connect.exec(function() {
  			//Add Petetion and slide in share screen
  			petition_services.create(petition, function(result) {
  				petition_id = result.petition_id;

				var source   = $("#share-petition-template").html();
				var template = Handlebars.compile(source);

				var windowWidth = $(window).width();

   				var context = {}; //result.result;
   				var html = template(context);

   				$("#wrap").append(html);
   				$("#share-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");

   				$('#create-action-sign-in-panel').animate({
   					left: -($('#create-action-sign-in-panel').width() + windowWidth/2)
   				}, 400, function() {

   					$('#share-petition-panel').animate({
   						left:windowWidth/2-$('#share-petition-panel').width()/2
   					});
   				});
  			}, function() {
  				alert('sorry, error happened')
  			});	
  		});
	});
	$("#wrap").on("click", "#share-petition", function(e) {
		e.preventDefault();

		var petition_id = $("#petition_id").val();
  		var tweet = "I just created a petition on Snaptivist I demand " + petition.title
			
		petition_services.deliver(function() {
			var windowWidth = $(window).width();

				$('#share-petition-panel').animate({
					left: -($('#share-petition-panel').width() + windowWidth/2)
				}, 400, function() {
					$("#start-petition-panel").remove();
					$("#launch-petition-panel").remove();
					$("#share-petition-panel").remove();
				});
		}, function() {
			alert('unable to deliver');
		});
	});
    $("#wrap").on("submit", "#create-phone-campaign-form", function(e) {
		e.preventDefault();

		var target_id = $("#target_id").val();
		var title = $("#title").val();
		var summary = $("#summary").val();

		phonecampaign_services.create(phonecampaign, function(result) {
				phonecampaign_id = result.phonecampaign_id;

				 var source   = $("#launch-phone-campaign-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = result.result;
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
    		alert('unable to create phone campaign');
    	});		
	});
	$("#wrap").on("click", "#launch-phone-campaign", function(e) {
    	e.preventDefault();

    	phonecampaign_services.get(phonecampaign_id, function() {
    		var source   = $("#share-phone-campaign-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-phone-campaign-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-phone-campaign-panel').animate({
    			left: -($('#launch-phone-campaign-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#share-phone-campaign-panel').animate({
    				left:windowWidth/2-$('#share-phone-campaign-panel').width()/2
    			});
    		});
    	}, function() {
    		alert('unable to get phone campaign');
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
	$("#wrap").on("click", "#sign-petition-user-name", function(e) {
		e.preventDefault();

		var first_name = $("#firstName").val();
		var last_name = $("#lastName").val();
		var email = $("#emailAddress").val();
		var zip_code = $("#zipCode").val();
		var comment = $('#comment').val();
		var petition_id = $('#petition_id').val();

		petition_services.createUserAndSign(petition_id, first_name, last_name, email, zip_code, comment, function(result) {
			signature_id = result.signature.signature_id
			$("#signature_count").text(result.petition.signature_count);

			$("#sign-petition").hide();
			$("#sign-petition-deliver").show();
  		}, function() {
  				alert('unable to sign petition');
  		});	
	});
 	$("#wrap").on("click", "#sign-petition-facebook-button", function(e) {
 		e.preventDefault();

		var facebook_connect = new FacebookConnect($(this).attr('href'));
		
  		facebook_connect.exec(function() {
  		
  			var petition_id = $("#petition_id").val();
  			var comment = $("#comment").val();

  			petition_services.sign(petition_id, comment, function(result) {
				signature_id = result.signature.signature_id
				
				$("#signature_count").text(result.petition.signature_count);

				$("#sign-petition").hide();
				$("#sign-petition-deliver").show();
  			}, function() {
  				alert('unable to sign petition');
  			});		
  		}, function() {
  			alert("error with facebook signin");
  		});
 	});
	$("#wrap").on("click", "#deliver-signature", function(e) {
		e.preventDefault();

		var twitter_connect = new TwitterConnect($("#deliver-signature").attr('href'));

  		twitter_connect.exec(function() {
  			
  			var petition_id = $("#petition_id").val();
  			var tweet = "I just created a petition on Snaptivist I demand " + petition.title
			
  			petition_services.deliver(petition_id, signature_id, tweet, function() {
  				$("#sign-petition-deliver").hide();
				$("#sign-petition-thanks").show();
  			}, function() {
  				alert('unable to deliver signature');
  			})

  		}, function() {
  			alert('twitter authentication failed');
  		});
	});

$("#wrap").on("click", "#target-group-the-white-house", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);
	
	target_services.getByTargetGroup("1", function(results) {
			var context = results;
			var html    = template(context);

			elem.empty().append(html);
			elem.toggle();

		}, function() {
			alert('sorry unable to get targets');
		});
	});

$("#wrap").on("click", "#target-group-congress", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	elem.toggle();

});
$("#wrap").on("click", "#target-group-state", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	elem.toggle();

});
$("#wrap").on("click", "#target-group-other", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	elem.toggle();

});
$("#wrap").on("click", ".target", function() {

	$("#target_id").val($(this).val())

});
$("#wrap").on("click", ".state-select", function() {
	$("#" + $(this).attr("id") + "-items").toggle();
});
$("#wrap").on("change", "#congress_state_code", function() {
	var elem = $("#" + $(this).attr("id") + "-items");
	var state = $(this).val();
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);

		target_services.getByTargetGroupAndState("2", state, function(results) {
			var context = results;
			var html    = template(context);

			elem.empty().append(html);
			elem.toggle();

		}, function() {
			alert('sorry unable to get targets');
		});
});
$("#wrap").on("change", "#state_state_code", function() {
	var elem = $("#" + $(this).attr("id") + "-items");
	var state = $(this).val();
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);

	
			target_services.getByTargetGroupAndState("3", state, function(results) {
			var context = results;
			var html    = template(context);

			elem.empty().append(html);
			elem.toggle();

		}, function() {
			alert('sorry unable to get targets');
		});

});
$("#wrap").on("click", ".target-group-other", function() {
	$("#" + $(this).attr("id") + "-items").toggle();
});

});
