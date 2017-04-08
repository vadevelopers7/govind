var LD = LD || {};

LD.State = function () {
  this.initialize();
}
LD.State.prototype= {
  initialize:function() {
  	this.loadCountryData();
  	this.addedState();
  },

  loadCountryData: function() {
  	$.ajax({
	    url: '/admin/countries/',
	    type: 'GET',
	    format: 'JSON',
	    success: function (data, textStatus, jqXHR) {
	    	var countryData = data.countries;
	    	$('#stateContainer #stateForm #selectCountry').children().not("option[value='']").remove();
        $.each(countryData, function (i, item) {
          var option_string = "<option value=" + item.id +">" + item.name + "</option>";
          $('#stateContainer #stateForm #selectCountry').append(option_string);
        });
	    },
	    error: function (jqXHR, textStatus, errorThrown) {
	     
	    }
	  });
  },

  addedState: function() {
  	$('#stateContainer #stateForm #submitState').unbind('click');
  	$('#stateContainer #stateForm #submitState').on('click', function(e) {
  		e.preventDefault();
  		params = {};
  		var active = "";
  		params['name'] = $('#stateContainer #stateForm #title').val();
  		params['code'] = $('#stateContainer #stateForm #code').val().toUpperCase();
  		params['country_id'] = $('#stateContainer #stateForm #selectCountry').val().toUpperCase();

  		if ($('#stateContainer #stateForm #status').is(':checked')) {
  			active = true;
  		}
  		else
  		{
  			active = false;
  		}
  		params['active'] = active;
  		if($("#stateContainer #stateForm").valid()) {
	  		$.ajax({
	        url: '/admin/states/',
	        type: 'POST',
	        data: {state: params},
	        format: 'JSON',
	        success: function (data, textStatus, jqXHR) {
	        	var stateData = data.state;
	          $('#stateContainer #stateTable').bootstrapTable('insertRow', {index: 0, row: {
	              name : stateData.name,
	              code : stateData.code,
	              country_name : stateData.country_id,
	              active : stateData.active
            	}
          	});

            $('#stateContainer #stateModal').modal("hide");
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	         
	        }
	      });
	    }
  	});
  }
}