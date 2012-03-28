component {


	function default(any rc){
		rc.baseurl = "http://#CGI.http_host#";
		if(CGI.server_port != "80"){
			rc.baseurl &= ":#CGI.SERVER_PORT#";
		}
		rc.extproviderURL = rc.baseurl & "/ExtensionProvider.cfc";
		
		
		
	}
	function install(any rc){
		param name="rc.serverpass" default="";
		param name="rc.webpass" default="";

		var extproviderURL = "http://#CGI.http_host#";
		
		if(CGI.server_port != "80"){
			extproviderURL &= ":#CGI.SERVER_PORT#";
		}
		
		extproviderURL &= "/ExtensionProvider.cfc";
			
		admin action="updateExtensionProvider" type="server" password="#rc.serverpass#" url="#extproviderURL#";
		
		admin action="updateExtensionProvider" type="web" password="#rc.webpass#" url="#extproviderURL#";
		
		
	}
	
}