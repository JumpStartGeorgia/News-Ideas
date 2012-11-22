$(document).ready(function(){

	if (gon.edit_idea_progress){
		// load the date time pickers
		$('#idea_progress_progress_date').datepicker({
				dateFormat: 'dd.mm.yy',
		});
		if (gon.progress_date !== undefined && gon.progress_date.length > 0)
		{
			$("#idea_progress_progress_date").datepicker("setDate", new Date(gon.progress_date));
		}

		// if record is not completed, hide url field by default
		if (!$('#idea_progress_is_completed_true').is(':checked')) {
			$('#idea_progress_url').attr('value', '');
			$('#idea_progress_url_input').hide();
		}

		// if progress is marked as completed, show news url field
		$("input[type='radio'][name='idea_progress[is_completed]']").click(function(){
			if ($(this).attr('id') === 'idea_progress_is_completed_true'){
				// show url textbox
				$('#idea_progress_url_input').show(300);
			} else {
				// clear and hide url textbox
				$('#idea_progress_url').attr('value', '');
				$('#idea_progress_url_input').hide(300);
			}
		});

	}

});
