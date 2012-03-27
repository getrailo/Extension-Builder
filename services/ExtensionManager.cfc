<cfcomponent output="false">
<!--- This component provides some nice functions to be able to read from the extension zip files --->

	<cffunction name="getInfo">
		<cfargument name="extensionName">
		
		<!--- Read the config.xml/config/info xml from the /ext/#extensionName#.zip file --->
		<cfscript>
			var info = {};
			var config = FileRead("zip://#expandPath("/ext/#extensionName#.zip")#!/config.xml")
				config = XMLParse(config);
			var infoXML = XMLSearch(config, "//info");




				for(inf in infoXML[1].XmlChildren){
					info[inf.xmlName] = Trim(inf.xmlText);
				}
		</cfscript>
		<cfreturn info>
	</cffunction>
</cfcomponent>