$(function(){
			
	 $('#form_upload_tag').ajaxForm({
	 		beforeSend: function() {
				  $("#upload_tag_progress").show();	
				  $("#upload_tag_progress .bar").css("width", "0%");
			},
		    uploadProgress: function(event, position, total, percentComplete) {
			     var percentVal = percentComplete + '%';
		         $("#upload_tag_progress .bar").css("width", percentVal);
		    },
			complete: function(xhr) {
				//status.html(xhr.responseText);
				$("#upload_tag_progress .bar").css("width", "100%");
				$("#upload_tag_progress").hide();	
					
			}
        }); 
        
       
});