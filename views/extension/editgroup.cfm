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

<cfdump var="#rc.fields#">
<h2>Fields</h2>
<cfset counter = 1>
		<table class="table table-striped table-bordered">
			<thead>
				<tr>
					<th></th>
					<th>Name</th>
					<th>Type</th>
					<th width="10%"></th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.fields#" index="s">
					<tr>
						<td>#counter#</td>
						<td nowrap="true"><a href="#buildURL("extension.editgroup?name=#rc.name#&step=#rc.step#&group=#counter#")#">#s.XMLAttributes.label#</a></td>
						<td>#s.XMLAttributes.description#</td>
						<td><a class="btn btn-danger btn-small"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
					</tr>
					<cfset counter++>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
				<td colspan="4"><a href="#buildURL("extension.editfield?name=#rc.name#&step=#rc.step#&group=#rc.group#&field=0")#" type="submit" class="btn">Add Field</a></td>
				</tr>
			</tfoot>
		</table>



</cfoutput>