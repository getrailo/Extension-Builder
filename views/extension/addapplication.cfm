<cfparam name="rc.application" default="#[]#">
<cfoutput>	
		<h1>Application</h1>
		
		<cfif !ArrayLen(rc.application)>
			<cfinclude template="_addapplication.cfm">
	  	<cfelse>
		  	<cfinclude template="_applicationsettings.cfm">
		</cfif>
</cfoutput>	  	
