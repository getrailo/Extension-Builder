component extends="basecontroller"
{

    function before(any rc){
	    super.before(rc);

		//test if we are getting a specific extension
        if(StructKeyExists(rc, "name") AND ListLast(rc.action, ".") != "create"){
            rc.info = variables.man.getInfo(rc.name);
            rc.hasLinkFiles = this.hasLinkFiles(rc.name);
        }
    }

	public Boolean function hasLinkFiles(String name)
	{
		loop list="applications,plugins" index="local.type"
		{
			if (not arrayIsEmpty(getLinkFiles(arguments.name, local.type)))
			{
				return true;
			}
		}
		return false;
	}

	private Array function getLinkFiles(String name, String type)
	{
		local.ret = [];
		var files = variables.man.listFolderContents(arguments.name, arguments.type);
		for (var file in files)
		{
			if (listLast(file, '.') eq "lnk")
			{
				arrayAppend(local.ret, trim(variables.man.getFileContent(arguments.name, arguments.type, file)));
			}
		}
		return local.ret;
	}


}