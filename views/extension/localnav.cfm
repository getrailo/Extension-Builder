<cfsavecontent variable="nav">
	<cfoutput>
		<div class="well sidebar-nav">
			<ul class="nav nav-list">
				<li class="nav-header nowrap">Extension</li>
				<li class="nowrap"><a href="#buildURL("extension.edit?name=#rc.name#")#">Main Info <i class="icon-question-sign" data-content="Allows you to edit the main information about this extension" title="Information"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.license?name=#rc.name#")#">License <i class="icon-question-sign" data-content="Allows you to set what kind of license this extension should be released under" title="License"></i></a></li>

				<li class="nav-header nowrap">Add Items</li>
				<li class="nowrap"><a href="#buildURL("extension.addApplications?name=#rc.name#")#">Applications <i class="icon-question-sign" data-content="Allows you to deploy a whole application to a web context" title="Applications"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.addTags?name=#rc.name#")#">Custom Tags <i class="icon-question-sign" data-content="Allows you to add custom tags and use them as you would use built in tags" title="Custom Tags"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.addFunctions?name=#rc.name#")#">Functions <i class="icon-question-sign" data-content="Allows you to add functions and use them as you would use built in functions" title="Functions"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.addJars?name=#rc.name#")#">Java Libraries <i class="icon-question-sign" data-content="Allows you to add any Java libraries you want to deploy with your extension" title="Java Libraries"></i></a></li>
            <li class="nowrap"><a href="#buildURL("plugins.default?name=#rc.name#")#">Plugins <i class="icon-question-sign" title="Administrator Plugins" data-content="Allows you to add any Railo Web and Server Administrator plugins with your extension"></i></a></li>


				<li class="nav-header nowrap">Install Settings</li>
				<li class="nowrap"><a href="#buildURL("extension.steps?name=#rc.name#")#">Step Screens <i class="icon-question-sign" data-content="Step screens allow you to gather install information before Railo actually installs your extension. You can then use this information to modify the install steps" title="Steps"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.installactions?name=#rc.name#")#">Installer Actions <i class="icon-question-sign" data-content="Allows you to add additional code that should be run by the installer" title="Install Actions"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.editconfig?name=#rc.name#")#">Edit Config.xml <i class="icon-question-sign" data-content="Manually edit the Config.xml that describes this plugin" title="Config.xml"></i></a></li>
				<li class="nowrap"><a href="#buildURL("extension.editinstall?name=#rc.name#")#">View Install.cfc <i class="icon-question-sign" title="Install.cfc" data-content="View the contents of the deployed Install.cfc file. This file is run by Railo Server to install your application" ></i></a></li>

				<cfif isDefined("variables.rc.info.author") and variables.rc.info.author neq "">
					<li class="nav-header nowrap">Publish</li>
					<li class="nowrap"><a href="#buildURL("extension.publish?name=#rc.name#")#">Extension Store <i class="icon-question-sign" data-content="Publish your extension in the Railo Extension Store, to make it available for all Railo Administrators around the world" title="Extension Store"></i></a></li>
					<cfif rc.hasLinkFiles>
						<li class="nowrap"><a href="#buildURL("extension.autoupdatecheck?name=#rc.name#")#">Auto-update
							<i class="icon-question-sign" data-content="Since you added one or more URLs in your application, you can create an auto-update script for it" title="Auto-update check"></i></a></li>
					</cfif>
				</cfif>

			</ul>
		</div>
	</cfoutput>
</cfsavecontent>

<cfif structKeyExists(rc, "action") and rc.action neq "">
	<cfoutput>#rereplaceNoCase(variables.nav, "(<li class="")([^\r\n]+action=#replace(rc.action, '.', '\.')#&)", "\1active \2")#</cfoutput>
<cfelse>
	<cfoutput>#variables.nav#</cfoutput>
</cfif>