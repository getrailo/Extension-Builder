<h1>Installer Actions</h1>
<p>The included installer.cfc should take care of most of the steps related to installing an application.
	If you need to add extra actions you can do this here.
</p>
<p>
	The code you enter here, will be <i>cfincluded</i> in the appropriate sections of Install.cfc.
	For more insight in the installation process, see
	<a href="https://github.com/getrailo/Railo-Extension-Builder-SDK/blob/master/services/templates/Install.cfc" target="_blank" title="Opens in new tab/window">Install.cfc</a>.
</p>
<hr />
<cfset rc.actionDescriptions = {} />
<cfsavecontent variable="rc.actionDescriptions.before_install">
	Before_install is used inside function <i>install</i>, before anything has actually been installed.<br />
	<b>Extra available variables:</b>
	<ul>
		<li>arguments.error.common <i>(empty string; insert exception message here if you want to go to the previous step)</i></li>
		<li>arguments.path <i>(path to the extension zip file)</i></li>
		<li>arguments.config.mixed <i>(contains all values entered in the installation steps)</i></li>
	</ul>
	<b>Example: return an error</b>
	<pre>&lt;cfif year(now()) neq 2012>
	&lt;cfset arguments.error.common = "Sorry, this software has expired" />
	&lt;cfreturn arguments.error.common />
&lt;/cfif></pre>
</cfsavecontent>

<cfsavecontent variable="rc.actionDescriptions.after_install">
	After_install is used inside function <i>install</i>, after all files have been copied, and actions have completed.<br />
	<b>Extra available variables:</b>
	<ul>
		<li>arguments.error.common <i>(empty string; insert exception message here if you want to go to the previous step)</i></li>
		<li>arguments.path <i>(path to the extension zip file)</i></li>
		<li>arguments.config.mixed <i>(contains all values entered in the installation steps)</i></li>
		<li>local.installpath <i>(path to the application install dir; only when an application was installed)</i></li>
		<li>local.message <i>(contains the html success message which will be displayed on-screen)</i></li>
	</ul>

	<b>Example: add extra success message</b>
	<pre>&lt;cfset local.message &= "&lt;br />&lt;br />Thanks for installing my app!" /></pre>

	<b>Example: custom success message</b>
	<pre>&lt;cfset local.message = "The &lt;cfsomething&gt; tag has been successfully installed.&lt;br />&lt;br />
	Please &lt;a href='server.cfm?action=services.restart'>restart Railo&lt;/a> so you can start using the tag." /></pre>

	<b>Example: go to the installed application</b>
	<pre>&lt;!--- find the relative path from webroot to install directory --->
&lt;cfset local.subdir = replaceNoCase(local.installpath, expandPath("/"), "") />
&lt;cfif local.subdir eq local.installpath>
    &lt;cfset local.subdir = "" />
&lt;/cfif>
&lt;cfset local.subdir = replace(local.subdir, "\", "/", "all") />
&lt;cfif local.subdir neq "" and right(local.subdir, 1) neq "/">
    &lt;cfset local.subdir &= "/" />
&lt;/cfif>
&lt;cfsavecontent variable="local.message">&lt;cfoutput>
    #local.message#
    &lt;br />You can now &lt;a href="http://#cgi.http_host#/#local.subdir#setup.cfm">go to the setup page&lt;/a> to add all required settings.
&lt;/cfoutput>&lt;/cfsavecontent></pre>
</cfsavecontent>

<cfsavecontent variable="rc.actionDescriptions.additional_functions">
	This section allows you to include extra cffunctions in Install.cfc.<br />
	These functions will be available for all other installer actions on this page.
	<br />Be carefull not to overwrite any of the functions "install", "validate", "uninstall", "update", "getContextPath", "listDatasources",
	or any other function name in <a href="https://github.com/getrailo/Railo-Extension-Builder-SDK/blob/master/services/templates/Install.cfc" target="_blank" title="Opens in new tab/window">Install.cfc</a>!
</cfsavecontent>

<cfsavecontent variable="rc.actionDescriptions.update">
	Updating an application consist of two steps: <i>uninstall</i> and <i>install</i>.
	This section is included after the uninstall, and before the install.<br />

	<b>Extra available variables:</b>
	<ul>
		<li>arguments.error.common <i>(empty string; insert exception message and do a cfreturn if you want to abort the update)</i></li>
		<li>arguments.path <i>(path to the extension zip file)</i></li>
		<li>arguments.config.mixed <i>(contains all values entered in the installation steps)</i></li>
		<li>arguments.config.mixed.applicationInstallPath <i>(full path to application install dir; only when an application was installed)</i></li>
		<li>local.uninstallMessage <i>(the message returned from the uninstall action)</i></li>
	</ul>

	<b>Example: remove installation directory before installing again</b>
	<pre>&lt;cfdirectory action="delete" directory="#arguments.config.mixed.applicationInstallPath#" recurse="true" /></pre>

	<b>Example: abort update if old jar file was not removed</b>
	<br /><i>The uninstall action returned a(n error) message with the jar name in it)</i>
	<pre>&lt;cfif findNoCase(variables.jars, uninstallMessage)>
	&lt;cfset arguments.error.common = "Update failed. The following error was reported:&lt;br />#uninstallMessage#" />
&lt;/cfif></pre>
</cfsavecontent>

<cfsavecontent variable="rc.actionDescriptions.validation">
	In this section you can check the values entered in the installation steps.<br />
	<b>Extra available variables:</b>
	<ul>
		<li>arguments.error.fields <i>(empty struct; can be used to add a specific error for a field)</i></li>
		<li>arguments.error.common <i>(empty string; can be used to add a generic error message)</i></li>
		<li>arguments.path <i>(path to the extension zip file)</i></li>
		<li>arguments.config.mixed <i>(contains all values entered in the installation steps)</i></li>
		<li>arguments.config.step <i>(array containing structs with the values entered in each installation step)</i></li>
		<li>arguments.step <i>(number indicating at which install step the user now is)</i></li>
	</ul>

	<b>Example: 2 installation steps</b>
	<pre>&lt;cfif arguments.step eq 1>
	&lt;cfif not isNumeric(arguments.config.mixed.age)>
		&lt;cfset arguments.error.fields.age = "Please provide your age (must be a number)" />
	&lt;cfelseif arguments.config.mixed.age lt 18>
		&lt;cfset arguments.error.common = "You must be 18 years or over to install this application." />
	&lt;/cfif>
&lt;cfelseif arguments.step eq 2>
	&lt;cfif arguments.config.mixed.myInstallPath eq "">
		&lt;cfset arguments.error.fields.myInstallPath = "Please provide an installation path" />
	&lt;!--- check if directory is empty --->
	&lt;cfelseif directoryExists(arguments.config.mixed.myInstallPath)>
		&lt;cfdirectory action="list" directory="#arguments.config.mixed.myInstallPath#" name="local.dirlist" />
		&lt;cfif local.dirlist.recordcount>
			&lt;cfset arguments.error.fields.myInstallPath = "The installation path must be an empty directory." />
		&lt;/cfif>
	&lt;/cfif>
&lt;/cfif></pre>
</cfsavecontent>



<cfparam name="rc.availableActions" default="#[]#">

<cfoutput>
	<form action="#buildURL("extension.saveactions")#" method="post">
		<input type='hidden' name="name" value='#rc.name#'>
		<div class="tabbable tabs-left">
			<ul class="nav nav-tabs">
				<!--- find the first tab with content, if any --->
				<cfset activeTab = rc.availableActions[1] />
				<cfloop array="#rc.availableActions#" index="act">
					<cfif rc[act] neq "">
						<cfset activeTab = act />
						<cfbreak />
					</cfif>
				</cfloop>
				<cfloop array="#rc.availableActions#" index="act">
					<cfset hasContent = rc[act] neq "" />
					<cfset class = activeTab eq act ? "active" : "">
					<li class="#class#" style="text-transform:capitalize;<cfif hasContent>font-weight: bold;</cfif>"><a href="###act#" data-toggle="tab">#Replace(act, "_", " ", "all")#</a></li>
				</cfloop>
			</ul>

			<div class="tab-content">
				<cfloop array="#rc.availableActions#" index="act">
					<cfset class = activeTab eq act ? "active" : "">
					<div class="tab-pane #class#" id="#act#">
						<textarea class="span10" rows="10" name="#act#">#HTMLeditformat(rc[act])#</textarea>
						<cfif structKeyExists(rc.actionDescriptions, act)>
							<br />#replace(rc.actionDescriptions[act], '	', '    ', 'all')#
						</cfif>
					</div>
				</cfloop>
			</div>
		</div>

		<div class="form-actions">
			<button class="btn btn-primary">Save Actions</button>
		</div>
	</form>
</cfoutput>
