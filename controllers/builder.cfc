component {
	
	function step1(any rc){
		//Need to create the config.xml from the information provided
		var uuid = CreateUUID();
		var xmlTmpl = FileRead("config.template.xml");
			xmlConfig = Replace(xmlTmpl, "${id}", uuid, "all");
		var replacements = ListToArray("id,version,name,type,label,description,created,category,author,image,mailinglist,support,documentation";
		
		for(r in replacements){
		
			if(StructKeyExists(rc, r)){
				xmlConfig = Replace(xmlConfig, "${#r#}", r, "all");
			}
		
		}
		
			
		dump(xmlConfig);		
	
		dump(rc);
		abort;
	
	}

}