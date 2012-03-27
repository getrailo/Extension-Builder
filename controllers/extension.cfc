component {

	function init(any fw){
		variables.fw  = fw;
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