var LD = LD || {};

LD.LoggedIn = function () {
  this.initialize();
}
LD.LoggedIn.prototype= {
  initialize:function() {
  	this.hideAllContainer();
  	this.handleMenuClick();
    console.log("loggedin");
  },

  hideAllContainer:function() {
  	$('.content #dashboardContainer').addClass('hidden');
    $('.content #countryContainer').addClass('hidden');
    $('.content #stateContainer').addClass('hidden');
    $('.content #cityContainer').addClass('hidden');
  },

  handleMenuClick:function() {
  	var self = this;
  	$('.main_container .menu_section #adminDashboardClick').unbind();
  	$('.main_container .menu_section #adminDashboardClick').click(function(){
  		self.hideAllContainer();
  		$('.content #dashboardContainer').removeClass('hidden');
  	});

    $('.main_container .menu_section #adminCountryClick').unbind();
    $('.main_container .menu_section #adminCountryClick').click(function(){
      self.hideAllContainer();
      $('.content #countryContainer').removeClass('hidden');
      var country = new LD.Country();
    });

    $('.main_container .menu_section #adminStateClick').unbind();
    $('.main_container .menu_section #adminStateClick').click(function(){
      self.hideAllContainer();
      $('.content #stateContainer').removeClass('hidden');
      var state = new LD.State();
    });

    $('.main_container .menu_section #adminCityClick').unbind();
    $('.main_container .menu_section #adminCityClick').click(function(){
      self.hideAllContainer();
      $('.content #cityContainer').removeClass('hidden');
    });
  }
}
;
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
;
var LD = LD || {};

LD.State = function () {
  this.initialize();
}
LD.State.prototype= {
  initialize:function() {
  	this.loadCountryData();
  	this.addedState();
  	this.loadAllState();
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
  },

  loadAllState: function() {
  	$.ajax({
      url: '/admin/states/by_country/',
      type: 'GET',
      data: {country_id: 1},
      format: 'JSON',
      success: function (data, textStatus, jqXHR) {
      	var stateData = data.states
        var serail_number = 1;
        $.each(stateData, function (i, item) {
          $('#stateContainer #stateTable').bootstrapTable('load',{
            data: [{
                s_no: serail_number,
                name: item.name,
                code: item.code,
                active: item.active,
                action: "<a href='#' class='label label-warning' state_id="+item.id+">Edit</a>&nbsp;&nbsp;&nbsp;<a href='#' class='label label-danger' state_id="+item.id+">Delete</a>"
            }]
           });
          serail_number++;
        });
      },
      error: function (jqXHR, textStatus, errorThrown) {
       
      }
    });
  }
}
;



