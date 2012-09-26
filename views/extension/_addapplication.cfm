<cfoutput>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			$(function(){
				$('##apptypeurl,##apptypefile').click(function(){
					var appfield = $('##appzip');
					var urlfield = $('##appurl');
					if ($('##apptypefile:checked').length)
					{
						appfield.show().prop('disabled', null);
						urlfield.hide().prop('disabled', 'disabled');
					} else
					{
						urlfield.show().prop('disabled', null);
						appfield.hide().prop('disabled', 'disabled');
					};
				}).filter(':first').triggerHandler('click');
			});
		</script>
	</cfsavecontent>
	<cfparam name="rc.js" default="#[]#">
	<cfset arrayAppend(rc.js, js) />

	<cfif rc.info.type neq "web">
		<div class="warning">Please note: if you want this extension to install an application,
			then the Admin type of the extension will be changed to "web".
		</div>
	</cfif>
	<p>Here you can add an application to your Extension. You can do this by simply zipping up your application and adding it here, or provide a URL to a zip file.</p>
	<hr />
	<form action="#buildURL("extension.uploadapplication")#" class="<!--- well form-inline progressuploader --->" method="post" enctype="multipart/form-data">
		<input type="hidden" name="name" value="#rc.name#" />

		<div class="row-fluid">
			<div class="span12">
				<cfset apptype = "file" />
				<div class="control-group">
					<label>Application</label>
					<div>
						<label style="float:left;">
							<input type="radio" name="apptype" style="display:inline;" id="apptypeurl" value="url"<cfif apptype eq 'url'> checked</cfif> />
							URL &nbsp; &nbsp;
						</label>
						<label style="float:left;">
							or &nbsp; <input type="radio" name="apptype" style="display:inline;" id="apptypefile" value="file"<cfif apptype eq 'file'> checked</cfif> />
							File
						</label>
						<br clear="all" />
					</div>
					<input type="text" name="appurl" value="" id="appurl" class="span6" placeholder="http://mydomain.com/extension.zip" />
					<input type="file" name="appzip" id="appzip" class="span4" />
				</div>
			</div>
		</div>

		<div class="row-fluid">
			<div class="span12">
				<div class="form-actions">
					<input type="submit" class="btn btn-primary" value="Add Application" />
				</div>
			</div>
		</div>
	</form>
<!---	<div class="progress progress-striped active hide">
		<div class="bar" style="width: 0%;"></div>
	</div>
	<div class="alert alert-success hide" id="upload_success"></div>--->
</cfoutput>