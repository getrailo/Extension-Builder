<cfparam name="rc.field_name" default="">
<cfparam name="rc.field_name" default="">
<cfoutput>
<h1>Edit Field</h1>

<form method="post">
	
	<input type="text" name="name" value="#rc.name#">
	<input type="text" name="step" value="#rc.step#">
	<input type="text" name="group" value="#rc.group#">
type="text" name="db_username" label="Username" description="U
	<label>Name</label>
	<input type="text" name="field_name" value="#rc.field_name#">
	
	<label>Type</label>
	<select name="field_type">
		<option>text</option>
		<option></option>
	</select>
	<input type="text" name="field_name" value="#rc.field_name#">
	
<cfdump var="#rc#">



</form>


</cfoutput>