component output="false"{
<!--- This component provides some nice functions to be able to read from the extension zip files --->

	function getInfo(extensionName){
		//Read the config.xml/config/info xml from the /ext/#extensionName#.zip file

			var info = {};
			var config = FileRead("zip://#expandPath("/ext/#extensionName#.zip")#!/config.xml")
				config = XMLParse(config);
			var infoXML = XMLSearch(config, "//info");

				for(inf in infoXML[1].XmlChildren){
					info[inf.xmlName] = Trim(inf.xmlText);
				}
		return info;
	}
	
	
	function createNewExtension(String extensionName, String extensionLabel){
		//Need to create the config.xml from the information provided
		var uuid = CreateUUID();
		var created = Now();
		//Create THE XMML config
		var xmlConfig = XMLNew(true);
		xmlConfig.XMLRoot = XMLElemNew(xmlConfig, "config");
		
		var infoel = XMLElemNew(xmlConfig.XMLRoot, "info");
				var name = XMLElemNew(infoel, "name");
				name.XMLText = extensionName;
			ArrayAppend(infoEl.XMLChildren, name);
				var label = XMLElemNew(xmlConfig, "label");
					label.XMLText = extensionLabel;
			ArrayAppend(infoEl.XMLChildren, label);
				var id = XMLElemNew(xmlConfig, "id");
					id.XMLText = CreateUUID();
			ArrayAppend(infoEl.XMLChildren, id);
						
		ArrayAppend(xmlConfig.XMLRoot.XMLChildren, infoel);
		
		//Create a new file name after the name
		zip action="zip" file="#expandpath("/ext/#extensionName#.zip")#"{
			zipparam content=toString(xmlConfig) entrypath="config.xml";
		}
		
		return xmlConfig;
	}
	
	
	function saveInfo(String extensionName, Struct info){
		
		dump(arguments);
		abort;
	}
	
	
}