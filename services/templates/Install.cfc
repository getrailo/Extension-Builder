<cfcomponent output="no">
	
	<cfscript>
		variables.name = "__NAME__";
		variables.label = "__LABEL__";
		variables.tags = ListToArray("__TAGS__");
		variables.functions = ListToArray("__FUNCTIONS__");
        variables.plugins = ListToArray("__PLUGINS__");
        variables.railo_version = "__RAILO_VERSION__";
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



         <cfif Len(Trim(variables.railo_version)) AND (server.railo.version LT variables.railo_version)>
            <cfset error.common="To install this extension you need at least Railo version [#variables.railo_version#], your version is [#server.railo.version#]">
            <cfreturn>
        </cfif>

		
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
		
		<!--- copy jars --->
		<cfloop array="#variables.jars#" index="local.jar">
			<cffile action="copy"
				source="#path#jars/#jar#"
				destination="#getContextPath()#/lib/">
		</cfloop>
		
		<!--- Extract any applications --->
		<cfif variables.appl neq "">
			<cfset var installpath = _createInstallPathFromXML(arguments.path, arguments.config) />

			<!--- loop over the applications list (should be one item) --->
			<cfloop list="#variables.appl#" index="local.app">
				<!--- download the file? --->
				<cfif listLast(local.app, '.') eq "lnk">
					<cfset local.dlURL = fileRead('#path#applications/#local.app#') />
					<cfhttp url="#local.dlURL#" timeout="9999"
						getasbinary="auto" result="local.httpData" throwonerror="true" path="#getTempDirectory()#" file="#local.app#.zip" />
					<!--- check if file is a zip file --->
					<cfif not isZipFile(getTempDirectory() & local.app & ".zip")>
						<cfthrow message="The file downloaded from [#local.dlURL#] is not a valid zip file!" />
					</cfif>
					<cfset local.appPath = getTempDirectory() & local.app & ".zip" />
				<cfelse>
					<cfset local.appPath = "#path#applications/#local.app#" />
				</cfif>

				<!--- Check if we need to replace values in the code --->
				<cfif arrayLen( _getReplaceValuesFromConfig(arguments.path) )>
					<cfset var tempdir = GetTempDirectory() & "SDK/" />
					<cfzip action="unzip" file="#local.appPath#"
					destination="#tempdir#" overwrite="true" recurse="true" />
					
					<!--- replace the values --->
					<cfset _replaceFileValuesInDir(path:path, config:config, dir:tempdir) />

					<!--- now move all files and dirs to the installation location --->
					<cfset _moveDirectoryContents(from:tempdir, to:installpath) />

				<cfelse>
					<cfzip action="unzip" file="#local.appPath#"
					destination="#installpath#" overwrite="true" recurse="true" />
				</cfif>
			</cfloop>
		</cfif>

		<cfset message ="#variables.label# has been successfully installed">
		
		<cfif ArrayLen(variables.jars) OR ArrayLen(variables.tags) OR ArrayLen(variables.functions)>
			<cfset message &="<br> <strong>You need to restart Railo Server for the changes to take effect</strong>">
		</cfif>

		<cfif FileExists("after_install.cfm")>
			<cfinclude template="after_install.cfm">
		</cfif>

        <cfreturn message />
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
		
		<!--- Delete any functions we may have installed --->
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
		
        <cfreturn '#variables.name# has been succesfully uninstalled' />
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


	<cffunction name="listDatasources" returntype="void" output="no" hint="called from form generator to create dynamic forms">
		<cfargument name="item" required="yes" hint="item cfc">
		<cfset var datasources="">
		<cfadmin action="getDatasources" type="#request.adminType#" password="#session["password"&request.adminType]#" returnVariable="datasources">
		<cfloop query="datasources">
			<cfset item.createOption(value:datasources.name, label:datasources.name&" ("&datasources.host&")")>
		</cfloop>
	</cffunction>


	<cffunction name="_getReplaceValuesFromConfig" returntype="array" output="no" access="private">
		<cfargument name="path" type="string">
		<cfreturn xmlsearch('#path#config.xml', "/config/step/group/item[@fieldusage='replace']/") />
	</cffunction>
	
	<cffunction name="_replaceFileValuesInDir" returntype="void" output="no" access="private">
		<cfargument name="path" type="string">
		<cfargument name="config" type="struct">
		<cfargument name="dir" type="string">
		
		<cfset var replacevalues = _getReplaceValuesFromConfig(arguments.path) />
		<cfset var xmlNode = "" />
		<cfloop array="#replacevalues#" index="xmlNode">
			<!--- if the form field exists --->
			<cfif structKeyExists(arguments.config.mixed, xmlNode.xmlAttributes.name)>
				<cfset var replacefilenames = xmlNode.xmlAttributes.replacefilenames />
				<cfset var replacestring = xmlNode.xmlAttributes.replacestring />
				<cfset var withvalue = arguments.config.mixed[xmlNode.xmlAttributes.name] />
				<cfset var qFiles = "" />
				<cfdirectory action="list" directory="#arguments.dir#" recurse="yes" filter="#replace(replacefilenames, ',', '|', 'all')#" name="qFiles" />
				<cfloop query="qFiles">
					<cfset _replaceInFile(qFiles.directory & server.separator.file & qFiles.name, replacestring, withvalue) />
				</cfloop>
			</cfif>
		</cfloop>
	</cffunction>
	
	
	<cffunction name="_replaceInFile" output="no" access="private">
		<cfargument name="file" type="string" />
		<cfargument name="findstring" />
		<cfargument name="replaceWith" />
		<cfset var f = fileread(file) />
		<cfif findNoCase(findString, f)>
			<cfset fileWrite(file, replaceNoCase(f, findString, replaceWith, 'all')) />
		</cfif>
	</cffunction>
	
	
	<cffunction name="_isTextOrZipFile" returntype="boolean" output="no" access="private">
		<cfargument name="fullpath" />
		<cfif listfindNoCase("ZIP,txt,cfc,cfm,cfg,xml,config,csv,log,htm,html,js,css,cfml", listlast(fullpath, '.'))>
			<cfreturn true />
		<cfelseif listfindNoCase("exe,jpg,gif,png,ico", listlast(fullpath, '.'))>
			<cfreturn false />
		<cfelse>
			<cfreturn not isBinary(fileread(fullpath)) />
		</cfif>
	</cffunction>
	
	
	<cffunction name="_moveDirectoryContents" returntype="void" access="private">
		<cfargument name="from" type="string" />
		<cfargument name="to" type="string" />
		
		<cfset var qMove = "" />
		<cfdirectory action="list" name="qMove" directory="#arguments.from#" recurse="yes" sort="dir" />
		<cfset var startdir = qMove.directory />
		<cfloop query="qMove">
			<cfset var toDir = replace(qMove.directory, startdir, arguments.to) />
			<cfif qMove.type eq "dir">
				<cfif not DirectoryExists(todir & qMove.name)>
					<cfdirectory action="create" directory="#todir#/#qMove.name#" recurse="yes" mode="777" />
				</cfif>
			<cfelse>
				<cfif fileExists("#todir##qMove.name#")>
					<cffile action="delete" file="#todir#/#qMove.name#" />
				</cfif>
				<cffile action="move" source="#qMove.directory#/#qmove.name#" destination="#todir#/#qMove.name#" mode="755" />
			</cfif>
		</cfloop>
		<cfdirectory action="delete" directory="#arguments.from#" recurse="yes" />
	</cffunction>
	

	<cffunction name="_createInstallPathFromXML" returntype="string" output="no" access="private">
		<cfargument name="path" type="string" />
		<cfargument name="config" type="struct" />
		
		<!--- is there an install steps field given for the install path? --->
		<cfset var installpath = "" />
		<cfset var xmlItems = xmlSearch('#path#config.xml', "/config/step/group/item[@fieldusage='appinstallpath']/@name") />
		<cfif arrayLen(xmlItems)>
			<cfset installpath = xmlItems[1].xmlValue />
			<cfset installpath = trim(config.mixed[installpath]) />
		</cfif>
		
		<!--- by default, use the website root as install dir --->
		<cfif installpath eq "">
			<cfset installpath = '{web-root-directory}' />
		</cfif>
		
		<!--- only do an expandpath when we don't have a full linux path already --->
		<cfif find('/', installpath) neq 1>
			<cfset installpath = expandPath(installPath) />
		</cfif>
		
		<!--- create the directory if it does not exist yet--->
		<cfif not directoryExists(installpath)>
			<cfdirectory action="create" directory="#installpath#" recurse="yes" mode="777" />
		</cfif>
		<cfreturn installpath />
	</cffunction>


    <cffunction name="isExtensionVersionValid" returntype="boolean" output="false" access="private">
        <cfargument name="extRailoVersion" required="true">



    </cffunction>
	
</cfcomponent>