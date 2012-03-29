<cfcomponent>
	
	<cfscript>
		variables.name = "__NAME__";
		variables.tags = ListToArray("__TAGS__");
		variables.functions = ListToArray("__FUNCTIONS__");
		variables.jars = ListToArray("__JARS__");
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
		

        <!---__INSTALL__--->
        <cfreturn '#variables.name# is now successfully installed'>

	</cffunction>

     <cffunction name="update" returntype="string" output="no"
    	hint="called from Railo to update a existing application">
    	<cfargument name="error" type="struct">
        <cfargument name="path" type="string">
        <cfargument name="config" type="struct">
        <cfset uninstall(path,config)>
		 <!---__UPDATE__--->
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

<!--- Copy all tags to the right folder --->
		<cfloop array="#variables.tags#" index="local.tag" >
			<cffile action="delete"
				file="#getContextPath()#/library/tag/#tag#">
		</cfloop>
		
		<!--- Copy all functions to the right folder --->
		<cfloop array="#variables.functions#" index="local.func">
			<cffile action="delete"
				file="#getContextPath()#/library/function/#func#">
		</cfloop>
		
		
		<cfloop array="#variables.jars#" index="local.jar">
			<cffile action="delete"
				file="#getContextPath()#/lib/#jar#">
		</cfloop>
		
			<!---__UNINSTALL__--->
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