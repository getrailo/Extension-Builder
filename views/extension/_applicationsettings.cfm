<cfoutput>
	<cfsavecontent variable="js">
		<script>
			$("##accordion2").collapse();
		</script>
	</cfsavecontent>
	
	<cfset ArrayAppend(rc.js, js)>
	<table class="table table-bordered table-striped">
			<thead>
				<tr><th colspan="2">Currently Added Application</th></tr>
			</thead>
			<tbody>
			<cfloop array="#rc.application#" index="app">
				<tr>
					<td>#app#</td>
					<td width="20%"><a class="btn btn-danger" href="#buildURL("extension.removeapplication?name=#rc.name#&application=#app#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
				</tr>
			</cfloop>
			</tbody>
			</table>	
	<div>
		<h2>Installation Steps</h2>
		<p>You can add a range of pages to gather information to help you install your application. Each step can have a group of input items that can help you select datasources, paths etc.</p>
		<!--- Do the steps as LI's --->
		<h3>Current Steps</h3>
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
				<cfloop array="#rc.steps#" index="s">
					<tr>
						<td>#counter#</td>
						<td nowrap="true"><a href="#buildURL("extension.editstep?name=#rc.name#&step=#counter#")#">#s.XMLAttributes.label#</a></td>
						<td>#s.XMLAttributes.description#</td>
						<td><a class="btn btn-danger btn-small"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
					</tr>
					<cfset counter++>
				</cfloop>
			</tbody>
		</table>
		<div class="form-actions">
		<a href="#buildURL("extension.addstep?name=#rc.name#")#" type="submit" class="btn">Add New Step</a>
		</div>


</cfoutput>
		
		
		
	</div>
				


