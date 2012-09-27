
<cfif ListGetAt(rc.action,2,".") EQ "default" or structKeyExists(url, "ajax")>
	<cfoutput>#body#</cfoutput>
	<cfexit method="exittemplate">
</cfif>
<section class="row-fluid">
	<div class="span2">
		<cfif ListLast(rc.action, ".") NEQ "new">
			<cfoutput>#view("extension/localnav")#</cfoutput>
		</cfif>
	</div>
	<div class="span10">
		<cfoutput>#body#</cfoutput>
	</div>
</section>