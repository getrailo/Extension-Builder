<cfparam name="rc.name" default="">
<cfparam name="rc.step" default="0">
<cfparam name="rc.label" default=""> 
<cfparam name="rc.description" default=""> 
<cfparam name="rc.group" default="0">
<h1>Edit Field Group</h1>
<p>Fields within a step can be grouped to define one action.</p>
<cfoutput>
	
<form action="#buildURL("extension.savegroup")#" method="post" class="form-inline well">
	<fieldset>
		<legend>Group description</legend>
		<input type="hidden" name="name" value="#rc.name#">
		<input type="hidden" name="step" value="#rc.step#">
		<input type="hidden" name="group" value="#rc.group#">
		<label>Label</label>
		<input type="text" name="label" value="#rc.label#" class="span2" placeholder="e.g.: Location">
		<label>Description</label>
		<input type="text" name="description" value="#rc.description#" class="span5" placeholder="Location where you want to install your application">
		<button class="btn btn-primary" type="submit" >Save</button>
	</fieldset>
</form>

</cfoutput>