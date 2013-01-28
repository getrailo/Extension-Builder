<cffunction name="v" output="false">
	<cfargument name="f">
	<cfargument name="default">
	<cfreturn StructKeyExists(rc, f) ? Trim(rc[f]) : arguments.default />
</cffunction>

<cfsavecontent variable="local.js">
	<script type="text/javascript">
		$('#frequency').change(function(){
			$('#_every').css('display', ($(this).val() == 'every' ? 'block':'none'));
			$('#startlabel').html(($(this).val()=='every' ? 'Starting from:':'Running at:'));
		}).trigger('change');
		$('#enableautoupdate').change(function(){
			$('#_settings').css('visibility', ($(this).val() == 1 ? '':'hidden'));
			$('#auto_version_update').prop('disabled', ($(this).val()==0 ? null:'disabled'));
			if ($(this).val() == 1)
			{
				$('#auto_version_update').prop('checked', 1);
			}
		}).trigger('change');
	</script>
</cfsavecontent>
<cfset arrayAppend(rc.js, local.js) />

<cfoutput>
	<h1>Create an auto-update check for your extension</h1>
	<p>
		You added a URL for the Application or Plugin zip file.
		This zip file might change over time, for example when releasing a new version.<br />
		Underneath, you can add an auto-update check, which will check periodically if your zip file has changed.
		If a change is found, the version of your extension will be updated,
		and it will be uploaded to the Railo Extension Store (if you added your login details).
	</p>
	<hr />

	<form action="#buildURL("extension.autoupdatecheck?name=#rc.name#")#" method="post">
		<div class="row-fluid">
			<div class="span4">
				<fieldset>
					<div>
						<label for="enableautoupdate">Enable auto-update</label>
						<select name="enableautoupdate" id="enableautoupdate">
							<option value="0">No</option>
							<option value="1"<cfif v('enableautoupdate') eq 1> selected</cfif>>Yes</option>
						</select>
					</div>
					<div class="row">
						<div class="span2">
							<label for="version" class="control-label">Current version</label>
							<input type="text" name="version" value="#rc.info.version#" class="span2" id="version" placeholder="1.0.0">
						</div>
						<div class="span2">
							<label for="auto_version_update">Auto update version</label>
							<input type="checkbox" name="auto_version_update" value="true" id="auto_version_update"<cfif rc.info.auto_version_update eq 1> checked="checked"</cfif> />
							<i class="icon-question-sign" data-content="To use the auto-update functionality, the version number needs to be increased on every update of the extension (adding items, editing details, etc.)<br />The current date-time will be used for incrementing: 1.2.0 will become 1.2.<i>#dateformat(now(), 'yyyymmdd')##timeformat(now(), 'HHmmss')#</i>" title="Auto-update version"></i>
						</div>
					</div>

				</fieldset>
			</div>
			<div class="span8" id="_settings">
				<fieldset>
					<legend>Auto-update frequency</legend>
					<p>A Scheduled task will be created to do the auto-update check.
						You can define the interval here.
					</p>
					<div class="row">
						<div class="span3">
							<label for="frequency">Frequency</label>
							<select name="frequency" id="frequency" class="span3">
								<option value="daily">Daily</option>
								<cfloop from="1" to="7" index="daynum">
									<option value="weekly-#daynum#"<cfif v('frequency') eq 'weekly-#daynum#'> selected</cfif>>Weekly on #dayOfWeekAsString(daynum)#</option>
								</cfloop>
								<option value="every"<cfif v('frequency') eq 'every'> selected</cfif>>Every:</option>
							</select>
						</div>
						<div id="_every" class="span5">
							<label for="every_hours">Every:</label>
							<input type="text" name="every_hours" value="#v("every_hours", "1")#" id="every_hours" style="width:30px" /> hours,
							<input type="text" name="every_minutes" value="#v("every_minutes", "00")#" id="every_minutes" style="width:30px" /> minutes,
							<input type="text" name="every_seconds" value="#v("every_seconds", "00")#" id="every_seconds" style="width:30px" /> seconds
						</div>
					</div>
					<div>
						<label for="start_hours" id="startlabel">Running at:</label>
						<input type="text" name="start_hours" value="#v("start_hours", "00")#" id="start_hours" style="width:30px" /> :
						<input type="text" name="start_minutes" value="#v("start_minutes", "00")#" id="start_minutes" style="width:30px" /> :
						<input type="text" name="start_seconds" value="#v("start_seconds", "00")#" id="start_seconds" style="width:30px" />
					</div>
				</fieldset>
			</div>
		</div>
		<div class="row-fluid">
			<div class="span12">
				<div class="form-actions">
		            <button type="submit" class="btn btn-primary">Save Information</button>
		            <button class="btn" type="reset">Reset form</button>
	            </div>
			</div>
		</div>
	</form>
</cfoutput>
