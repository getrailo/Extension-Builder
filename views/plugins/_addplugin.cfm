<cfoutput>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			$(function(){
				$('##plugintypeurl,##plugintypefile').click(function(){
					var pluginfield = $('##pluginzip');
					var urlfield = $('##pluginurl');
					if ($('##plugintypefile:checked').length)
					{
						pluginfield.show().prop('disabled', null);
						urlfield.hide().prop('disabled', 'disabled');
					} else
					{
						urlfield.show().prop('disabled', null);
						pluginfield.hide().prop('disabled', 'disabled');
					};
				}).filter(':first').triggerHandler('click');
			});
		</script>
	</cfsavecontent>
	<cfparam name="rc.js" default="#[]#">
	<cfset arrayAppend(rc.js, js) />

	<p>Here you can add a Railo Administrator plugin to your Extension.
        You can do this by simply zipping up your plugin and adding it here, or by providing a URL to a zip file.
    </p>

    <hr />
	<form action="#buildURL("plugins.upload")#" class="<!--- well form-inline progressuploader --->" method="post" enctype="multipart/form-data">
		<input type="hidden" name="name" value="#rc.name#" />

		<div class="row-fluid">
			<div class="span12">
				<cfset plugintype = "file" />
				<div class="control-group">
					<label>Plugin</label>
					<div>
						<label style="float:left;">
							<input type="radio" name="plugintype" style="display:inline;" id="plugintypeurl" value="url"<cfif plugintype eq 'url'> checked</cfif> />
							URL &nbsp; &nbsp;
						</label>
						<label style="float:left;">
							or &nbsp; <input type="radio" name="plugintype" style="display:inline;" id="plugintypefile" value="file"<cfif plugintype eq 'file'> checked</cfif> />
							File
						</label>
						<br clear="all" />
					</div>


                    <div class="control-group">
                        <label for="label"> Name <i class="icon-question-sign" title="Plugin Name" data-content="This is the unique name of your plugin. It will be displayed in the navigation" ></i></label>
                        <input type="text" name="pluginName" value="" class="span4" id="pluginName" placeholder="MyPlugin">
                    </div>

					<input type="text" name="pluginurl" value="" id="pluginurl" class="span6" placeholder="http://mydomain.com/plugin.zip" />
					<input type="file" name="pluginzip" id="pluginzip" class="span4" />
				</div>
			</div>
		</div>

		<div class="row-fluid">
			<div class="span12">
				<div class="form-actions">
					<input type="submit" class="btn btn-primary" value="Add Plugin" />
				</div>
			</div>
		</div>
	</form>
<!---	<div class="progress progress-striped active hide">
		<div class="bar" style="width: 0%;"></div>
	</div>
	<div class="alert alert-success hide" id="upload_success"></div>--->
</cfoutput>