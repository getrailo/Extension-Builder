
<div class="row-fluid">
	<div class="span6">
		<h1>Provider</h1>
		<h2>Install Provider into Railo Web/Server Admin</h2>
		<p>So that you can use your extensions, you should install this SDK provider as a provider in the Railo Administrator.</p>
		<cfoutput>
		<form action="#buildURL("provider.install")#" method="post">
		
			<legend>Railo Administrator passwords:</legend>
			<div>
				<label for="label">Server Administrator Password</label>
				<input type="password" name="serverpass" value="" id="server" placeholder="******">
			</div>
			<div>
		 		<label>Web Administrator Password:</label>
				<input type="password" name="webpass" value="" id="web" placeholder="******">
		 	</div>
		
			<div class="form-actions">
		            <button type="submit" class="btn btn-primary">Install Provider</button>
		            <button class="btn" type="reset">Cancel</button>
		     </div>
		
		</form>
	</div>
	<div class="span6">
		<h2>Provider URL</h2>
		The provider url for this SDK is: <code>#rc.extproviderURL#</code>
	
		<h2>Railo Administrator</h2>
		<p>View the:
			<ul>
				<li><a href="#rc.baseurl#/railo-context/admin/server.cfm?action=extension.applications" target="_blank">Server Administrator Extensions</a></li>
				<li><a href="#rc.baseurl#/railo-context/admin/web.cfm?action=extension.applications" target="_blank">Web Administrator Extensions</a></li>
			</ul>
		
		</p> 
		
	</div>

</div>




</cfoutput>