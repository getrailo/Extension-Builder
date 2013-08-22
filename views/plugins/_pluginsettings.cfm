<cfoutput>
	<cfsavecontent variable="js">
		<script>
			$("##accordion2").collapse();
		</script>
	</cfsavecontent>
	<cfset ArrayAppend(rc.js, js)>

	<table class="table table-bordered table-striped">
		<thead>
			<tr><th colspan="3">Currently Added Plugins</th></tr>
		</thead>
		<tbody>
			<cfloop array="#rc.plugins#" index="app">
				<tr>
					<td width="10%">#app.type#</td>
					<td>
						<cfif app.type eq "URL">
							<a href="#app.url#">#app.url#</a>
						<cfelse>
							#app.name#
						</cfif>
					</td>
					<td width="20%"><a class="btn btn-danger" href="#buildURL("plugins.remove?name=#rc.name#&plugin=#app.name#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
				</tr>
			</cfloop>
		</tbody>
	</table>
</cfoutput>