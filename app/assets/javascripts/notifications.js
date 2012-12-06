$(document).ready(function(){
	if (gon.notifications){
		// register click events to clear out other form fields
		$('input#all').click(function(){
			$('input#none').removeAttr('checked');
			$('select#categories').val([]);
		});

		$('input#none').click(function(){
			$('input#all').removeAttr('checked');
			$('select#categories').val([]);
		});

		$('select#categories').click(function(){
			$('input#all').removeAttr('checked');
			$('input#none').removeAttr('checked');
		});

	}

});
