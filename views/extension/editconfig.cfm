<cfsavecontent variable="local.js">
	<script language="Javascript" type="text/javascript" src="js/editarea_0_8_2/edit_area/edit_area_full.js"></script>
	<script language="Javascript" type="text/javascript">
		// initialisation
		editAreaLoader.init({
			id: "config_xml"	// id of the textarea to transform
			,start_highlight: true	// if start with highlight
			,allow_resize: "both"
			,allow_toggle: false
			,word_wrap: true
			,language: "en"
			,syntax: "xml"
		});
	</script>
</cfsavecontent>
<cfset arrayAppend(rc.js, local.js) />

<cfoutput>
	<cfparam name="rc.config_xml" default="">

	<h1>Manually edit the config.xml</h1>
	<hr />
	<form action="#buildURL("extension.saveconfig")#" method="post" class=" well">
		<fieldset>
			<input type="hidden" name="name" value="#rc.name#">
			<div>
				<!---<label>Configuration details</label>--->
				<textarea name="config_xml" id="config_xml" class="span12" rows="25">#rc.config_xml#</textarea>
			</div>
			<div class="form-actions">
				<button class="btn btn-primary" type="submit" >Save</button>
				<a class="btn btn-cancel" href="#buildURL("extension.edit")#&name=#rc.name#">Cancel</a>
			</div>
		</fieldset>
	</form>
</cfoutput>