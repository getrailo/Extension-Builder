component {

	function init(any fw){
		variables.fw  = fw;
	}

	function default(any rc){
		rc.baseurl = "http://#CGI.http_host##request.webRootPath#";
		
		rc.extproviderURL = rc.baseurl & "ExtensionProvider.cfc";
		rc.extInfo = _getExtensionInfo();
	}
	
	function _getExtensionInfo()
	{
		var data = {};
		var extProvFilePath = '#request.absRootPath#ExtensionProvider.cfc';
		// get the raw cfml data from the extension provider (needed because we want to show '#cgi.http_host#' instead of 'www.test.me')
		var rawData = reMatch('<c'&'fset variables.extensionInfo([^>]|\r|\n)+>', fileRead(extProvFilePath));
		// data not found?
		if (not arrayLen(rawData))
		{
		throw("sdfsdfsd");
			return data;
		}
		rawData = rawData[1];
		// remove the opening and closing part of the struct
		rawData = trim(rereplace(rawData, '(<.*?\{|\}.*?>)', '', 'all'));
		// loop over the lines: key: value pairs
		var lines = listToArray(rawData, "#chr(10)##chr(13)#");
		for (var i=1; i lte arrayLen(lines); i++)
		{
			// remove tabs etc, and remove comma at the beginning of the line
			var line = rereplace(trim(lines[i]), "^, *", "");
			if (find(':', line))
			{
				data[trim(listFirst(line, ':'))] = rereplace(trim(listRest(line, ':')), '(^[''"]|[''"]$)', '', 'all');
			}
		}
		return data;
	}
	
	function saveExtensionInfo(any rc)
	{
		var data = _getExtensionInfo();
		var cfmText = "<c"&"fset variables.extensionInfo = {";
		var keynum = 0;
		for (var key in data)
		{
			if (structKeyExists(rc, key))
			{
				data[key] = rc[key];
			}
			cfmText &= "#server.separator.line#		#++keynum gt 1 ? ',':' '# #lCase(key)#: '" & replaceList(data[key], "<,>,'", "&lt;,&gt;,''") & "'";
		}
		var cfmText &= "#server.separator.line#	} />";
		var extProvFilePath = '#request.absRootPath#ExtensionProvider.cfc';
		var origExtProvCode = fileRead(extProvFilePath);
		var newExtProvCode = rereplace(origExtProvCode, '<c'&'fset variables.extensionInfo([^>]|\r|\n)+>', cfmText);
		fileWrite(extProvFilePath, newExtProvCode);
		
		// check if it still works
		try {
			var temp = createObject("component", "#request.cfcRootPath#ExtensionProvider");
		}
		catch (any e)
		{
			fileWrite(extProvFilePath, origExtProvCode);
			variables.fw.redirect("provider?error=#URLEncodedFormat('The details you provided would crash the ExtensionProvider.cfc, and have not been saved.<br />The error: #e.message# #e.detail#')#");
		}
		
		variables.fw.redirect("provider?message=The extensionProvider info has been updated");
	}
		
	
	function install(any rc){
		param name="rc.serverpass" default="";
		param name="rc.webpass" default="";

		var extproviderURL = "http://#CGI.http_host##request.absRootPath#";
	
		
		extproviderURL &= "ExtensionProvider.cfc";
			
		admin action="updateExtensionProvider" type="server" password="#rc.serverpass#" url="#extproviderURL#";
		
		admin action="updateExtensionProvider" type="web" password="#rc.webpass#" url="#extproviderURL#";
		
		variables.fw.redirect("provider");
		
	}
	
}