component{

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



    boolean function checkField(type, value){

        if(ListFind("any,array,binary,boolean,component,creditcard,date,time,email,eurodate,float,numeric,guid,integer,query,range,regex,ssn,string,struct,telephone,URL,UUID,USdate,variableName,zipcode", type)){
           return isValid(type, value);
        }

        if(type EQ "versionNumber"){

            if(!Len(value)){
                return true;
            }
            if(ListLen(value, ".") NEQ 4){
                return false;
            }

            loop list="#value#" delimiters="." index="local.i"{
                if(!isNumeric(local.i)){
                    return false;

                }
            }
        }
        return true;
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

