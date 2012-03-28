<cfcomponent>
	
	<cfscript>
		variables.name = "__NAME__";
		
		//OR! we create a list of items that are hardcoded in here
		
		variables.jars = "__JARS__";
		variables.tags = "__TAGS__";
		variables.functions = "__FUNCTIONS__";
	</cfscript>
    
    <cffunction name="validate" returntype="void" output="no"
    	hint="called to validate values">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">
        <cfargument name="step" type="numeric">
			<!---__VALIDATION__--->        
    </cffunction>

    <cffunction name="install" returntype="string" output="no"
    	hint="called from Railo to install application">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">

		<!--- Copy all tags to the right folder --->
		<cfset var TAGS = DirectoryList(path & "tags",false,"query")>
		<cfloop query="TAGS">
			<cffile action="copy"
				source="#path#tags/#TAGS.name#"
				destination="#getContextPath()#/library/tag/">
		</cfloop>
		<!--- Copy all functions to the right folder --->
		<cfset var FUNCS = DirectoryList(path & "functions",false,"query")>
		<cfloop query="FUNCS">
			<cffile action="copy"
				source="#path#functions/#FUNCS.name#"
				destination="#getContextPath()#/library/function/">
		</cfloop>
		
		<cfset var JARS = DirectoryList(path & "jars",false,"query")>
		<cfloop query="JARS">
			<cffile action="copy"
				source="#path#jars/#JARS.name#"
				destination="#getContextPath()#/lib/">
		</cfloop>
		

        
        <cfreturn '#variables.name# is now successfully installed'>

	</cffunction>

     <cffunction name="update" returntype="string" output="no"
    	hint="called from Railo to update a existing application">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">
        <cfset uninstall(path,config)>
		<cfreturn install(argumentCollection=arguments)>
    </cffunction>


    <cffunction name="uninstall" returntype="string" output="no"
    	hint="called from Railo to uninstall application">
    	<cfargument name="path" type="string">
        <cfargument name="config" type="struct">

		<cfloop list="#variables.jars#" index="i">
            <cffile
            action="delete"
            file="#getContextPath()#/lib/#i#">
		</cfloop>


        <cfreturn '#variables.name# is now successfully removed'>

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