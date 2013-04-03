<cfoutput>
	<cfsavecontent variable="js">
		<script type="text/javascript">
			var oldlicenseText = null;
			$(function(){
				$('##licenseTemplate').change(function(){
					if (oldlicenseText==null)
					{
						oldlicenseText = $('##license').val();
					}
					$('##license').val('\n\n\n          Loading...').css('opacity', .3);
					if ($(this).val()=='')
					{
						$('##license').val(oldlicenseText).animate({opacity:1}, 1000);
					} else
					{
						$.ajax({
							type:"GET"
							, url: "#request.webRootPath#licenses/" + $(this).val()
							, dataType:"text"
							, complete: function(data) {
								$('##license').val(data.responseText).animate({opacity:1}, 1000)
							}
						});
					}
				});
			});
		</script>
	</cfsavecontent>
	<cfparam name="rc.js" default="#[]#">
	<cfset arrayAppend(rc.js, js) />
	

			<h1>License</h1>
			<p>Here you can add your own license to your extension, and select a template from some common licenses.
				<br />The license templates were copied from <a href="http://www.opensource.org">opensource.org</a>
			</p>
			<form action="#buildurl('extension.saveLicense')#" method="post">
				<input type="hidden" name="name" value="#rc.info.name#" id="Name" />	
				<fieldset>
					<legend>License Text for your extension</legend>
					<div class="control-group">
						<label class="control-label" for="licenseTemplate">Choose a template</label>
						<div class="controls">
							<select name="licenseTemplate" id="licenseTemplate" class="span10">
								<option value="">Your own text (fill in underneath)</option>
								<cfset currLicenseTemplate = structKeyExists(rc.info, "licenseTemplate") ? rc.info.licenseTemplate & ".txt" : "" />
								<cfdirectory action="list" directory="../../licenses" filter="*.txt" name="qLicenses" sort="name" />
								<cfloop query="qLicenses">
									<option value="#qLicenses.name#"<cfif qLicenses.name eq currLicenseTemplate> selected</cfif>>#replace(qLicenses.name, ".txt", "")#</option>
								</cfloop>
							</select>
						</div>
					</div>
					<div class="control-group">
						<label class="control-label" for="license">Edit your license</label>
						<div class="controls">
							<textarea name="license" id="license"  class="span10" rows="20">#rc.info.licenseText#</textarea>
						</div>
					</div>
				</fieldset>
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">Save License text</button>
				</div>
			</form>
</cfoutput>