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
}

