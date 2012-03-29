<cfoutput><cfparam name="rc.steps" default="#[]#">
<section class="row-fluid">
	<div class="span2">
		<cfinclude template="localnav.cfm">
	</div>
	<div class="span10">

	<h1>Installation Screens</h1>
	
		
	<cfif ArrayLen(rc.steps)>
	<h2>Screens</h2>
		
	<table class="table table-bordered table-striped">
		<thead>
			<tr><th colspan="2">Screen Title</th></tr>
		</thead>
		<tbody>
		<cfloop array="#rc.steps#" index="func">
			<tr>
				<td>#func#</td>
				<td width="20%"><a class="btn btn-danger" href="#buildURL("extension.removefunction?name=#rc.name#&function=#func#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
			</tr>
		</cfloop>
		</tbody>
	</table>	
	</cfif>
	</div>
</section></cfoutput>