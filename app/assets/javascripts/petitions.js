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

	$("#action-wrapper").height($("#sign-petition-signature").outerHeight(true));

	var createPetition = function() {
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
	};

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

			facebook_connect = new FacebookConnect($("#facebook-connect").attr('href'), function() {
				createPetition();
			}, 
			function() {
				alert('Sorry, unable to create petition.')
			});
			twitter_connect = new TwitterConnect($("#twitter-connect").attr('href'), function() {
				createPetition();
			}, 
			function() {
				alert('Sorry, unable to create petition.')
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

 			$("#sign-petition-deliver").css('top', "0px");
    		$("#sign-petition-deliver").css('left', "1200px");
    		$("#sign-petition-deliver").show();
    		$("#sign-petition-deliver").width($("#action-wrapper").width());

    		var windowWidth = $(window).width();

			$("#sign-petition-signature").animate({
				left: -($("#sign-petition-signature").width() + windowWidth/2)
			}, 400, function() {
				$("#sign-petition-deliver").animate({
					left: 0
				});
			});
  		}, function() {
  				alert('unable to sign petition');
  		});	
	});
 	$("#wrap").on("click", "#sign-petition-facebook-button", function(e) {
 		e.preventDefault();

		var facebook_connect = new FacebookConnect($(this).attr('href'), function() {
  		
  			var petition_id = $("#petition_id").val();
  			var comment = $("#comment").val();

  			petition_services.sign(petition_id, comment, function(result) {
				signature_id = result.signature.signature_id
				
				$("#signature_count").text(result.petition.signature_count);

				$("#sign-petition-deliver").css('top', "0px");
    			$("#sign-petition-deliver").css('left', "1200px");
    			$("#sign-petition-deliver").show();
    			$("#sign-petition-deliver").width($("#action-wrapper").width());

    			var windowWidth = $(window).width();

				$("#sign-petition-signature").animate({
					left: -($("#sign-petition-signature").width() + windowWidth/2)
				}, 400, function() {
					$("#sign-petition-deliver").animate({
						left: 0
					});
				});
  			}, function() {
  				alert('unable to sign petition');
  			});		
  		}, function() {
  			alert("error with facebook signin");
  		});
		
  		facebook_connect.exec();
 	});
	$("#wrap").on("click", "#deliver-signature", function(e) {
		e.preventDefault();

		var twitter_connect = new TwitterConnect($("#deliver-signature").attr('href'), function() {
  			
  			var petition_id = $("#petition_id").val();
  			var tweet = "I just created a petition on Snaptivist I demand " + petition.title
			
  			petition_services.deliver(petition_id, signature_id, tweet, function() {
  				$("#sign-petition-deliver").hide();
				$("#other-campaigns-container").show();
  			}, function() {
  				alert('unable to deliver signature');
  			})

  		}, function() {
  			alert('twitter authentication failed');
  		});

  		twitter_connect.exec();
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
