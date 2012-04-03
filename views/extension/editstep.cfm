<cfparam name="rc.name" default="">
<cfparam name="rc.step" default="0">
<cfparam name="rc.label" default=""> 
<cfparam name="rc.description" default=""> 
<cfparam name="rc.groups" default="#[]#"> 
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

<cfset counter = 1>
		<table class="table table-striped table-bordered">
			<thead>
				<tr>
					<th></th>
					<th>Name</th>
					<th>Description</th>
					<th width="10%"></th>
				</tr>
			</thead>
			<tbody>
				<cfloop array="#rc.groups#" index="s">
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
				<td colspan="4"><a href="#buildURL("extension.editgroup?name=#rc.name#&step=#rc.step#&group=0")#" type="submit" class="btn">Add New Group</a></td>
				</tr>
			</tfoot>
		</table>

</cfoutput>