component extends="baseextension"
{
	
	function init(any fw){
		variables.fw  = fw;
		// variables.man =  application.di.getBean("ExtensionManager");
		variables.man = createObject("component", "#request.cfcRootPath#ExtensionManager");
	}
	
	/*
		Lists and shows the upload form for a plugin.zip
	*/
	function default(any rc){

        var plugins = variables.man.listFolderContents(rc.name, "plugins");
		rc.plugins = [];
		for (var plugin in plugins)
		{
			if (listLast(plugin, '.') eq "lnk")
			{
				arrayAppend(rc.plugins, {type:"URL", name:plugin, url:variables.man.getFileContent(rc.name, "plugins", plugin)});
			} else
			{
				arrayAppend(rc.plugins, {type:"file", name:plugin});
			}
		}
		rc.steps = XMLSearch(variables.man.getConfig(rc.name), "//step");
	}

    /*
        Uploads
    */
    function upload(any rc){
        var type = "plugin";
        //Check that there is plugin name etc.
        if(!structKeyExists(rc, "pluginName") OR !len(rc.pluginName)){
            variables.fw.redirect("plugins.default?name=#rc.name#&error=#urlencodedformat('The name for the plugin you provided is not valid or empty')#");
        }



        if (rc.plugintype eq "url"){
            if (isValid("url", rc.pluginurl)){
                  var pluginName = rc.pluginName;
                  var filepath = "#getTempDirectory()##rc.pluginName#.lnk";
                    fileWrite(filepath, rc.pluginURL);
                    variables.man.addFile(rc.name, filepath, "#type#s");
                    rc.response = "The #type# URL has been added";
            }
            else {
                variables.fw.redirect("plugins.default?name=#rc.name#&error=#urlencodedformat('The URL [#rc.pluginurl#] you provided is not valid')#");
            }


        }
        else{
            _uploadFile(rc, "pluginzip", "plugin", "zip", false);
            if (structKeyExists(rc, "uploadFailed")) {
                variables.fw.redirect("extension.add#type#s?name=#rc.name#&error=#rc.response#");
            }
            rc.response = "The #type# zip file has been added";
        }

         variables.fw.redirect("plugins.default?name=#rc.name#&message=#rc.response#");

    }

    function remove(any rc){
      variables.man.removeFile(rc.name, "plugins", rc.plugin);
 		variables.fw.redirect("plugins.default?name=#rc.name#&message=The plugin has been removed");
    }
}