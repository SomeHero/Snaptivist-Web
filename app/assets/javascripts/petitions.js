$(document).ready(function() {
	$("#wrap").on("submit", "#create-petition-form", function(e) {
		e.preventDefault();

		var title = $("#title").val();
		var summary = $("#summary").val();

		var url = 'http://localhost:3000/api/petitions';

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
});
