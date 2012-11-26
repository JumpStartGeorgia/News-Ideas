$(document).ready(function(){
	// set the width of the facebook comments box
	if (gon.show_fb_comments){
		$('div.fb-comments').attr('data-width',$('div.page-header').width());
	}

	// if an organization progress needs to be translated,
	// get the text to be translated and put it in the link
	$('.translate_org_progress').each(function(index){
		id = $(this).attr('data-id');
		// get the text
		text = encodeURIComponent($('#org_progress_' + id).text());

		// update the url with this text
		$(this).attr('href', $(this).attr('href').replace(gon.placeholder, text));

	});

});
