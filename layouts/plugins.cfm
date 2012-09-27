
<cfif structKeyExists(url, "ajax")>
	<cfoutput>#body#</cfoutput>
	<cfexit method="exittemplate">
</cfif>
<section class="row-fluid">
	<div class="span2">
		<cfoutput>#view("extension/localnav")#</cfoutput>
	</div>
	<div class="span10">
		<cfoutput>#body#</cfoutput>
	</div>
</section>