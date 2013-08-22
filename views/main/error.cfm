<cfset request.layout = false />
<!--- courtesy of Andreas Schuldhaus --->
<div style="width: 50%; color: red; border: 2px dotted red; background-color: #f9f9f9; padding: 10px;">
	<h1 style="color: red;">ERROR!</h1>
	<div style="width: 100%; text-align: left;">
		<p><b>An error occurred!</b></p>
		<cfoutput>
			<cfif structKeyExists( request, 'failedAction' )>
				<b>Action:</b> #request.failedAction#<br/>
			<cfelse>
				<b>Action:</b> unknown<br/>
			</cfif>
			<b>Error:</b> #request.exception.cause.message#<br/>
			<b>Type:</b> #request.exception.cause.type#<br/>
			<b>Details:</b> #request.exception.cause.detail#<br/>
			<b>Template:</b> #request.exception.TagContext[1].template#<br/>
			<b>Line:</b> #request.exception.TagContext[1].line#<br/>
			<b>Code:</b> <pre>#request.exception.TagContext[1].codePrintHTML#</pre>
			
		 	<cfif request.exception.type EQ "FW1.viewNotFound">
		 		<cfset filePath = request.exception.Detail>
		 		<cfset filePath = ReplaceNoCase(filePath, "' does not exist.", "")>
		 		<cfset filePath = ReplaceNoCase(filePath, "'", "")>
		 		Create View (<a href="subl://open/?url=file://#expandPath(filePath)#">#filePath#</a>)
		 	</cfif>
		</cfoutput>
		<cfdump var="#request.exception#" label="">
	</div>
</div>

