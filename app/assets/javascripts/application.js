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

	// if a link with 'fancybox-nested' class is clicked, get the html and replace with current html
	function fancybox_nested_links() {
		$.get($(this).attr('href'), function(data){
			// pull out the html starting with div class="content"
			var x = $('div.content', data).html();
			// insert the new html
			$('#fancybox-content div.content').html(x);
			// register any new fancybox-nested links
			$('#fancybox-content a.fancybox-nested').click(fancybox_nested_links);
		});

		return false;
	}

	// register click function for 'fancybox-nested' class that should only be used on pages that are opened in fancybox
	$('#fancybox-content a.fancybox-nested').click(fancybox_nested_links);


	$("a.fancybox").fancybox();



	// workaround to get logout link in navbar to work
	$('body')
		.off('click.dropdown touchstart.dropdown.data-api', '.dropdown')
		.on('click.dropdown touchstart.dropdown.data-api', '.dropdown form', function (e) { e.stopPropagation() });

	// facebook comments
	(function(d, s, id) {
		console.log("fn fb comments");
		var js, fjs = d.getElementsByTagName(s)[0];
		if (d.getElementById(id)) return;
		js = d.createElement(s); js.id = id;
		js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=" + gon.fb_app_id;
		fjs.parentNode.insertBefore(js, fjs);
	}(document, 'script', 'facebook-jssdk'));

	window.fbAsyncInit = function() {
		// when a comment is submitted, notify the user of the idea
		if (gon.show_fb_comments){
			console.log("showing fb comments");

			FB.Event.subscribe('comment.create', function(response){
				console.log(response);
				// get idea id
				var url_ary = response.href.split("/");
				// check for query string values
				var idea_id = url_ary[url_ary.length-1].split("?")[0];
				console.log("idead_id = " + idea_id);
				$.get(gon.comment_notification_url.replace(gon.placeholder, idea_id), function(){
					console.log("notification sent");
				});
			});
		}
  };


	// register tab pagination links for ajax calls
	$('div#idea_list .pagination a').attr('data-remote', 'true');
	// register tab pagination links to know which tab they are in
	$('div#idea_list .pagination a').each(function() {
		var href = $(this).attr('href');
		href += (href.indexOf('?') == -1 ? '?' : '&') + "tab=" + $(this).parent().parent().parent().parent().attr('id');
		$(this).attr('href', href);
	});


	//////////////////////////////
	// idea tabs
	//////////////////////////////
	// if ideas tabs are on page, highlight the correct block when the page loads
	if (gon.initial_tab_id){
		$("ul#ideas_tabs li#" + gon.initial_tab_id).addClass('active'); // turn on correct one
		$("div#" + gon.initial_tab_id).show();
	} else {
		// highlight the first tab
		$("ul#ideas_tabs li:first").addClass('active');
		$("div#idea_list div.idea_list_block:first").show();
	}

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
