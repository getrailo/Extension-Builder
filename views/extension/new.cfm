<cfparam name="rc.js" default="#[]#">
<cfsavecontent variable="pageScripts">
<script>
	$(function(){
		$("#label").keyup(function(){
			// replace all non-A-Z and 0-9 to dashes
			var cleanName = $(this).val().toLowerCase().replace(/[^0-9a-z]+/g,"-");
			// remove dashes at start and end
			cleanName = cleanName.replace(/(^-|-$)/g, "");

			$("#name").val(cleanName);
		}).triggerHandler('keyup');
		
		//Setup the error handling for items that have a data-required attribute
		
		$("input[data-required='true']").each(function(){

				$(this).change(function(){
					if(!$(this).val().length){
						$(":parent", this).addClass("error");
					}	
					else{
						$(":parent", this).removeClass("error");
								
					}			
				});
				
		});
		
		
		<cfloop array="#rc.errors#" index="e">
			<cfoutput>
				$("###e.field#").parent().addClass("error");
				$("###e.field#_help").text("#e.error#").show();
			</cfoutput>
		</cfloop>
		
		
		<!--- $("#mainForm").submit(function(e){
			var errors = false;
				e.preventDefault();
				if(!$("#label").val().length){
					$("#lab"el_control").addClass("error");
					$("#label_help").show();
					errors = true;
				}	
				else{
					$("#label_control").removeClass("error");
					$("#label_help").hide();
								
				}
					
				if(!$("#name").val().length){
					$("#name_control").addClass("error");
					$("#name_help").show();
					errors = true;
				}	
				else{
					$("#name_control").removeClass("error");
					$("#name_help").hide();
								
				}

				if(!errors){
					$("#mainForm").unbind();
					$("#mainForm").submit();			
				}

		}); --->
	});
</script>
</cfsavecontent>
<cfset ArrayAppend(rc.js, pageScripts)>
<h1>New Extension</h1>
<cfoutput>
<form action="#buildURL("extension.create")#" id="mainForm" method="post">
 <fieldset>
 	<legend>Extension Information</legend>

 	<div class="control-group" id="label_control">
		<label for="label" class="control-label">Display Name</label>
		<input type="text" name="label" value="" id="label" placeholder="My Great Extension" data-required="true" data-error="Please enter a label for your extension, this will be the displayed name in the extension store">
		<span class="help-inline hide" id="name_help"></span>	
	</div>


	<input type="hidden" name="name" id="name" value="" />
<!---
	<div class="control-group" id="name_control">
 		<label>Short Name:</label>
 		<input type="text" name="name" id="name" placeholder="MyExtension" data-required="true" data-error="Please enter a name for your extension"/>
		<span class="help-inline hide" id="label_help"></span>	
 	</div>
--->

	<div class="form-actions">
       <button type="submit" class="btn btn-primary">Create Extension</button>
       <button class="btn" type="reset">Reset form</button>
     </div>
 </fieldset>

</form>	

</cfoutput>