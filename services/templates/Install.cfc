<cfcomponent>
	
	<cfscript>
		variables.name = "__NAME__";
		variables.label = "__LABEL__";
		variables.tags = ListToArray("__TAGS__");
		variables.functions = ListToArray("__FUNCTIONS__");
		variables.jars = ListToArray("__JARS__");
		variables.appl = "__APPS__";
	</cfscript>
    
	<cfif FileExists("additional_functions.cfm")>
		<cfinclude template="additional_functions.cfm">
	</cfif>
	
    <cffunction name="validate" returntype="void" output="no"
    	hint="called to validate values">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">
        <cfargument name="step" type="numeric">
		
			<cfif FileExists("validation.cfm")>
				<cfinclude template="validation.cfm">
			</cfif>     
    </cffunction>

    <cffunction name="install" returntype="string" output="no"
    	hint="called from Railo to install application">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">
		
		
		<cfif FileExists("before_install.cfm")>
			<cfinclude template="before_install.cfm">
		</cfif>


		<!--- Copy all tags to the right folder --->
		<cfloop array="#variables.tags#" index="local.tag" >
			<cffile action="copy"
				source="#path#tags/#tag#"
				destination="#getContextPath()#/library/tag/">
		</cfloop>
		
		<!--- Copy all functions to the right folder --->
		<cfloop array="#variables.functions#" index="local.func">
			<cffile action="copy"
				source="#path#functions/#func#"
				destination="#getContextPath()#/library/function/">
		</cfloop>
		
		
		<cfloop array="#variables.jars#" index="local.jar">
			<cffile action="copy"
				source="#path#jars/#jar#"
				destination="#getContextPath()#/lib/">
		</cfloop>
		
		
		<!--- Extract an application if it exists to the {web-context} Need a param for this!--->
		

		
		<cfset message ="#variables.label# has been successfully installed">
		
		<cfif ArrayLen(variables.jars) OR ArrayLen(variables.tags) OR ArrayLen(variables.functions)>
			<cfset message &="<br> <strong>You need to restart Railo Server for the changes to take effect</strong>">
		</cfif>

		<cfif FileExists("after_install.cfm")>
			<cfinclude template="after_install.cfm">
		</cfif>


        <cfreturn message>

	</cffunction>

     <cffunction name="update" returntype="string" output="no"
    	hint="called from Railo to update a existing application">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">
        <cfset uninstall(path,config)>
		<cfif FileExists("update.cfm")>
				<cfinclude template="update.cfm">
			</cfif>   
		<cfreturn install(argumentCollection=arguments)>
    </cffunction>


    <cffunction name="uninstall" returntype="string" output="no"
    	hint="called from Railo to uninstall application">
    	<cfargument name="path" type="string">
        <cfargument name="config" type="struct">

		<cfif FileExists("before_uninstall.cfm")>
				<cfinclude template="before_uninstall.cfm">
		</cfif>   

		<!--- Delete any tags we may have installed --->
		<cfloop array="#variables.tags#" index="local.tag">
			<cfif FileExists("#getContextPath()#/library/tag/#tag#")>
				<cfset FileDelete("#getContextPath()#/library/tag/#tag#")>
			</cfif>
		</cfloop>
		
		<!--- Delete any tags we may have installed --->
		<cfloop array="#variables.functions#" index="local.func">
			<cfif FileExists("#getContextPath()#/library/function/#func#")>
				<cfset FileDelete("#getContextPath()#/library/function/#func#")>
			</cfif>
		</cfloop>
		<!--- TODO: Add a throw exception in case it fails on Windows --->
		<!--- Check MD5 of JAR files for replacement
			Throw error if it can't be uninstalled, and has to be installed manually
		 --->
		<!--- Delete any jars we may have installed --->
		<cfloop array="#variables.jars#" index="local.jar">
			<cfif FileExists("#getContextPath()#/lib/#jar#")>
				<cfset FileDelete("#getContextPath()#/lib/#jar#")>
			</cfif>
		</cfloop>
		
		
			<cfif FileExists("after_uninstall.cfm")>
				<cfinclude template="after_uninstall.cfm">
		</cfif>   
        <cfreturn '#variables.name# has been uninstalled'>

    </cffunction>

	<cffunction name="getContextPath" access="private" returntype="string">

		<cfswitch expression="#request.adminType#">
			<cfcase value="web">
				<cfreturn expandPath('{railo-web}') />
			</cfcase>
			<cfcase value="server">
				<cfreturn expandPath('{railo-server}') />
			</cfcase>
		</cfswitch>

	</cffunction>


</cfcomponent>