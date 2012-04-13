component {
	variables.availableActions = ListToArray("before_install,after_install,additional_functions,update,validation, before_uninstall, after_uninstall");
	function init(any fw){
		variables.fw  = fw;
		variables.man =  application.di.getBean("ExtensionManager");
	}
	
	function before(any rc){
		//Called on every request before anything happens
		param name="rc.errors" default=[];
		param name="rc.js" default=[];
		param name="rc.message" default="";
		
		//test if we are getting a specific extension
		if(StructKeyExists(rc, "name") AND ListLast(rc.action, ".") != "create"){
			rc.info = variables.man.getInfo(rc.name);
		}
	}

	function default(any rc){
		var ep = new ExtensionProvider();
		var remoteExtensions = ep.listApplications();

		rc.extensions = [];

		loop query="remoteExtensions"{
				var ext = {};
					ext.info = QuerySlice(remoteExtensions,remoteExtensions.currentrow,1);
					ext.capabilities = variables.man.getCapability(ext.info.name);
				ArrayAppend(rc.extensions, ext);
		}
	}
	
	function new(any rc) {
		rc.info = {};
		//variables.fw.setView("extension.edit");
	}
	
	function create(any rc){

		param name="rc.name" default="";
		param name="rc.label" default="";
		
		if(!Len(rc.name)){
				ArrayAppend(rc.errors, {field="name", error="You need a name for an extension"});
		}
		if(!Len(rc.label)){
				ArrayAppend(rc.errors, {field="label", error="You need a label for an extension"});
		}
		
		if(ArrayLen(rc.errors)){
				variables.fw.setView("extension.new");
				return;
		}
		var man = application.di.getBean("ExtensionManager");
		rc.info = man.createNewExtension( rc.name, rc.label);
		
		//All going well so far, redirect them to the edit page
		variables.fw.redirect("extension.edit?name=#rc.name#");
		
	}
	
	function saveInfo(any rc) {
		var validFields = "author,category,support,description,mailinglist,name,documentation,image,label,type,version,paypal,packaged-by";
		
		var dataToSend = Duplicate(rc);
		
		// upload image?
		if (structKeyExists(rc, "imgtype") and rc.imgtype eq "file")
		{
			if (rc.image neq "")
			{
			 	file action="upload" destination="#gettempdirectory()#" filefield="image" result="local.uploadimage" nameconflict="makeunique";
				dataToSend.image = getTempDirectory() & local.uploadimage.serverfile;
				// remove old image
				if (structKeyExists(rc, "oldimage") and not isValid('url', rc.oldimage))
				{
					try {
						file action="delete" file="zip://#expandPath("/ext/#rc.name#.zip")#!#rc.oldimage#";
						file action="delete" file="#expandpath('/ext#rc.oldimage#')#";
					} catch(any E) {}
				}
			} else if (structKeyExists(rc, "oldimage") and not isValid('url', rc.oldimage))
			{
				dataToSend.image = rc.oldimage;
			}
		// remove old image
		else if (structKeyExists(rc, "oldimage") and not isValid('url', rc.oldimage))
			{
				try {
					file action="delete" file="zip://#expandPath("/ext/#rc.name#.zip")#!#rc.oldimage#";
					file action="delete" file="#expandpath('/ext#rc.oldimage#')#";
				} catch(any E) {}
			}
		}
		
		for(c in dataToSend){
				if(!ListFindNoCase(validFields,c)){
						StructDelete(dataToSend, c);
				}
		}
		
		rc.info = variables.man.saveInfo(rc.name, dataToSend);
		rc.message = "The information has been saved to the extension";
		variables.fw.redirect("extension.license?name=#rc.name#&message=#rc.message#");
	}
	
	function saveLicense(any rc) {
		variables.man.saveInfo(rc.name, {name:rc.name, licenseTemplate:replace(rc.licenseTemplate, '.txt', '')});
		variables.man.setLicenseText(rc.name, rc.license);
		rc.message = "Your license text has been saved to the extension";
		
		//Return to the main, since we don;t know if they are adding an application.
		//An application only works with web type extensions
		variables.fw.redirect("extension.edit?name=#rc.name#&message=#rc.message#");
	}
	
	function edit(any rc) {
		var man = application.di.getBean("ExtensionManager");
		rc.info = man.getInfo(rc.name);
		
	}
	
	function license(any rc) {
		var man = application.di.getBean("ExtensionManager");
		rc.info = man.getInfo(rc.name);
		rc.info.licenseText = man.getLicenseText(rc.name);
	}
	
	function licenses(any rc){
		rc.data = variables.man.getLicense(rc.license);
		variables.fw.setView("util.plain");
		request.layout =false;
	}
	
	
	
	function installActions(any rc){
		rc.availableActions = variables.availableActions;
		loop array="#rc.availableActions#" index="local.act"{
			rc[act] = variables.man.getFileContent(rc.name, "", "#act#.cfm");
		}
	}
	
	function saveActions(any rc){
		
		rc.availableActions = variables.availableActions;
		loop array="#rc.availableActions#" index="local.act"{
			if( StructKeyExists(rc, act)){
				variables.man.addTextFile(rc.name, "", "#act#.cfm", rc[act]);	
			}
		}
		
		variables.fw.redirect("extension.installactions?name=#rc.name#&message=The actions have been saved");
	}
	
	/*
	 * Add Items to an extension 	
	 */
	 
	 function addApplication(rc){
	 	 
	 }
	 
	 function addTags(rc){
	 	 rc.tags = variables.man.listFolderContents(rc.name, "tags");

	 }
	 function addFunctions(rc){
	 	 rc.functions = variables.man.listFolderContents(rc.name, "functions");	
	 }
	 
	 function addJars(rc){
	 	 rc.jars = variables.man.listFolderContents(rc.name, "jars");	
	 }
	 
	 function addApplication(rc){
	 	 rc.application = variables.man.listFolderContents(rc.name, "applications");	
	 	 rc.steps = XMLSearch(variables.man.getConfig(rc.name), "//step");
	 }
	 
	 function addTag(rc){
		file action="upload" destination="#expandPath("/upload")#" filefield="tagUpload" result="local.uploadresult" nameconflict="overwrite";
		var tagname = uploadresult.serverfile;
		var extensionName = rc.name;
		var content = FileRead(expandPath("/upload/#uploadresult.serverfile#"));
		variables.man.addTextFile(extensionName, "tags", tagname, content);
		rc.response = "Tag #tagname# has been added";
	 	 
	 }
	 
	 function addJar(rc){
	 	 file action="upload" destination="#expandPath("/upload")#" filefield="jarupload" result="local.uploadresult" nameconflict="overwrite";
		var filename = uploadresult.serverfile;
		var extensionName = rc.name;
		variables.man.addBinaryFile(extensionName, expandPath("/upload/#filename#"), "jars")
		rc.data = "Jar #filename# has been added";

		variables.fw.setview("util.plain");
		request.layout = false;
		
	 }
	 
	 function addFunction(rc){
	 	file action="upload" destination="#expandPath("/upload")#" filefield="functionUpload" result="local.uploadresult" nameconflict="overwrite";
		var funcname = uploadresult.serverfile;
		var extensionName = rc.name;
		var content = FileRead(expandPath("/upload/#uploadresult.serverfile#"));
		variables.man.addTextFile(extensionName, "functions", funcname, content);
		rc.response = "Function #funcname# has been added";
	 }
	 
	 
	 function steps(any rc){
	 	 //get the stepXML and rationalise it a but maybe?
	 	 var config = variables.man.getConfig(rc.name);
	 	 rc.stepsinfo = [];
	 	 
	 	 for(var c in config.config.XMLChildren){
	 	 	 	 if(c.xmlName EQ "step"){
	 	 	 	 	 	ArrayAppend(rc.stepsinfo, c);
	 	 	 	 }
	 	 }
	 }
	 
	 
	 function editStep(any rc){
		if(rc.step EQ 0){
			rc.label = "";
			rc.description = "";
			rc.groups = [];
			return;
		}
		
	 	 rc.stepxml = XMLSearch(variables.man.getConfig(rc.name), "//step[#rc.step#]");
	 	 rc.label = rc.stepxml[1].XMLAttributes['label'];
	 	 rc.description = rc.stepxml[1].XMLAttributes.description;
		 rc.groups = rc.stepxml[1].XMLChildren;
	 }
	 
	 function saveStep(any rc){
	 	 variables.man.saveStep(rc.name, rc.step, rc.label, rc.description);
	 	 variables.fw.redirect("extension.steps?name=#rc.name#&message=Step Saved");
	 }
	 
	 function editGroup(any rc){
	 	var stepXML = variables.man.getConfig(rc.name);
		rc.groupxml = xmlSearch(stepXML, "//step[#rc.step#]/group[#rc.group#]")[1]; //first one that has been found
		rc.label = rc.groupxml.XmlAttributes.label;
		rc.description = rc.groupxml.XmlAttributes.description;
		rc.fields = rc.groupXML.XMLChildren;
	 }
	 
	 function saveGroup(any rc){
	 	 variables.man.saveGroup(rc.name, rc.step, rc.group, rc.label, rc.description);
	 	 variables.fw.redirect("extension.editgroup?name=#rc.name#&step=#rc.step#&group=#rc.group#");
	 }
	
	 
	 function uploadapplication(any rc) {
	 	 file action="upload" destination="#expandPath("/upload")#" filefield="appzip" result="local.uploadresult" nameconflict="overwrite";
	 	 var appPath = expandPath("/upload/#uploadresult.serverfile#");
	 	 
		 variables.man.addBinaryFile(rc.name, appPath,  "applications");
 		variables.fw.redirect("extension.addapplication?name=#rc.name#&message=Application uploaded");
	 	 
	 }
	 
	 function addLicense(rc){
	 	//Check if we are choosing one..
	 	var licensetext = rc.license;
	 	if(Len(rc.license_link)){
	 		 var licenseinfo = ListToArray(rc.license_link, "|");
	 		 licensetext = licenseinfo[2] & Chr(13) & licenseinfo[1];
	 	}
	 	 
	 	variables.man.addTextFile(rc.name, "", "license.txt", licensetext);
	 	rc.message = "License has been added";
 		variables.fw.redirect("extension.license?name=#rc.name#&message=#rc.message#");
	 }

	function edittag(any rc){
		rc.tagcontent = variables.man.getFileContent(rc.name, "tags", rc.tag);
	}
	function editfunction(any rc){
		rc.functioncontent = variables.man.getFileContent(rc.name, "functions", rc.function);
	}
	function savetag(any rc){
		rc.tagcontent = variables.man.addTextFile(rc.name, "tags", rc.tag, rc.content);
		rc.message = "Tag file saved";
		variables.fw.redirect("extension.edittag?name=#rc.name#&tag=#rc.tag#&message=#rc.message#");
	}
	
	function savefunction(any rc){
		rc.tagcontent = variables.man.addTextFile(rc.name, "functions", rc.function, rc.content);
		rc.message = "Function file saved";
		variables.fw.redirect("extension.editfunction?name=#rc.name#&function=#rc.function#&message=#rc.message#");
	}
	
	/* 
	 	Delete items from an extension	
	 */
	 function removefunction(any rc){
	 	 variables.man.removeTextFile(rc.name, "functions", rc.function);
	 	 rc.message = "Function removed";
	 	 variables.fw.redirect("extension.addFunctions?name=#rc.name#&message=#rc.message#");
	 }
	function removetag(any rc){
	 	 variables.man.removeTextFile(rc.name, "tags", rc.tag);
	 	 rc.message = "Tag #rc.tag# removed";
	 	 variables.fw.redirect("extension.addtags?name=#rc.name#&message=#rc.message#");
	 }
	 
	 function removeJar(any rc){
	 	 variables.man.removeBinaryFile(rc.name, "jars", rc.jar);
	 	 	rc.message = "Jar #rc.jar# removed";
	 	 variables.fw.redirect("extension.addjars?name=#rc.name#&message=#rc.message#");
	 	 
	 }
}