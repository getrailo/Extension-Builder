<cffunction name="v" output="no">
	<cfreturn structKeyExists(rc.item, arguments[1]) ? rc.item[arguments[1]] : "" />
</cffunction>

<script type="text/javascript">
	$(function(){
		$('#type').change(function(){
			console.log($(this).val().match(/(text|password)/i));
			if ($(this).val().match(/(text|password)/i))
			{
				$('#field_options').hide();
				$('#field_value').show();
			} else
			{
				$('#field_options').show();
				$('#field_value').hide();
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
					<cfloop list="text,select,radio,checkbox,password" index="type">
						<option value="#type#"<cfif v('type') eq variables.type> selected</cfif>>#type#</option>
					</cfloop>
				</select>
			</div>
			<div>
				<label>Field name</label>
				<input type="text" name="field_name" value="#v('name')#">
			</div>
			<div id="field_value">
				<label>Default value</label>
				<input type="text" name="field_value" value="#v('defaultvalue')#">
			</div>
			<div id="field_options">
				<label style="display:inline">List of option values</label>
				<i class="icon-question-sign" data-content="One item per line. Start with the value, then '|', and then the displayed label:<br /><i>1|First place<br />*2|Second place</i><br />Start the line with an * to make it the default value." title="Information"></i>
				<br />
				<textarea name="options" rows="6" cols="100" class="span4">#v('options')#</textarea>
			</div>
			<div class="form-actions">
				<button class="btn btn-primary" type="submit">Save</button>
			</div>
		</fieldset>
	</form>
</cfoutput>