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
	

	function delete(any rc) {
		// do not delete? 
		if (structKeyExists(rc, "notsure"))
		{
			variables.fw.redirect("extension");
			return;
		}
		
		// get info
		rc.info = variables.man.getInfo(rc.name);
		// yes, delete
		if (structKeyExists(rc, "sure"))
		{
			// check for the accompanying img
			if (rc.info.image neq "" and not isValid('url', rc.info.image) and fileExists(expandPath('/ext/#rc.info.image#')))
			{
				fileDelete(expandPath('/ext/#rc.info.image#'));
			}
			fileDelete(expandPath('/ext/#rc.name#.zip'));
			rc.message = "The extension has been deleted.";
			variables.fw.redirect("extension?message=#rc.message#");
		}

	}
	
	function edit(any rc) {
		// happens in 'before' fnc already
		//var man = application.di.getBean("ExtensionManager");
		//rc.info = man.getInfo(rc.name);
	}
	
	
	/*
		License
	*/
	function license(any rc) {
		//var man = application.di.getBean("ExtensionManager");
		//rc.info = man.getInfo(rc.name);
		rc.info.licenseText = man.getLicenseText(rc.name);
	}

	function licenses(any rc){
		rc.data = variables.man.getLicense(rc.license);
		variables.fw.setView("util.plain");
		request.layout =false;
		
	}

	function saveLicense(any rc) {
		variables.man.saveInfo(rc.name, {name:rc.name, licenseTemplate:replace(rc.licenseTemplate, '.txt', '')});
		variables.man.setLicenseText(rc.name, rc.license);
		rc.message = "Your license text has been saved to the extension";
		variables.fw.redirect("extension.installactions?name=#rc.name#&message=#rc.message#");
	}
	
	
	
	/*
		Install actions
	*/

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
		Add Items to an extension 	
	*/
	
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
	
	/*
	 * if we are going to use the progressUploader again, with plain text response,
	 * then set the 5th argument 'doRedirect' of fnc _uploadFile to False
	*/
	function addTag(rc){
		_uploadFile(rc, "tagUpload", "tag", "cfc");
	}
	function addFunction(rc){
		_uploadFile(rc, "functionUpload", "function", "cfc");
	}
	function addJar(rc){
		_uploadFile(rc, "jarUpload", "jar", "jar");
	}
	function uploadapplication(any rc) {
		_uploadFile(rc, "appzip", "application", "zip");
	}
	
	
	/* 
		Delete items from an extension	
	*/
	function removefunction(any rc){
		variables.man.removeFile(rc.name, "functions", rc.function);
		rc.message = "Function <em>#rc.function#</em> is removed";
		variables.fw.redirect("extension.addFunctions?name=#rc.name#&message=#urlencodedformat(rc.message)#");
	}
	function removetag(any rc){
		variables.man.removeFile(rc.name, "tags", rc.tag);
		rc.message = "Tag <em>#rc.tag#</em> is removed";
		variables.fw.redirect("extension.addtags?name=#rc.name#&message=#urlencodedformat(rc.message)#");
	}
	function removejar(any rc){
		variables.man.removeFile(rc.name, "jars", rc.jar);
		rc.message = "Jar <em>#rc.jar#</em> is removed";
		variables.fw.redirect("extension.addjars?name=#rc.name#&message=#urlencodedformat(rc.message)#");
	}
	function removeapplication(any rc) {
		variables.man.removeFile(rc.name, "applications", rc.application);
 		variables.fw.redirect("extension.addapplication?name=#rc.name#&message=The application is removed");
	}
		
	
	
	/*
		Steps 
	*/
	function editStep(any rc){
		rc.stepxml = XMLSearch(variables.man.getConfig(rc.name), "//step[#rc.step#]");
		rc.label = rc.stepxml[1].XMLAttributes['label'];
		rc.description = rc.stepxml[1].XMLAttributes.description;
		rc.groups = rc.stepxml[1].XMLChildren;
	}
	
	function saveStep(any rc){
		variables.man.saveStep(rc.name, rc.step, rc.label, rc.description);
		variables.fw.redirect("extension.addApplication?name=#rc.name#");
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
	
	
	/*
		edit text files
	*/
	function edittag(any rc){
		rc.tagcontent = variables.man.getFileContent(rc.name, "tags", rc.tag);
	}
	function editfunction(any rc){
		rc.functioncontent = variables.man.getFileContent(rc.name, "functions", rc.function);
	}
	function savetag(any rc){
		_updateTextFile(rc, "tag");
	}
	function savefunction(any rc){
		_updateTextFile(rc, "functions");
	}

		
	/*
		Helper functions
	*/
	function _updateTextFile(any rc, String type)
	{
		rc.newname &= ".cfc";
		// delete old file if it has a new name now
		if (rc.newname neq rc[arguments.type])
		{
			variables.man.removeFile(rc.name, arguments.type & "s", rc[arguments.type]);
		}
		// add the file
		variables.man.addTextFile(rc.name, arguments.type & "s", rc.newname, rc.content);
		// relocate
		variables.fw.redirect("extension.add#arguments.type#s?name=#rc.name#&message=The #arguments.type# file is updated");
	}

	function _uploadFile(any rc, String formField, String type, String allowedExtensions, Boolean doRedirect=true)
	{
		rc.response = "";
		// check if upload file exists
		if (not structKeyExists(rc, formField) or rc[formField] eq "")
		{
			rc.response = "You have not uploaded a file!";
			if (doRedirect)
			{
				variables.fw.redirect("extension.add#type#s?name=#rc.name#&error=#rc.response#");
			}
			return;
		}
		// upload file
		file action="upload" destination="#GetTempDirectory()#" filefield="#formField#" result="local.uploadresult" nameconflict="overwrite";
		var appPath = "#uploadresult.serverdirectory##server.separator.file##uploadresult.serverfile#";
		// check for valid extension / iszipfile
		if (allowedExtensions neq "")
		{
			if (allowedExtensions eq "zip" and not isZipFile(appPath))
			{
				rc.response = "You can only upload zip files!";
			} else if (not listFindNoCase(allowedExtensions, uploadresult.serverfileext))
			{
				rc.response = "You can only add files with the following extension#listlen(allowedExtensions) gt 1 ? 's':''#: #replace(uCase(allowedExtensions), ',', ', ', 'all')#";
			}
			if (rc.response neq "")
			{
				fileDelete(appPath);
				if (doRedirect)
				{
					variables.fw.redirect("extension.add#type#s?name=#rc.name#&error=#rc.response#");
				}
				return;
			}
		}
		// add the file
		variables.man.addFile(rc.name, appPath,  "#type#s");
		rc.response = "The #type# has been added";
		if (doRedirect)
		{
			variables.fw.redirect("extension.add#type#s?name=#rc.name#&message=#rc.response#");
		}
		return;
	}
}