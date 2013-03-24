$(document).ready(function() {

	var api_root_url = "http://dev.snaptivist.com/api/";
	var petition_id;

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
	$("#wrap").on("submit", "#create-petition-form", function(e) {
		e.preventDefault();

		var target_id = $("#target_id").val();
		var title = $("#title").val();
		var summary = $("#summary").val();

		var url = api_root_url + '/petitions';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'target_id': target_id,
				'title': title,
				'summary': summary 
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				 petition_id = result.result.petition_id;

				 var source   = $("#launch-petition-template").html();
        		 var template = Handlebars.compile(source);

    			 var windowWidth = $(window).width();
        		 var context = result.result;
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
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
	});
    $("#wrap").on("click", "#launch-petition", function(e) {
    	e.preventDefault();

    	var url = api_root_url + '/petitions/' + petition_id;

		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

    		var source   = $("#share-petition-template").html();
        	var template = Handlebars.compile(source);

    		var windowWidth = $(window).width();

        	var context = result.result;
        	var html = template(context);

        	$("#wrap").append(html);

    		$("#share-petition-panel").css('top', ($("#action-buttons").position().top - 20) + "px");
			$('#launch-petition-panel').animate({
    			left: -($('#launch-petition-panel').width() + windowWidth/2)
    		}, 400, function() {
    			
    			$('#share-petition-panel').animate({
    				left:windowWidth/2-$('#share-petition-panel').width()/2
    			});
    			});

			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});


    });
    $("#wrap").on("click", "#share-petition", function(e) {
    	e.preventDefault();

    		var windowWidth = $(window).width();

    		$('#share-petition-panel').animate({
    			left: -($(this).width() + windowWidth/2)
    		}, 400, function() {
    			$("#start-petition-panel").remove();
				$("#launch-petition-panel").remove();
				$("#share-petition-panel").remove();
    		});
    });
	$("#wrap").on("click", "#sign-petition-user-name", function(e) {
		e.preventDefault();

		var first_name = 'James';
		var last_name = 'Rhodes';
		var email = 'james@somehero.com';
		var zip_code = '23221';
		var comment = $('#comment').val();
		var petition_id = $('#petition_id').val()

		var url = api_root_url + '/signatures';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'petition_id': petition_id,
				'first_name': first_name,
				'last_name': last_name,
				'email': email,
				'zip_code': zip_code,
				'comment': comment
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				var signature = result.result.signature;

	    		$('#sign-petition-thanks').modal();
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
	});
 
	$("#wrap").on("click", "#sign-petition-fb", function(e) {
		var FB = window.FB || '';
		if(FB){
	    	FB.login(function(response) {
	    		console.log('fb login success');
	    		console.log(response);

	    var authentication_mechanism = 'facebook';
	    var external_id = response.authResponse.userId;
	    var access_token = response.authResponse.accessToken;
		var comment = $('#comment').val();
		var petition_id = $('#petition_id').val();

		var url = api_root_url +  '/signatures';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'petition_id': petition_id,
				'authentication_mechanism': authentication_mechanism,
				'external_id': external_id,
				'access_token': access_token,
				'comment': comment
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				var signature = result.result.signature;

					$('#sign-petition-thanks').modal();
			
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		});
	    	},{scope: 'email'});
		}else{
	 	console.log('fb login failed');
	 	};
	});
$("#wrap").on("click", "#target-group-the-white-house", function() {

	var elem = $("#" + $(this).attr("id") + "-items");
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);

	var url = api_root_url +  '/targets?targetgroup_id=1'
		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(results) {

				var context = results;
				var html    = template(context);

				elem.empty().append(html);
				elem.toggle();
			
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
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
$("#wrap").on("change", "#target-group-congress-select-state", function() {
	var elem = $("#" + $(this).attr("id") + "-items");
	var state = $(this).val();
	var source   = $("#target-template").html();
	var template = Handlebars.compile(source);

	var url = api_root_url +  '/targets?state='+ state +'&targetgroup_id=2'
		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(results) {

				var context = results;
				var html    = template(context);

				elem.empty().append(html);
				elem.show();
			
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
		})
});
$("#wrap").on("click", ".target-group-other", function() {
	$("#" + $(this).attr("id") + "-items").toggle();
});

});
