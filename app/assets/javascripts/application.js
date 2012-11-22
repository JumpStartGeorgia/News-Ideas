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
//= require fancybox
//= require twitter/bootstrap
//= require vendor
//= require_tree .

$(document).ready(function(){
	// set focus to first text box on page
	if (gon.highlight_first_form_field){
	  $(":input:visible:enabled:first").focus();
	}

	// add fancybox to any link with class fancybox
	$("a.fancybox").fancybox();

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

	// workaround to get logout link in navbar to work
	$('body')
		.off('click.dropdown touchstart.dropdown.data-api', '.dropdown')
		.on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() });


	// facebook comments
	(function(d, s, id) {
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=542104115818446";
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));


});
