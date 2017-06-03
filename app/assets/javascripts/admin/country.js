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