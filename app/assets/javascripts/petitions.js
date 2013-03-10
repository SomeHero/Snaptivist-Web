$(document).ready(function() {

	var api_root_url = "http://dev.snaptivist.com/api"; //"http://localhost:3000/api/";

	$("#wrap").on("submit", "#create-petition-form", function(e) {
		e.preventDefault();

		var title = $("#title").val();
		var summary = $("#summary").val();

		var url = api_root_url + '/petitions';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'title': title,
				'summary': summary 
			}),
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				var petition = result.result.petition;

				$("#title-edit").text(petition.title);
				$("#summary-edit").text(petition.summary);

				var windowWidth = $(window).width();

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
});
