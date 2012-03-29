<cfparam name="rc.extensions"  default="#QueryNew("blank")#">
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
			<th colspan="3" width="20%">
			<a href="#buildURL("#me#.new")#" class="btn btn-success">New Extension</a>
			</th>
		</tr>
	</thead>

	<tbody>
		<cfloop query="rc.extensions">
			<tr>
				<td>#name#</td>
				<td>#label#</td>
				<td>#version#</td>
				<td><a class="btn btn-primary" href="#buildURL("#me#.edit?name=#name#")#"><i class="icon-edit icon-white"></i> Edit</a></td>
				<td><a class="btn btn-danger" href="#buildURL("#me#.delete?name=#name#")#"><i class="icon-trash icon-white"></i> Delete</a></td>
				<td><a class="btn" href="#buildURL("#me#.publish?name=#name#")#"><i class="icon-shopping-cart"></i> Publish</a></td>
			</tr>
		</cfloop>
	</tbody>

</table>
</cfoutput>
</div>
</div>