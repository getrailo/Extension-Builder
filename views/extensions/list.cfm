<cfparam name="rc.extensions"  default="#QueryNew("blank")#">
<h1>My Extensions</h1>


<cfoutput><table class="table table-striped">
	<thead>
		<tr>
			<th>Short Name</th>
			<th>Display Name</th>
			<th>Version</th>
			<th colspan="2"></th>
		</tr>
	</thead>

	<tbody>
		<cfloop query="rc.extensions">
			<tr>
				<td>#name#</td>
				<td>#label#</td>
				<td>#version#</td>
				<td><a class="btn btn-primary" href="#buildURL("extensions.edit?name=#name#")#"><i class="icon-edit icon-white"></i> Edit</a></td>
				<td><a class="btn btn-danger"><i class="icon-trash icon-white"></i> Delete</a></td>
			</tr>
		</cfloop>
	</tbody>

</table>
</cfoutput>
