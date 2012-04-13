<cfset request.layout = false>
<cfparam name="rc.name" default="">
<cfparam name="rc.step" default="0">
<cfparam name="rc.label" default=""> 
<cfparam name="rc.description" default=""> 
<cfparam name="rc.groups" default="#[]#"> 
<h1>Edit step</h1>
<cfoutput>
<form action="#buildURL("extension.savestep")#" method="post" class=" well">
	<fieldset>
	<input type="hidden" name="name" value="#rc.name#">
	<input type="hidden" name="step" value="#rc.step#">
	<label>Label</label>
	<input type="text" name="label" value="#rc.label#" class="span5">
	<label>Description</label>
	<input type="text" name="description" value="#rc.description#" class="span7">
	
	<div class="form-actions">
		<button class="btn btn-primary" type="submit" >Save</button>
	</div>
	</fieldset>
</form>
</cfoutput>