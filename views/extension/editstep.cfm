<!---
<cfparam name="rc.name" default="">
<cfparam name="rc.step" default="0">
<cfparam name="rc.label" default=""> 
<cfparam name="rc.description" default=""> 
<cfparam name="rc.groups" default="#[]#">
--->
<cfoutput>
	<cfif rc.label eq "">
		<h1>Add step #rc.step#</h1>
	<cfelse>
		<h1>Edit step #rc.step#</h1>
	</cfif>
	<form action="#buildURL("extension.savestep")#" method="post" class=" well">
		<fieldset>
			<input type="hidden" name="name" value="#rc.name#">
			<input type="hidden" name="step" value="#rc.step#">
			<div>
				<label>Label</label>
				<input type="text" name="label" value="#rc.label#" class="span5">
			</div>
			<div>
				<label>Description</label>
				<input type="text" name="description" value="#rc.description#" class="span7">
			</div>
			<div class="form-actions">
				<button class="btn btn-primary" type="submit" >Save</button>
			</div>
		</fieldset>
	</form>
</cfoutput>