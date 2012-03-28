<h1>Provider</h1>

<h2>Install Provider into Railo Web/Server Admin</h2>
<p>So that you can use your extensions, you should install this SDK provider as a provider in the Railo Administrator.</p>
<cfoutput>
<form action="#buildURL("extensions.installprovider")#" method="post">

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

<h2>Provider URL</h2>

The provider url for this SDK is: <code>#rc.extproviderURL#</code>
</cfoutput>