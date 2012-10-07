<cftry>

<cfsetting requesttimeout="9999" />
<!--- first login, without redirection.
That way, if we get a 301/302 redirect to the 'returnURL', we are logged in.
Otherwise, we are not. --->
<cfset var redirectURL = "http://www.getrailo.org/index.cfm/extensions/for-developers/?gfa=addGadget" />
<cfset var cfhttp = "" />

<cfhttp method="post" url="http://www.getrailo.org/index.cfm/extensions/for-developers/?nocache=1"
redirect="no" throwonerror="no">
	<cfhttpparam type="formfield" name="username" value="#rc.storeInfo.getrailo_user#" />
	<cfhttpparam type="formfield" name="password" value="#rc.storeInfo.getrailo_pass#" />
	<cfhttpparam type="formfield" name="rememberMe" value="1" />
	<cfhttpparam type="formfield" name="doaction" value="login" />
	<cfhttpparam type="formfield" name="linkServID" value="" />
	<cfhttpparam type="formfield" name="returnURL" value="#redirectURL#" />
</cfhttp>

<!--- login succeeded? --->
<cfif cfhttp.status_code eq "302" and structKeyExists(cfhttp.responseheader, "Location") and cfhttp.responseheader.Location eq redirectURL>
	<!--- upload the extension, either update or add --->
	<cfhttp method="post" url="http://www.getrailo.org/index.cfm/extensions/for-developers/?gfa=manageSDKGadget&requestTimeout=9999"
	redirect="no" throwonerror="no" resolveurl="yes" multipart="yes">
		<!--- use the login cookies --->
		<cfloop array="#cfhttp.responseheader['set-cookie']#" index="cook">
			<cfset cook = trim(listfirst(cook, ';')) />
			<cfhttpparam type="cookie" name="#listfirst(cook, '=')#" value="#listrest(cook, '=')#" />
		</cfloop>
		<cfhttpparam type="file" name="gadgetFile" file="#expandPath('/ext/#rc.name#.zip')#" />
		<cfhttpparam type="formfield" name="tac" value="1" />
		<cfhttpparam type="formfield" name="gadgetDisplay" value="1" />
		
		<cfhttpparam type="formfield" name="gadgetID" value="#structKeyExists(rc.info, 'storeID') ? rc.info.storeID : ''#" />
	</cfhttp>
	<!--- save the gadgetID, if we don't have one now --->
	<cfif (not structKeyExists(rc.info, 'storeID') or rc.info.storeID eq "") and structKeyExists(cfhttp, "filecontent")>
		<cfset var theID = rematch('GADGETID_FOR_SDK:[^ ]+', cfhttp.filecontent) />
		<cfif arrayLen(theID)>
			<cfset variables.man.saveInfo(rc.name, {name:rc.name, "storeID":listRest(theID[1], ':')}) />
		</cfif>
	</cfif>

	<!--- save the result of the upload --->
	<cfset rc.publishresult = cfhttp.FileContent />
<cfelse>
	<cfset rc.loginFailed = 1 />
</cfif>

<cfcatch><cfdump var="#cfcatch#" abort /></cfcatch></cftry>