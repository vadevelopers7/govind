var LD = LD || {};

LD.State = function () {
  this.initialize();
}
LD.State.prototype= {
  initialize:function() {
  	this.loadCountryData();
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
  }
}