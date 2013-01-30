<cfparam name="rc.info" default="#{}#">
<cfparam name="rc.message" default="">
<cffunction name="v" output="false">
	<cfargument name="f">
	<cfreturn structKeyExists(rc.storeInfo, f) ? trim(rc.storeInfo[f]) : StructKeyExists(rc.info, f) ? Trim(rc.info[f]) : "" />
</cffunction>

<cfoutput>
	<h1>Publish your extension in the Railo Extension Store</h1>
	<p>
		The <a href="http://www.getrailo.org/index.cfm/extensions" target="_blank" title="Link opens new window">Railo Extension Store</a> is a great way to share your extension.
		These extensions are visible in all Railo Administrators around the world.
		<br />All you need to do, is signup, and then start publishing!
	</p>
	<hr />
	<div class="row-fluid">
		<div class="span6">
			<form action="#buildURL("extension.publishnow?name=#rc.name#")#" method="post">
				<fieldset>
					<cfif v('storeID') neq "">
						<legend>Update your extension <em>#rc.info.label#</em></legend>
						<p>This extension is already published in the Extension Store.
							<br />
							<a href="http://www.getrailo.org/index.cfm/extensions/for-developers/?gfa=editGadget&gadgetID=#v('storeID')#">Edit the Store details</a>
						</p>
					<cfelse>
						<legend>Publish your extension <em>#rc.info.label#</em></legend>
						<p>The Builder will upload your extension directly to the store.</p>
					</cfif>
					<cfif v("getrailo_user") eq "">
						<p class="error"><strong>You have not yet saved your getrailo.org login details.</strong></p>
						<ol>
							<li><a href="http://www.getrailo.org/index.cfm/extensions/for-developers/your-profile?display=login" target="_blank" title="Link opens new window">Register for a getrailo.org account</a></li>
							<li>Then save your login details in the form on the right</li>
						</ol>
					<cfelse>
						<div class="form-actions">
							<button type="submit" class="btn btn-primary" onclick="$(this).text('Please keep waiting ...').prop('disabled', true);$('body').css('opacity', .4).bind('mousedown dblclick', function(e){ e.preventDefault(); e.stopPropagation(); return false;})"><cfif v('storeID') neq "">Update<cfelse>Publish</cfif> now!</button>
						</div>
					</cfif>
				</fieldset>
			</form>
		</div>
		<div class="span6">
			<form action="#buildURL("extension.savestorelogin?name=#rc.name#")#" method="post">
				<fieldset>
					<legend>Your Getrailo.org login details</legend>
					<p>By saving your login here, you will be able to directly upload your extension to the Extension Store.
					</p>
					<div>
						<label for="getrailo_user">User name</label>
						<input type="text" name="getrailo_user" value="#v("getrailo_user")#" class="span4" id="getrailo_user" placeholder="Enter username">
					</div>
					<div>
						<label for="getrailo_pass">Password</label>
						<input type="password" name="getrailo_pass" value="#v("getrailo_pass")#" class="span4" id="getrailo_pass" />
					</div>
					<div class="form-actions">
						<button type="submit" class="btn btn-primary">Save Information</button>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
	<hr />
	<h3>Publish manually</h3>
	<p>If you prefer to add your extension to the store manually, then just <a href="http://www.getrailo.org/index.cfm/extensions" target="_blank" title="Link opens new window">go to the Store</a>, and use this zip file:
		<br /><a href="#request.webRootPath#ext/#rc.name#.zip"><em>#request.absRootPath#ext/#rc.name#.zip</em></a>
	</p>
</cfoutput>