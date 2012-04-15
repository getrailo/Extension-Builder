<h1>Delete extension <cfoutput>#rc.info.label#</cfoutput></h1>
<cfoutput>
	<form action="#buildURL("extension.delete")#" id="mainForm" method="post">
		<input type="hidden" name="name" value="#rc.name#" />
		<fieldset>
			<legend>Are you sure to delete the extension?</legend>
			<div class="form-actions">
			   <button type="submit" name="sure" value="1" class="btn btn-primary">Yes, delete the extension</button>
			   &nbsp; &nbsp;
			   <button class="btn" type="submit" name="notsure" value="1">No</button>
			 </div>
		</fieldset>
	</form>	
</cfoutput>