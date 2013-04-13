var TargetServices = (function() {

	function TargetServices(base_url) {
  		this.base_url = base_url
  	};

  	TargetServices.prototype.get = function(target_id, success, failure) {
  		var url = this.base_url + '/targets/' + target_id;

		$.ajax({
			type: "GET",
			url: url,
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
  TargetServices.prototype.getByTargetGroup = function(targetgroup_id, success, failure) {
  	var url = this.base_url +  '/targets?targetgroup_id=' + targetgroup_id;
		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(results) {
				success(results);
			
			},
			error: function(jqXHR, textStatus, errorThrown) {
				failure()
			}
		});
  };
    TargetServices.prototype.getByTargetGroupAndState = function(targetgroup_id, state_code, success, failure) {
  	var url = this.base_url +  '/targets?targetgroup_id=' + targetgroup_id + '&state=' + state_code;
		$.ajax({
			type: "GET",
			url: url,
			// Stringify the node
			dataType: 'json',
			contentType: 'application/json',
			// On success do some processing like closing the window and show an alert
			success: function(results) {
				success(results);
			
			},
			error: function(jqXHR, textStatus, errorThrown) {
				failure()
			}
		});
  };

  return TargetServices;

})();''
