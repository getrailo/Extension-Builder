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
	
	function saveInfo(String extensionName, Struct info){
		var extPath = "zip://#expandPath("/ext/#extensionName#.zip")#!/config.xml";
		var extXML = XMLParse(FileRead(extPath));
			
			if(info['name'] EQ extensionName){
					StructDelete(info, "name");
			}
		var infoItem = extXML.config.info;

		loop collection="#info#" item="local.i"{
			var itemIndex = XMLChildPos(infoItem, i, 1);
			var item = infoItem.XMLChildren[itemIndex];
				item.XMLText = info[i];
		}		
				
		FileWrite(extPath, toString(extXML));
		
		updateInstaller(extensionName);
		
		return getInfo(extensionName);
	}
	
	function updateInstaller(String extensionName){
		var installString = FileRead("/services/templates/Install.cfc");
		var extPath = "zip://#expandPath("/ext/#extensionName#.zip")#!";
		var lTags = "";
		var lFunc = "";
		var lJars = "";
		
		if(DirectoryExists(extPath & "/tags/")){
		var qTAGS = DirectoryList(extPath & "/tags/",false,"query");
			lTags = ValueList(qTAGS.name);
		}
		if(DirectoryExists(extPath & "/functions/")){
		var qFUNC = DirectoryList(extPath & "/functions/",false,"query");
			lFunc = ValueList(qFUNC.name);
		}	
		
		if(DirectoryExists(extPath & "/jars/")){		
		var qJARS = DirectoryList(extPath & "/jars/",false,"query");
			lJars = ValueList(qJARS.name);
		}
		
		installString = Replace(installString, "__NAME__", extensionName, "all");
		installString = Replace(installString, "__TAGS__", lTags, "all");
		installString = Replace(installString, "__FUNCTIONS__", lFunc, "all");
		installString = Replace(installString, "__JARS__", lJars, "all");
		
		FileWrite(extPath & "/Install.cfc", installString);
		
		dump(installString)
		abort;
		
	}
	
	
	function createNewExtension(String extensionName, String extensionLabel){
		//Need to create the config.xml from the information provided
		var uuid = CreateUUID();
		var created = Now();
		//Create THE XMML config
		var validFields = ListToArray("author,category,support,description,mailinglist,documentation,image");
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
			
				var type = XMLElemNew(xmlConfig, "type");
					type.XMLText = "all";
			ArrayAppend(infoEl.XMLChildren, type);
			
				var version = XMLElemNew(xmlConfig, "version");
					version.XMLText = "1.0.0";
			ArrayAppend(infoEl.XMLChildren, version);

				var created = XMLElemNew(xmlConfig, "created");
					created.XMLText = Now();
			ArrayAppend(infoEl.XMLChildren, created);

			//Now add the rest of the tags
			loop array="#validFields#" index="v"{
				var field = XMLElemNew(xmlConfig, v);
				ArrayAppend(infoEl.XMLChildren, field);
			}

		ArrayAppend(xmlConfig.XMLRoot.XMLChildren, infoel);
		
		//Create a new file name after the name
		zip action="zip" file="#expandpath("/ext/#extensionName#.zip")#"{
			zipparam content=toString(xmlConfig) entrypath="config.xml";
		}
		
		return xmlConfig;
	}
	
	function listFolderContents(String extensionName, String folder){
		var items = [];
		
		var itemdir = "zip://#expandPath("/ext/#extensionName#.zip")#!/#folder#/";
		
		if(!DirectoryExists(itemdir)){
				return items;
		}
		
		var qItems = DirectoryList(itemdir,false,"query");
		
		loop query="qItems"{
				ArrayAppend(items, qItems.name);
		}
		
		return items;	
	}
	
	function addTextFile(String extensionName, String folder, String filename, String Content){
		var itemPath = "zip://#expandPath("/ext/#extensionName#.zip")#!/#folder#/";
		if(!DirectoryExists(itemPath)){
				Directorycreate(itemPath);
		}
		FileWrite(itemPath & "/" & filename, content);
	}
	
	function addBinaryFile(String extensionName, String source, String folder){
		var itemPath = "zip://#expandPath("/ext/#extensionName#.zip")#!/#folder#/";
		if(!DirectoryExists(itemPath)){
				Directorycreate(itemPath);
		}
		FileCopy(source, itemPath);
	}
	
	
	
	function addInfoNode(xmlItem, name, value=""){
		
	}
	
	
	
}