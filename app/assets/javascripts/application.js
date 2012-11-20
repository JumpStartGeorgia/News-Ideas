// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require i18n
//= require i18n/translations
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require twitter/bootstrap
//= require vendor
//= require_tree .

$(document).ready(function(){
	// set focus to first text box on page
	if (gon.highlight_first_form_field){
	  $(":input:visible:enabled:first").focus();
	}


	// if ideas tabs are on page, highlight the correct block when the page loads
	if (gon.initial_tab_id){
console.log("initial tab id is set");
		$("ul#ideas_tabs li#" + gon.initial_tab_id).addClass('active'); // turn on correct one
		$("div#" + gon.initial_tab_id).show();
	} else {
console.log("initial tab id is NOT set");
		// highlight the first tab
		$("ul#ideas_tabs li:first").addClass('active');
		$("div#idea_list div.idea_list_block:first").show();
	}


	// if ideas tabs are on page, register click event
	// when clicked, show appropriate idea block
	$("ul#ideas_tabs a").click(function(event) {
		id = $(this).parent().attr('id');
		// activate the correct tab
		$("ul#ideas_tabs li").removeClass('active'); // turn off all tabs
		$("ul#ideas_tabs li#" + id).addClass('active'); // turn on correct one

		// hide all item blocks
		$("div#" + gon.id_new).hide();
		$("div#" + gon.id_top).hide();
		$("div#" + gon.id_in_progress).hide();
		$("div#" + gon.id_realized).hide();

		// turn on the correct block
		$("div#" + id).slideDown('300');

		return false;
	});


	// facebook api
	window.fbAsyncInit = function() {
		FB.init({
		  appId      : '542104115818446', // App ID
		  channelUrl : '//0.0.0.0:3000/channel.html', // Channel File
		  status     : true, // check login status
		  cookie     : true, // enable cookies to allow the server to access the session
		  xfbml      : true  // parse XFBML
		});

		FB.getLoginStatus(function(response) {
			if (response.status === 'connected') {
				// connected
				console.log("logged into facebook and gave app permission");
			} else if (response.status === 'not_authorized') {
				// not_authorized
				console.log("logged into facebook, but app does not have permission");
			} else {
				// not_logged_in
				console.log("not logged into facebook");
			}
		 });
	};

	// Load the facebook SDK Asynchronously
	(function(d){
		 var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
		 if (d.getElementById(id)) {return;}
		 js = d.createElement('script'); js.id = id; js.async = true;
		 js.src = "//connect.facebook.net/en_US/all.js";
		 ref.parentNode.insertBefore(js, ref);
	 }(document));

});
