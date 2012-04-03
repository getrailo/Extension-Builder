<cfparam name="rc.name" default="">
<cfparam name="rc.step" default="0">
<cfparam name="rc.label" default=""> 
<cfparam name="rc.description" default=""> 
<h1>Add an installation step</h1>
<cfoutput>
<form action="#buildURL("extension.savestep")#" method="post" class="form-inline well">
	<fieldset>
		<legend>Step description</legend>
	<input type="hidden" name="name" value="#rc.name#">
	<input type="hidden" name="step" value="#rc.step#">
	<label>Label</label>
	<input type="text" name="label" value="#rc.label#" class="span2">
	<label>Description</label>
	<input type="text" name="description" value="#rc.description#" class="span3">
	<button class="btn btn-primary" type="submit" >Save</button>
	</fieldset>
</form>

<h2>Groups</h2>
<p>Fields within a step can be grouped to define one action. Add a group first to add your fields</p>

</cfoutput>