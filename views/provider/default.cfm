<cfoutput>
	<h1>Extension Provider</h1>
	<hr />
	<div class="row-fluid">
		<div class="span6">
			<h2>Install Provider into Railo Web/Server Admin</h2>
			<p>So that you can use your extensions, you should install the Builder provider as a provider in the Railo Administrator.</p>
			<form action="#buildURL("provider.install")#" method="post">
			
				<legend>Railo Administrator passwords:</legend>
				<div>
					<label for="server">Server Administrator Password</label>
					<input type="password" name="serverpass" value="" id="server" placeholder="******">
				</div>
				<div>
					<label for="web">Web Administrator Password:</label>
					<input type="password" name="webpass" value="" id="web" placeholder="******">
				</div>
			
				<div class="form-actions">
					<button type="submit" class="btn btn-primary">Install Provider</button>
					<button class="btn" type="reset">Reset form</button>
				 </div>
			</form>

			<h2>Railo Administrator</h2>
			<p>View the:
				<ul>
					<li><a href="#rc.baseurl#/railo-context/admin/server.cfm?action=extension.applications" target="_blank">Server Administrator Extensions</a></li>
					<li><a href="#rc.baseurl#/railo-context/admin/web.cfm?action=extension.applications" target="_blank">Web Administrator Extensions</a></li>
				</ul>
			</p>
			
		</div>
		<div class="span6">
			<h2>Provider URL</h2>
			<p>
				The provider url for the Builder is: <code>#rc.extproviderURL#</code>
			</p>
			<h2>Location of Extensions</h2>
			<p>
				The actual extensions are stored in: <code>#expandPath("/ext")#</code>
			</p>
			<h2>Edit the Extension Provider info</h2>
			<p>When you are viewing extension details or the Providers list in the Railo Administrator,
				you will see details about the Provider.
			</p>
			<p><em>You can use ##variables## in the fields underneath</em></p>
			<form action="#buildURL("provider.saveExtensionInfo")#" method="post">
				<fieldset>
					<legend>Extension Provider details:</legend>
					<div>
						<label for="mode">Mode</label>
						<select name="mode" id="mode">
							<option value="develop">Develop</option>
							<option value="production"<cfif rc.extInfo.mode neq "develop"> selected</cfif>>Production</option>
						</select>
						<i class="icon-question-sign" data-content="Determines if your Extension Provider will be visited only once per session in the Railo administrator, or on every request. Loading a Provider might take some time, so set it to Production once you are done developing!" data-original-title="Mode"></i>
					</div>
					<div>
						<label for="title">Title</label>
						<input type="text" name="title" value="#rc.extInfo.title#" id="title" class="span6" />
					</div>
					<div>
						<label for="description">Description</label>
						<input type="text" name="description" value="#rc.extInfo.description#" id="description" class="span6" />
					</div>
					<div>
						<label for="image">Image URL</label>
						<input type="text" name="image" value="#rc.extInfo.image#" id="image" class="span6" />
					</div>
					<div>
						<label for="url">URL to your website</label>
						<input type="text" name="url" value="#rc.extInfo.url#" id="url" class="span6" />
					</div>
					<div class="form-actions">
						<button type="submit" class="btn btn-primary">Update Extension Provider info</button>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
</cfoutput>