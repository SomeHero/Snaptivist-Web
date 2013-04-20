var PhoneCampaignServices = (function() {

  function PhoneCampaignServices(base_url) {
  	this.base_url = base_url
  };

  PhoneCampaignServices.prototype.get = function(id, success, failure) {
  	var url = this.base_url + '/phonecampaigns/' + id;

	$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			beforeSend: function(jqXHR, settings) {
				jqXHR.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
			},
			// On success do some processing like closing the window and show an alert
			success: function(result) {
				success(result.result);
			},
			error: function(jqXHR, textStatus, errorThrown) {

				return false;
			}
	});
  };

  PhoneCampaignServices.prototype.create = function(phone_campaign, success, failure) {
  	var url = this.base_url + '/phonecampaigns';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'target_id': phone_campaign.target_id,
				'title': phone_campaign.title,
				'summary': phone_campaign.summary 
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

   PhoneCampaignServices.prototype.logCall= function(phonecampaign_id, comment, success, failure) {
  	 var url = this.base_url + '/phonecampaigns/' + phonecampaign_id + '/log';

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

    PetitionServices.prototype.createUserAndLogCall = function(phonecampaign_id, first_name, last_name, email_address, zip_code, comment, success, failure) {
  	 var url = this.base_url + '/phonecampaigns/' + phonecampaign_id + '/log';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				"first_name": first_name,
				"last_name": last_name,
				"email_address": email_address,
				"zip_code": zip_code,
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
    PhoneCampaignServices.prototype.deliver = function(phonecampaign_id, callresult_id, tweet, success, failure) {
  		var url = this.base_url + '/phonecampaigns/' + phonecampaign_id + '/share';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				callresult_id: callresult_id,
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


  return PhoneCampaignServices;
})();''