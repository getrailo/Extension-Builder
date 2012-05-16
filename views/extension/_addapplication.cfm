<cfoutput>
	<cfif rc.info.type neq "web">
		<div class="warning">Please note: if you want this extension to install an application,
			then the Admin type of the extension will be changed to "web".
		</div>
	</cfif>
	<p>Here you can add an application to your Extension. You can do this by simply zipping up your application and adding it here. </p>
		<form action="#buildURL("extension.uploadapplication")#" class="well form-inline <!--- progressuploader --->" method="post" enctype="multipart/form-data">
			<label>Application to upload</label>
			  <input type="hidden" name="name" value="#rc.name#">
			  <input type="file" class="span3 uploadfield" name="appzip" placeholder="Select the application zip file">
			<input type="submit" class="btn" value="Add Application">
			</form>
		<div class="progress progress-striped active hide">
	  		<div class="bar" style="width: 0%;"></div>
	  	</div>
	  	<div class="alert alert-success hide" id="upload_success"></div>
</cfoutput>