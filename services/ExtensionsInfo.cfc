component {
    //TODO: convert this to a DI action
    //this is not really the right place for this. This is really the configuration, so we should do DI for this
	variables.validExtensionFields = "author,email,category,support,description,mailinglist,name,documentation,image,label,type,railo-version,version,paypal,packaged-by,licenseTemplate,StoreID,auto_version_update";

    function getValidExtensionFields(){
        return variables.validExtensionFields;
    }
}
