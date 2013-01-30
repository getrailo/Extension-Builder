<h1>Your extension has been published in the Railo Extension Store!</h1>
<p><a href="<cfoutput>#buildURL("extension.publish?name=#rc.name#")#</cfoutput>">Back to the publish page</a></p>
<hr />
<br />
<cfif structKeyExists(rc, "publishresult")>
	<!--- show the result of the upload --->
	<cfset fileWrite('#request.absRootPath#temp-storeresult.html', rc.publishresult, 'utf-8') />
	<h3><em>Please review the result:</em></h3>
	<iframe width="100%" height="400" frameborder="1" src="#request.webRootPath#temp-storeresult.html">Wow, your browser does not support frames?!</iframe>
<cfelseif structKeyExists(rc, "loginFailed")>
	<div class="error">Login did not succeed!</div>
<cfelse>
	<h1>No status?!</h1>
</cfif>