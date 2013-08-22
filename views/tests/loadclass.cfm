<h1>Class Checker</h1>

<form action="#CGI.SCRIPT_NAME#?#CGI.QUERY_STRING#" method="post">
<label for="classToLoad">Class To Load:</label>
<input type="text" placeholder="java.io.File" name="classtoLoad"/>
<input type="submit">
</form>

<cfif FORM.keyExists("classToLoad")>
	
	<cfset myClass = createObject("java", FORM.classToLoad)>
</cfif>


