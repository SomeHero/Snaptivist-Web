var PhoneCampaignServices = (function() {

  function PhoneCampaignServices(base_url) {
  	this.base_url = base_url
  };

  PhoneCampaignServices.prototype.get = function(id, success, failure) {
  	var url = api_root_url + '/phonecampaigns/' + id;

	$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
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
  	var url = api_root_url + '/phonecampaigns';

		$.ajax({
			type: "POST",
			url: url,
			data: JSON.stringify({
				'target_id': phone_campaign.target_id,
				'title': phone_campaign.title,
				'summary': phone_campaign.summary 
			}),
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

  return PhoneCampaignServices;
})();''