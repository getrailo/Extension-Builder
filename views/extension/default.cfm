<cfset me = getSection()>

<div class="row-fluid">
	
	<div class="span12">
<h1>My Extensions</h1>
<cfoutput>

<table class="table table-striped">
	<thead>
		<tr>
			<th>Short Name</th>
			<th>Display Name</th>
			<th>Version</th>
			<th>Tags</th>
			<th>Functions</th>
			<th>Applications</th>
			<th>Jars</th>
			<th colspan="3" width="20%">
			<a href="#buildURL("#me#.new")#" class="btn btn-success"><i class="icon-pencil icon-white"></i> New Extension</a>
			</th>
		</tr>
	</thead>

	<tbody>
		<cfloop array="#rc.extensions#" index="ext">
			<tr>
				<td>#ext.info.name#</td>
				<td>#ext.info.label#</td>
				<td>#ext.info.version#</td>
				<td><cfif ext.capabilities.tags><i class="icon-ok"></i></cfif></td>
				<td><cfif ext.capabilities.functions><i class="icon-ok"></i></cfif></td>
				<td><cfif ext.capabilities.applications><i class="icon-ok"></i></cfif></td>			
				<td><cfif ext.capabilities.jars><i class="icon-ok"></i></cfif></td>
				<td><a class="btn btn-primary" href="#buildURL("#me#.edit?name=#ext.info.name#")#"><i class="icon-edit icon-white"></i> Edit</a></td>
				<td><a class="btn btn-danger" href="#buildURL("#me#.delete?name=#ext.info.name#")#"><i class="icon-trash icon-white"></i> Delete</a></td>
				<td><a class="btn" href="#buildURL("#me#.publish?name=#ext.info.name#")#"><i class="icon-shopping-cart"></i> Publish</a></td>
			</tr>
		</cfloop>
	</tbody>

</table>
</cfoutput>
</div>
</div>