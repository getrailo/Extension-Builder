<cfcomponent output="false">
	
	<!--- please note: this cfset can be overwritten by the REB --->
	<cfset variables.extensionInfo = {
		  title: 'Extension Builder Provider (#cgi.http_host#)'
		, description: 'Provider for locally built extensions by the Railo Extension Builder'
		, image: ''
		, url: 'http://#cgi.http_host#'
		, mode: 'develop'
	} />
	
	<cffunction name="getInfo" access="remote" returntype="struct" output="false">
    	<cfreturn variables.extensionInfo />
    </cffunction>
             
    <cffunction name="listApplications" access="remote" returntype="query" output="false">
		<cfset var apps=queryNew('type,id,name,label,description,version,category,image,download,paypal,author,codename,video,support,documentation,forum,mailinglist,network,created')>
        <cfset populate(apps)>
        <cfreturn apps>
    </cffunction>    
    
	<cffunction name="populate" access="private" returntype="void" output="false">
    	<cfargument name="apps" type="query" required="yes">
		<cfset var extensionPath = expandPath('/ext')>
		<cfset var rootURL=getInfo().url & "/">
		<cfset var extensions = DirectoryList(extensionPath, false,"name","*.zip")>
		
		<cfloop array="#extensions#" index="local.ext">
			<cffile action="read" file="zip://#expandPath("/ext/#local.ext#")#!/config.xml" variable="config">
			<cfset info = XMLParse(config)>
			
	        <cfset QueryAddRow(apps)>
	      	<cfset QuerySetCell(apps,'download',rootURL & "ext/#ext#")>
	        <cfset QuerySetCell(apps,'id', info.config.info.id.XMLtext)>
	        <cfset QuerySetCell(apps,'name',info.config.info.name.XMLtext)>
	        <cfset QuerySetCell(apps,'type',info.config.info.type.XMLtext)>
	        <cfset QuerySetCell(apps,'label',info.config.info.label.XMLtext)>
	        <cfset QuerySetCell(apps,'description',info.config.info.description.XMLtext)>
	        <cfset QuerySetCell(apps,'created',info.config.info.created.XMLtext)>
	        <cfset QuerySetCell(apps,'version',info.config.info.version.XMLtext)>
	        <cfset QuerySetCell(apps,'category',info.config.info.category.XMLtext)>
			<cfset QuerySetCell(apps,'author',info.config.info.author.XMLtext)>
			<cfif info.config.info.image.XMLtext neq "" and not isValid('url', info.config.info.image.XMLtext)>
				<cfset QuerySetCell(apps,'image', rootURL & "ext/" & info.config.info.image.XMLtext)>
			<cfelse>
				<cfset QuerySetCell(apps,'image',info.config.info.image.XMLtext)>
			</cfif>
		</cfloop>
		
		
	</cffunction>

</cfcomponent>