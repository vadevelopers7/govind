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
    this.loadAllCountry();
  	this.resetCountryForm();
  	this.formValidation();
    this.addedCountry();
  },

  loadAllCountry: function(data) {
    var self = this;
    $.ajax({
      url: '/admin/countries/',
      type: 'GET',
      format: 'JSON',
      success: function (data, textStatus, jqXHR) {
        countryData = data.countries;
        self.loadCountryIntoDataTable(countryData);
      },
      error: function (jqXHR, textStatus, errorThrown) {
       
      }
    });
  },

  loadCountryIntoDataTable: function(data) {
    var self = this;
    var table = $('#countryContainer #countryTable').DataTable();
      table.clear().draw();
      $.each(data, function(i,item){
        i = i+1;
        table.row.add( $(
         '<tr>'+
          '<td>'+i+'</td>'+
          '<td>'+item.name+'</td>'+
          '<td>'+item.code+'</td>'+
          '<td>'+item.active+'</td>'+
          '<td data-country-id ='+item.id+'><a class="btn btn-info btn-sm" id="editCountry">Edit</a> &nbsp;&nbsp;<a class="btn btn-danger btn-sm" id="deleteCountry">Delete</a></td>'+
          '<tr>'
        )[0]).draw();
      });
    self.handleEditCountry();
    //self.handleDeleteCountry();
  },

  handleEditCountry:function () {
    var self = this;
    $('#countryContainer #countryTable #editCountry').unbind('click');
    $('#countryContainer #countryTable #editCountry').on('click', function (e) {
      e.preventDefault();
      var countryId = $(this).parent().attr('data-country-id');
      var country = $.grep(countryData, function(country){ return country.id == countryId; });
      $('#countryContainer #countryModal').modal('show');
      $("#countryContainer #countryModal #title").val(country[0].name);
      $("#countryContainer #countryModal #code").val(country[0].code);
      //var status = country[0].active == true ? "Active" : "Deactive";
      console.log(country[0].active);
      if(country[0].active == true)
      {
        $('#countryContainer #countryModal #status').parent().addClass('checked')
      }
      else
      {
        $('#countryContainer #countryModal #status').parent().removeClass('checked')
      }
      //self.handleUpdateTag(tagID);
      
    });
  },

  resetCountryForm: function() {
  	$('#countryContainer #addCountryButton').unbind('click');
  	$('#countryContainer #addCountryButton').on('click', function(e) {
  		e.preventDefault();
  		$('#countryContainer #countryForm #title').val("");
  		$('#countryContainer #countryForm #code').val("");
      $('#countryContainer #countryForm label.error').hide();

  	});
  },

 	formValidation: function() {
    t = "ajay";
    console.log(t);
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
    var self = this;
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
            countryData.splice(0,0,data.country);
            self.loadCountryIntoDataTable(countryData);
            $('#countryContainer #countryModal').modal("hide");
	        },
	        error: function (jqXHR, textStatus, errorThrown) {
	         
	        }
	      });
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



