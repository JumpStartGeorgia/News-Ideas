$(document).ready(function(){
	// set the width of the facebook comments box
	if (gon.show_fb_comments){
		$('div.fb-comments').attr('data-width',$('div.page-header').width());
	}

});
