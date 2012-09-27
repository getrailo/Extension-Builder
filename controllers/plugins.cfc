component extends="basecontroller"{
	
	function init(any fw){
		variables.fw  = fw;
		variables.man =  application.di.getBean("ExtensionManager");
	}
	
	/*
		Lists and shows the upload form for a plugin.zip
	*/
	function default(){
		
	}
}