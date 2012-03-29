component {

	function init(any fw){
		variables.fw  = fw;
		variables.man =  application.di.getBean("ExtensionManager");
	}
	
	void function before(any rc){
		//Called on every request before anything happens
		param name="rc.errors" default=[];
		param name="rc.js" default=[];
		param name="rc.message" default="";
		
	}

	void function default(any rc){
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
		
		for(c in dataToSend){
				if(!ListFindNoCase(validFields,c)){
						StructDelete(dataToSend, c);
				}
		}
		
		rc.info = variables.man.saveInfo(rc.name, dataToSend);
		rc.message = "The information has been saved to the extension";
		variables.fw.redirect("extension.edit?name=#rc.name#&message=#rc.message#");
	}
	
	function edit(any rc) {
		var man = application.di.getBean("ExtensionManager");
		rc.info = man.getInfo(rc.name);
		
	}
	
	
	function license(any rc){
		rc.license = variables.man.getFileContent(rc.name, "", "license.txt");
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
	 
	 function addTag(rc){
		file action="upload" destination="#expandPath("/upload")#" filefield="tagUpload" result="local.uploadresult" nameconflict="overwrite";
		var tagname = uploadresult.serverfile;
		var extensionName = rc.name;
		var content = FileRead(expandPath("/upload/#uploadresult.serverfile#"));
		variables.man.addTextFile(extensionName, "tags", tagname, content);
		rc.response = "Tag #tagname# has been added";
	 	 
	 }
	 
	 function addFunction(rc){
	 	file action="upload" destination="#expandPath("/upload")#" filefield="functionUpload" result="local.uploadresult" nameconflict="overwrite";
		var funcname = uploadresult.serverfile;
		var extensionName = rc.name;
		var content = FileRead(expandPath("/upload/#uploadresult.serverfile#"));
		variables.man.addTextFile(extensionName, "functions", funcname, content);
		rc.response = "Function #funcname# has been added";
	 }
	 
	 function addLicense(rc){
	 	variables.man.addTextFile(rc.name, "", "license.txt", rc.license);
	 	rc.message = "License has been added";
 		variables.fw.redirect("extension.license?name=#rc.name#&message=#rc.message#");
	 }

	function edittag(any rc){
		rc.tagcontent = variables.man.getFileContent(rc.name, "tags", rc.tag);
	}
	function savetag(any rc){
		rc.tagcontent = variables.man.addTextFile(rc.name, "tags", rc.tag, rc.content);
		rc.message = "Tag file saved";
		variables.fw.redirect("extension.edittag?name=#rc.name#&tag=#rc.tag#&message=#rc.message#");
	}
	
	/* 
	 	Delete items from an extension	
	 */
	 function removefunction(any rc){
	 	 variables.man.removeTextFile(rc.name, "functions", rc.function);
	 	 rc.message = "Function removed";
	 	 variables.fw.redirect("extension.addFunctions?name=#rc.name#&message=#rc.message#");
	 }
	
}