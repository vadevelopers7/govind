var LD = LD || {};

LD.Country = function () {
  this.initialize();
}
LD.Country.prototype= {
  initialize:function() {
    this.addedCountry();
  },

  addedCountry: function() {
  	$('#countryContainer #countryForm #submitCountry').unbind('click');
  	$('#countryContainer #countryForm #submitCountry').on('click', function(e) {
  		e.preventDefault();
  		params = {};
  		params['name'] = $('#countryContainer #countryForm #title').val();
  		params['code'] = $('#countryContainer #countryForm #code').val().toUpperCase();
  		params['active'] = $('#countryContainer #countryForm #status').val();

  		$.ajax({
        url: '/admin/countries/',
        type: 'POST',
        data: {country: params},
        format: 'JSON',
        success: function (data, textStatus, jqXHR) {
          console.log(data);
        },
        error: function (jqXHR, textStatus, errorThrown) {
         
        }
      });

  	});
  }
}