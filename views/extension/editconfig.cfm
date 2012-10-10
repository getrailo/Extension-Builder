<cfoutput>
	<cfparam name="rc.config_xml" default="">

	<h1>Manually edit the config.xml</h1>
	<form action="#buildURL("extension.saveconfig")#" method="post" class=" well">
		<fieldset>
			<input type="hidden" name="name" value="#rc.name#">
			<div>
				<label>Configuration details</label>
				<textarea name="config_xml" class="span10" rows="20">#rc.config_xml#</textarea>
			</div>
			<div class="form-actions">
				<button class="btn btn-primary" type="submit" >Save</button>
				<a class="btn btn-cancel" href="#buildURL("extension.edit")#&name=#rc.name#">Cancel</a>
			</div>
		</fieldset>
	</form>
</cfoutput>