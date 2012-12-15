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

  // register jquery multi select for category list in new idea form
  $('select#idea_category_ids').multiselect({
    header: false,
    noneSelectedText: ''
  });

	// workaround to get logout link in navbar to work
	$('body')
		.off('click.dropdown touchstart.dropdown.data-api', '.dropdown')
		.on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() });



	//////////////////////////////
	// idea tabs
	//////////////////////////////
	// register tab pagination links for ajax calls
	$('div#idea_list .pagination a').attr('data-remote', 'true');
	// register tab pagination links to know which tab they are in
	$('div#idea_list .pagination a').each(function() {
		var href = $(this).attr('href');
		href += (href.indexOf('?') == -1 ? '?' : '&') + "tab=" + $(this).parent().parent().parent().parent().attr('id');
		$(this).attr('href', href);
	});


	// register click event for idea tabs
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




});
