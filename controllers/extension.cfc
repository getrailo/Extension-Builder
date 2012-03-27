component {

	function init(any fw){
		variables.fw  = fw;
	}
	
	void function before(any rc){
		//Called on every request before anything happens
		param name="rc.errors" default=[];
		param name="rc.js" default=[];
		
		
	}
	
	function provider(any rc){
		rc.extproviderURL = "http://#CGI.http_host#";
		if(CGI.server_port != "80"){
			rc.extproviderURL &= ":#CGI.SERVER_PORT#";
		}
		rc.extproviderURL &= "/ExtensionProvider.cfc";
	}
	
	function list(any rc){
		var ep = new ExtensionProvider();
		rc.extensions = ep.listApplications();
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
		}
		var man = application.di.getBean("ExtensionManager");
		rc.info = man.createNewExtension( rc.name, rc.label);
		
		
	}
	
	function saveInfo(any rc) {
		
	}
	
	function edit(any rc) {
		var man = application.di.getBean("ExtensionManager");
		rc.info = man.getInfo(rc.name);
		
	}
	
	function installprovider(any rc){
		param name="rc.serverpass" default="";
		param name="rc.webpass" default="";

		var extproviderURL = "http://#CGI.http_host#";
		
		if(CGI.server_port != "80"){
			extproviderURL &= ":#CGI.SERVER_PORT#";
		}
		
		extproviderURL &= "/ExtensionProvider.cfc";
			
		admin action="updateExtensionProvider" type="server" password="#rc.serverpass#" url="#extproviderURL#";
		
		admin action="updateExtensionProvider" type="web" password="#rc.webpass#" url="#extproviderURL#";


	dump(rc);
	abort;	
	}

}