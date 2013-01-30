component {

	function init(any fw){
		
		variables.fw  = fw;
	}
	

	
	function step1(any rc){
		//Need to create the config.xml from the information provided
		var uuid = CreateUUID();
		var created = Now();
		var xmlTmpl = FileRead("config.template.xml");
		var	xmlConfig = Replace(xmlTmpl, "${id}", uuid, "all");
			xmlConfig = Replace(xmlConfig, "${created}", created, "all");
		var replacements = ListToArray("id,version,name,email,type,label,description,created,category,author,image,mailinglist,support,documentation");
		
		for(r in replacements){
		
			if(StructKeyExists(rc, r)){
				xmlConfig = Replace(xmlConfig, "${#r#}", rc[r], "all");
			}
		
		}
		
		//Create a new file name after the name
		zip action="zip" file="#request.absRootPath#ext/#rc.name#.zip"{
			zipparam content=xmlConfig entrypath="config.xml";
		}
		//Now forward to the edit screen... 
		variables.fw.redirect("extension.edit?extension=#rc.name#");
		
		
	}

}
