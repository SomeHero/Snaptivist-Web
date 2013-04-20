var PollServices = (function() {

	// constructor accepts a url which should be your base url of web service endpoints
  function PollServices(base_url) {
  	this.base_url = base_url
  };

  PollServices.prototype.get = function(id, success, failure) {

  };
	
  PollServices.prototype.create = function(poll, success, failure) {

		var url = this.base_url + '/polls';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'poll': {
					'question': poll.question,
					'choices': poll.choices
				}
			}),
			beforeSend: function(jqXHR, settings) {
				jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
			},
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {

				success(result.result);
    		},
			error: function(jqXHR, textStatus, errorThrown) {
				failure();
			}
		});
	};
	
  return PollServices;
})();''