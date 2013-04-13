var PetitionServices = (function() {

  // constructor accepts a url which should be your Twitter OAuth url
  function PetitionServices(base_url) {
  	this.base_url = base_url
  };

  PetitionServices.prototype.get = function(id, success, failure) {

  };
	
  PetitionServices.prototype.create = function(petition, success, failure) {
  	var url = this.base_url + '/petitions';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'target_id': petition.target_id,
				'title': petition.title,
				'summary': petition.summary 
			}),
			beforeSend: function(jqXHR, settings) {
        		jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
    		},
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {
				success(result.result)
   			},
   			error: function(jqXHR, textStatus, errorThrown) {

   				return false;
   			}
   		}, function() {
   			alert('unable to create petition')
   		});
  };

  PetitionServices.prototype.sign = function(petition_id, comment, success, failure) {
  	 var url = this.base_url + '/petitions/' + petition_id + '/sign';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				"comment": comment
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

  PetitionServices.prototype.deliver = function(petition_id, tweet, success, failure) {
  		var url = this.base_url + '/petitions/' + petition_id + '/share';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				tweet: tweet
			}),
			beforeSend: function(jqXHR, settings) {
				jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
			},
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(result) {
				success();
			},
			error: function(jqXHR, textStatus, errorThrown) {
				failure();
			}
		});
  	};

  return PetitionServices;
})();''