<div class="row-fluid">
	<div class="span2">
		<cfinclude template="localnav.cfm">
	</div>
	<div class="span10">
		<h1>License</h1>
		<p>Here you can add your own license to your extension, or select from some common licenses</p>
		<form action="#buildurl("extension.addlicense")#">
		<fieldset>
		    <legend>License Text</legend>
		    <div class="control-group">
				<label class="control-label" for="license">License</label>
				<div class="controls">
		        <textarea name="license" id="license"  class="span10" rows="20"></textarea>
				</div>
			</div>
		</fieldset>
		<div class="form-actions">
            	<button type="submit" class="btn btn-primary">Save License</button>
			</div>
		</form>
	</div>
</div>