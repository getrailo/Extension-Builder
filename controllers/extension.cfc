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
		var validFields = "author,category,support,description,mailinglist,name,documentation,image,label,type,version,paypal,packaged-by,licenseTemplate,StoreID";
		
		var dataToSend = duplicate(rc);
		
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
		
		//Error: java.util.ConcurrentModificationException
		var list = structKeyList(dataToSend);
		for (var i=listlen(list); i>0; i--)
		{
			c = listGetAt(list, i);
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
		// get info whether this ext installs an application.
		var extFile = 'zip://#expandPath("/ext/#rc.name#.zip")#';
		rc.info.hasApplication = directoryExists(extFile & "!/applications") and arrayLen(directoryList(extFile & "!/applications",false,"name")) gt 0;
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
	function addApplications(rc){
		rc.application = variables.man.listFolderContents(rc.name, "applications");	
		rc.steps = XMLSearch(variables.man.getConfig(rc.name), "//step");
	}
	
	/*
	 * if we are going to use the progressUploader again, with plain text response,
	 * then set the 5th argument 'doRedirect' of fnc _uploadFile to False
	*/
	function addTag(rc){
		_uploadFile(rc, "tagUpload", "tag", "cfc,cfm");
	}
	function addFunction(rc){
		_uploadFile(rc, "functionUpload", "function", "cfc,cfm");
	}
	function addJar(rc){
		_uploadFile(rc, "jarUpload", "jar", "jar");
	}
	function uploadapplication(any rc) {
		// upload, but do not redirect yet
		_uploadFile(rc, "appzip", "application", "zip", false);
		if (structKeyExists(rc, "uploadFailed"))
		{
			variables.fw.redirect("extension.add#type#s?name=#rc.name#&error=#rc.response#");
		} else
		{
			// update the install type of the extension to Web
			if (rc.info.type neq "web")
			{
				variables.man.saveInfo(rc.name, {name:rc.name, type:"web"});
				rc.response &= "<br /><br />The Admin type for this extension is now changed from [#rc.info.type#] to [web], because an application can only be installed for a web context.";
			}
			variables.fw.redirect("extension.add#type#s?name=#rc.name#&message=#rc.response#");
		}
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
 		variables.fw.redirect("extension.addapplications?name=#rc.name#&message=The application is removed");
	}
		
	
	
	/*
		Steps 
	*/
	
	function steps(any rc){
			rc.stepsinfo = XMLSearch(variables.man.getConfig(rc.name), "/config/step");
		
	}
	
	function editStep(any rc)
	{
		rc.stepxml = XMLSearch(variables.man.getConfig(rc.name), "/config/step");
		if (structKeyExists(rc, "step"))
		{
			rc.label = rc.stepxml[rc.step].XMLAttributes.label;
			rc.description = rc.stepxml[rc.step].XMLAttributes.description;
			rc.groups = rc.stepxml[rc.step].XMLChildren;
		// new step
		} else
		{
			rc.step = arrayLen(rc.stepxml)+1;
			rc.label = rc.description = '';
			rc.groups = [];
		}
	}
	
	function saveStep(any rc){
		variables.man.saveStep(rc.name, rc.step, rc.label, rc.description);
		variables.fw.redirect("extension.steps?name=#rc.name#");
	}
	
	function editGroup(any rc){
		var stepXML = variables.man.getConfig(rc.name);
		if (!structKeyExists(rc, "group"))
		{
			rc.group = 0;
		}
		var firstgroup = xmlSearch(stepXML, "/config/step[#rc.step#]/group[#rc.group#]");
		if (arrayLen(firstgroup))
		{
			rc.groupXml = firstgroup[1];//first one that has been found
			rc.fields = rc.groupXML.XMLChildren;
		} else
		{
			rc.fields = [];
		}
		rc.label = isDefined("rc.groupxml.XmlAttributes.label") ? rc.groupxml.XmlAttributes.label : "";
		rc.description = isDefined("rc.groupxml.XmlAttributes.description") ? rc.groupxml.XmlAttributes.description : "";
	}
	
	function saveGroup(any rc){
		variables.man.saveGroup(rc.name, rc.step, rc.group, rc.label, rc.description);
		variables.fw.redirect("extension.steps?name=#rc.name#&step=#rc.step#&group=#rc.group#");
	}
	
	
	function editField(any rc){
		var stepXML = variables.man.getConfig(rc.name);
		if (!structKeyExists(rc, "field"))
		{
			rc.field = 1;
		}
		var fields = xmlSearch(stepXML, "/config/step[#rc.step#]/group[#rc.group#]/item");
		if (arrayLen(fields) gte rc.field)
		{
			rc.item = {};
			for (var key in fields[rc.field].xmlAttributes)
			{
				rc.item[key] = fields[rc.field].xmlAttributes[key];
			}
			rc.item.options = "";
			if (arrayLen(fields[rc.field].xmlChildren))
			{
				for (var i=1; i lte arrayLen(fields[rc.field].xmlChildren); i++)
				{
					var fld = fields[rc.field].xmlChildren[i];
					rc.item.options &= chr(10) & (structKeyExists(fld.xmlAttributes, 'selected') ? '*':'') & fld.xmlAttributes['value'] & "|" & fld.xmlText;
				}
			} else 
			{
				rc.item.defaultvalue = fields[rc.field].xmlText;
			}
		} else
		{
			rc.item = {};
		}
	}
	
	function saveField(any rc){
		variables.man.saveField(rc);
		variables.fw.redirect("extension.steps?name=#rc.name#&step=#rc.step#&group=#rc.group#");
	}
	
	
	/*
		Publish to ext store
	*/
	function publish(any rc){
		rc.storeInfo = _getEncryptedData();
	}
	
	function savestorelogin(any rc){
		var data = _getEncryptedData();
		data.getrailo_user = rc.getrailo_user;
		data.getrailo_pass = rc.getrailo_pass;
		_setEncryptedData(data);
		variables.fw.redirect("extension.publish?name=#rc.name#&message=The login details have been saved");
	}
	
	function publishnow(any rc){
		rc.storeInfo = _getEncryptedData();
		if (not structKeyExists(rc.storeInfo, "getrailo_pass"))
		{
			variables.fw.redirect("extension.publish?name=#rc.name#&error=You have not yet saved your getrailo.org login details!");
		}
		// doing the actual cfhttp stuff
		include "inc_publishnow.cfm";
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
	function _getEncryptedData()
	{
		var file = expandPath('/SDKdata/secureddata.txt');
		if (!fileExists(file))
		{
			return {};
		}
		var data = fileRead(file);
		try {
			data = decrypt(data, getRailoID().web.id, "CFMX_COMPAT", "Base64");
			return evaluate(data);
		// file might have been moved to a new web context or been tampered with; delete it
		} catch(any)
		{
//			fileDelete(file);
			return {};
		}
	}

	function _setEncryptedData(struct data)
	{
		var file = expandPath('/SDKdata/secureddata.txt');
		var data = serialize(data);
		data = encrypt(data, getRailoID().web.id, "CFMX_COMPAT", "Base64");
		fileWrite(file, data);
	}

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
			rc.uploadFailed = 1;
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
				rc.uploadFailed = 1;
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