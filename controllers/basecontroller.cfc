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
}

