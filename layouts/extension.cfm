
<cfif ListGetAt(rc.action,2,".") EQ "default">
<cfoutput>#body#</cfoutput>
<cfexit method="exittemplate">
</cfif>
<section class="row-fluid">
	<div class="span2">
		<cfoutput>#view("extension/localnav")#</cfoutput>
	</div>
	<div class="span10">
		<cfif Len(rc.message)>
		<div class="alert alert-success">
		<a class="close" data-dismiss="alert">x</a>
		<cfoutput>#rc.message#</cfoutput>
		</div>
	</cfif>
		<cfoutput>#body#</cfoutput>
	</div>
</section>