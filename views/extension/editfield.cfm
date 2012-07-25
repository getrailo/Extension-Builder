<cffunction name="v" output="no">
	<cfreturn structKeyExists(rc.item, arguments[1]) ? rc.item[arguments[1]] : "" />
</cffunction>

<script type="text/javascript">
	$(function(){
		$('#type').change(function(){
			if ($(this).val().match(/(text|password)/i))
			{
				$('#field_options').hide();
				$('#field_value').show();
			} else if ($(this).val() == 'datasource selection')
			{
				$('#field_options').hide();
				$('#field_value').hide();
			} else
			{
				$('#field_options').show();
				$('#field_value').hide();
			}
		}).triggerHandler('change');
		
		$('#fieldusage input:radio').bind('click change', function(){
			$('#fieldusage_replace_div').css('display', ($('#fieldusage_replace')[0].checked ? 'block':'none'));
			if ($('#fieldusage_apppath')[0].checked)
			{
				var fld = $('#field_value_fld');
				if (String(fld.val()).indexOf('{') == -1)
				{
					fld.val('{web-root-directory}' + fld.val()).css({opacity:.1}).animate({opacity:1}, 1000);
				}
			}
		}).triggerHandler('change');
	});
</script>
<cfoutput>
	<cfif structIsEmpty(rc.item)>
		<h1>Add a new field</h1>
	<cfelse>
		<h1>Edit Field</h1>
	</cfif>
	<form method="post" class="well" action="#buildurl('extension.savefield')#">
		<fieldset>
			<input type="hidden" name="name" value="#rc.name#">
			<input type="hidden" name="step" value="#rc.step#">
			<input type="hidden" name="group" value="#rc.group#">
			<input type="hidden" name="field" value="#rc.field#">
<!---			<item type="radio" name="webservertype" description="Select this option if you are using IIS7 (Internet Information Services) as your main webserver">
				<option value="IIS7" description="">IIS7</option>
			</item>
			<item type="text" name="windowsroot" label="Path to the Windows installation directory (i.e. C:\Windows\)"></item>
--->
			<div>
				<label>Label</label>
				<input type="text" name="label" value="#v('label')##v('description')#">
			</div>
			<div>
				<label>Field type</label>
				<select name="type" id="type">
					<cfloop list="text,select,radio,checkbox,password,datasource selection" index="type">
						<option value="#type#"<cfif v('type') eq variables.type> selected</cfif>>#type#</option>
					</cfloop>
				</select>
			</div>
			<div>
				<label>Field name</label>
				<input type="text" name="field_name" value="#v('name')#">
			</div>
			<div id="field_value">
				<label for="field_value">Default value</label>
				<input type="text" name="field_value" id="field_value_fld" value="#v('defaultvalue')#">
			</div>
			<div id="field_options">
				<label style="display:inline">List of option values</label>
				<i class="icon-question-sign" data-content="One item per line. Start with the value, then '|', and then the displayed label:<br /><i>1|First place<br />*2|Second place</i><br />Start the line with an * to make it the default value." title="Information"></i>
				<br />
				<textarea name="options" rows="6" cols="100" class="span4">#v('options')#</textarea>
			</div>
		</fieldset>
		<fieldset>
			<h3>Field usage</h3>
			<ul id="fieldusage">
				<li>
					<input type="radio" name="fieldusage" value="custom"<cfif v('fieldusage') eq 'custom' or v('fieldusage') eq ''> checked</cfif> /> Custom usage (see the section Installer Actions)
				</li>
				<li>
					<input type="radio" name="fieldusage" id="fieldusage_apppath" value="appinstallpath"<cfif v('fieldusage') eq 'appinstallpath'> checked</cfif> /> Use as the application install path
					<i class="icon-question-sign" data-content="This must be a full path. Optionally use <b>{web-root-directory}</b> as the default value (will be converted when installing)" title="Webroot placeholder"></i>
				</li>
				<li>
					<input type="radio" name="fieldusage" id="fieldusage_replace" value="replace"<cfif v('fieldusage') eq 'replace'> checked</cfif> /> Replace values in the installed application:
					<div id="fieldusage_replace_div">
						<p>The value of this field will be used to alter the installed code (tags, functions, and applications)</p>
						<div>
							<label>String to replace</label>
							<input type="text" name="replacestring" value="#v('replacestring')#" placeholder="$_replace_$" />
						</div>
						<div>
							<label style="display:inline;">File names to check for replacements</label>
							<i class="icon-question-sign" data-content="One file name per line. Do not include a file path! Examples:<br /><em>Application.cfc</em><br /><em>config.xml</em><br /><em>*.cfm</em>" title="Information"></i>
							<br />
							<textarea name="replacefilenames" placeholder="config.xml">#replace(v('replacefilenames'), ',', chr(10), 'all')#</textarea>
						</div>
					</div>
					
				</li>
			</ul>

		</fieldset>
		<div class="form-actions">
			<button class="btn btn-primary" type="submit">Save</button>
		</div>
	</form>
</cfoutput>