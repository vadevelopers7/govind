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
  },

  handleMenuClick:function() {
  	var self = this;
  	$('.main_container .menu_section #adminDashboardClick').unbind();
  	$('.main_container .menu_section #adminDashboardClick').click(function(){
  		self.hideAllContainer();
  		$('.content #dashboardContainer').removeClass('hidden');
  	});
  }
}