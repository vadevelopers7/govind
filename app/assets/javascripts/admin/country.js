var LD = LD || {};

LD.Country = function () {
  this.initialize();
}
LD.Country.prototype= {
  initialize:function() {
  	this.resetCountryForm();
  	this.formValidation();
    this.addedCountry();
    this.loadAllCountry();
  },

  resetCountryForm: function() {
  	$('#countryContainer #addCountryButton').unbind('click');
  	$('#countryContainer #addCountryButton').on('click', function(e) {
  		e.preventDefault();
  		$('#countryContainer #countryForm #title').val("");
  		$('#countryContainer #countryForm #code').val("");
  	});
  },

 	formValidation: function() {
 		$("#countryContainer #countryForm").validate({
      rules: {
        country_title: "required",
        country_code: "required"
      },
      messages: {
        country_title: "Please enter Country Name",
        country_code: "Please enter Country Code"
      }
    });
  },

  addedCountry: function() {
  	$('#countryContainer #countryForm #submitCountry').unbind('click');
  	$('#countryContainer #countryForm #submitCountry').on('click', function(e) {
  		e.preventDefault();
  		params = {};
  		var active = "";
  		params['name'] = $('#countryContainer #countryForm #title').val();
  		params['code'] = $('#countryContainer #countryForm #code').val().toUpperCase();

  		if ($('#countryContainer #countryForm #status').is(':checked')) {
  			active = true;
  		}
  		else
  		{
  			active = false;
  		}
  		params['active'] = active;
  		if($("#countryContainer #countryForm").valid()) {
	  		$.ajax({
	        url: '/admin/countries/',
	        type: 'POST',
	        data: {country: params},
	        format: 'JSON',
	        success: function (data, textStatus, jqXHR) {
	        	var countryData = data.country;
	          $('#countryContainer #countryTable').bootstrapTable('insertRow', {index: 0, row: {
	              id : countryData.id,
	              name : countryData.name,
	              code : countryData.code,
	              active : countryData.active
            	}
          	});

            $('#countryContainer #countryModal').modal("hide");
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	         
	        }
	      });
	    }
  	});
  },
 
  loadAllCountry: function() {
  	$.ajax({
      url: '/admin/countries/',
      type: 'GET',
      format: 'JSON',
      success: function (data, textStatus, jqXHR) {
      	var countryData = data.countries
        $('#countryContainer #countryTable').bootstrapTable('load', countryData);
      },
      error: function (jqXHR, textStatus, errorThrown) {
       
      }
    });
  }
}