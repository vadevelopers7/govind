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