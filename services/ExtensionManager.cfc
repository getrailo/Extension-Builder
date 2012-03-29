component output="false"{
<!--- This component provides some nice functions to be able to read from the extension zip files --->
	variables.validinfotags = "name,label,id,version,created,author,category,support,description,mailinglist,name,documentation,image,label,type,version,paypal";
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
	}
	
	
	function createNewExtension(String extensionName, String extensionLabel){
		//Need to create the config.xml from the information provided
		var uuid = CreateUUID();
		var created = Now();
		//Create THE XMML config
		var validFields = ListToArray("author,category,support,description,mailinglist,documentation,image,paypal");
		var xmlConfig = XMLNew(true);
		xmlConfig.XMLRoot = XMLElemNew(xmlConfig, "config");
		var infoel = XMLElemNew(xmlConfig.XMLRoot, "info");
		
			//Add some default values
			addElementsToInfo(infoel, "name", extensionName);
			addElementsToInfo(infoel, "label", extensionLabel);
			addElementsToInfo(infoel, "id", CreateUUID());
			addElementsToInfo(infoel, "type", "server");
			addElementsToInfo(infoel, "version", "1.0.0");
			addElementsToInfo(infoel, "created", Now());
			//Now add the rest of the tags
			loop array="#validFields#" index="v"{
				addElementsToInfo(infoel, v, "");
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
		
		updateInstaller(extensionName);
	}
	
	function addBinaryFile(String extensionName, String source, String folder){
		var itemPath = "zip://#expandPath("/ext/#extensionName#.zip")#!/#folder#/";
		if(!DirectoryExists(itemPath)){
				Directorycreate(itemPath);
		}
		FileCopy(source, itemPath);

		updateInstaller(extensionName);
	}
	
	
	//TODO: Change the adding and setting of nodes to use this function so it's cleaner
	function addElementsToInfo(xmlItem, name, value=""){
			var item = XMLElemNew(xmlItem, name);
				item.XMLText = value;
			ArrayAppend(xmlItem.XMLChildren, item);
	}
	
	
	
}