component extends="basecontroller"
{

	variables.availableActions = ListToArray("validation,before_install,after_install,update,before_uninstall,after_uninstall,additional_functions");

	function init(any fw){
		variables.fw  = fw;
		variables.man =  application.di.getBean("ExtensionManager");
        variables.validExtensionFields =  variables.man.getValidExtensionFields();

	}
	

    //before() moved to basecontroller

	function default(any rc){
		rc.extensions = _getAvailableExtensions();
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
		param name="rc.auto_version_update" default="false";

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
			if(!ListFindNoCase(variables.validExtensionFields, c)){
				StructDelete(dataToSend, c);
			}
		}

		/* check if the railo-version is in correct format */
		local.railoversion = StructKeyExists(dataToSend, "railo_version") ? dataToSend['railo_version']: "";
        if(!checkField("versionNumber",  local.railoversion)){
	        rc.error = "The Railo version number must be in the format 4.0.0.0";
	        edit(arguments.rc);
			variables.fw.setView("extension.edit");
	        /* copy current form data to rc.info */
	        for (local.key in rc.info)
	        {
		        if (structkeyexists(rc, local.key))
		        {
			        rc.info[local.key] = rc[local.key];
		        }
	        }
	        return;
        }

		rc.info = variables.man.saveInfo(rc.name, dataToSend);
		rc.message = "The information has been saved to the extension";

		/* check if a license already exists. if not, go there. */
		if (variables.man.getLicenseText(rc.name) eq "")
		{
			variables.fw.redirect("extension.license?name=#rc.name#&message=#rc.message#");
		}

		variables.fw.redirect("extension.edit?name=#rc.name#&message=#rc.message#");
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
		rc.info.hasApplication = hasApplication(rc.name);

		rc.extensions = _getAvailableExtensions();

		// option to pre-fill form with values of existing extension
		if (structKeyExists(rc, "prefillfrom") && rc.prefillfrom neq "")
		{
			rc.overrideData = variables.man.getInfo(rc.prefillfrom);
			_overrideEmptyValues(rc.info, rc.overrideData);
		}
	}

	function hasApplication(string name)
	{
		var extFile = 'zip://#expandPath("/ext/#arguments.name#.zip")#';
		return directoryExists(extFile & "!/applications") and arrayLen(directoryList(extFile & "!/applications",false,"name")) gt 0;
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
		variables.fw.redirect("extension.addApplications?name=#rc.name#&message=#rc.message#");
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
		var apps = variables.man.listFolderContents(rc.name, "applications");
		rc.application = [];
		for (var app in apps)
		{
			if (listLast(app, '.') eq "lnk")
			{
				arrayAppend(rc.application, {type:"URL", name:app, url:variables.man.getFileContent(rc.name, "applications", app)});
			} else
			{
				arrayAppend(rc.application, {type:"file", name:app});
			}
		}
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
		var type = "application";

		if (rc.apptype eq "url")
		{
			if (isValid("url", rc.appurl))
			{
				var appname = listLast(rc.appurl, "/");
				var filepath = "#getTempDirectory()##appname#.lnk";
				fileWrite(filepath, rc.appurl);
				variables.man.addFile(rc.name, filepath, "#type#s");
				rc.response = "The #type# URL has been added";
			} else
			{
				variables.fw.redirect("extension.add#type#s?name=#rc.name#&error=#urlencodedformat('The URL [#rc.appurl#] you provided is not valid')#");
			}
		} else
		{
			// upload, but do not redirect yet
			_uploadFile(rc, "appzip", "application", "zip", false);
			if (structKeyExists(rc, "uploadFailed"))
			{
				variables.fw.redirect("extension.add#type#s?name=#rc.name#&error=#rc.response#");
			}
		}

		// update the install type of the extension to Web
		if (rc.info.type neq "web")
		{
			variables.man.saveInfo(rc.name, {name:rc.name, type:"web"});
			rc.response &= "<br /><br />The Admin type for this extension is now changed from [#rc.info.type#] to [web], because an application can only be installed for a web context.";
		}
		variables.fw.redirect("extension.addapplications?name=#rc.name#&message=#rc.response#");
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
	 * Config.xml
	 **/
	
	function editconfig(any rc){
		///need to load up from XML file
		rc.config_xml = variables.man.getFileContent(rc.name, "", "config.xml");
	}

    function editinstall(any rc){
        rc.install_cfc =  variables.man.getFileContent(rc.name, "", "Install.cfc");
    }
	
	function saveconfig(any rc){
		variables.man.setConfig(rc.name, XMLParse(rc.config_xml));
		variables.fw.redirect("extension.editconfig?name=#rc.name#&message=The config has been saved");
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

	function removeStep(any rc)
	{
		variables.man.removeStep(rc);
		variables.fw.redirect("extension.steps?name=#rc.name#&message=The step has been removed");
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

	function removeGroup(any rc)
	{
		variables.man.removeGroup(rc);
		variables.fw.redirect("extension.steps?name=#rc.name#&step=#rc.step#&message=The group has been removed");
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
			/* change the datasource select to different type */
			if (rc.item.type eq 'select' and structKeyExists(rc.item, 'dynamic') and rc.item.dynamic eq 'listDatasources')
			{
				rc.item.type = 'datasource selection';
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

	function removefield(any rc)
	{
		variables.man.removeField(rc);
		variables.fw.redirect("extension.steps?name=#rc.name#&step=#rc.step#&group=#rc.group#&message=The field has been removed");
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
		_updateTextFile(rc, "function");
	}

		
	/*
		Helper functions
	*/
	function _getEncryptedData()
	{
		var file = expandPath('/localdata/secureddata.txt');
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
			fileDelete(file);
			return {};
		}
	}

	function _setEncryptedData(struct data)
	{
		var file = expandPath('/localdata/secureddata.txt');
		var data = serialize(data);
		data = encrypt(data, getRailoID().web.id, "CFMX_COMPAT", "Base64");
		fileWrite(file, data);
	}

	function _updateTextFile(any rc, String type)
	{
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



	private Array function _getAvailableExtensions()
	{
		var ret = [];
		var ep = new ExtensionProvider();
		var remoteExtensions = ep.listApplications();

		loop query="remoteExtensions"{
			var ext = {};
			ext.info = QuerySlice(remoteExtensions,remoteExtensions.currentrow,1);
			ext.capabilities = variables.man.getCapability(ext.info.name);
			ext.datelastmodified = variables.man.getDLM(ext.info.name);
			ArrayAppend(ret, ext);
		}
		return ret;
	}

	private void function _overrideEmptyValues(required Struct old, required Struct new)
	{
		for (var key in arguments.new)
		{
			if (not structKeyExists(arguments.old, key) or arguments.old[key] eq "")
			{
				arguments.old[key] = arguments.new[key];
			}
		}
	}

}