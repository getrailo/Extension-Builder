<cfoutput>	<div class="well sidebar-nav">
		<ul class="nav nav-list">
			<li class="nav-header nowrap">Extension</li>
			<li class="nowrap"><a href="#buildURL("extension.edit?name=#rc.name#")#">Main Info <i class="icon-question-sign" data-content="Allows you to edit the main information about this extension" title="Information"></i></a></li>
			<li class="nowrap"><a href="#buildURL("extension.license?name=#rc.name#")#">License <i class="icon-question-sign" data-content="Allows you to set what kind of license this extension should be released under" title="License"></i></a></li>

			<li class="nav-header nowrap">Add Items</li>
			<li class="nowrap"><a href="#buildURL("extension.addApplications?name=#rc.name#")#">Applications <i class="icon-question-sign" data-content="Allows you to deploy a whole application to a web context" title="Applications"></i></a></li>
			<li class="nowrap"><a href="#buildURL("extension.addTags?name=#rc.name#")#">Custom Tags <i class="icon-question-sign" data-content="Allows you to add custom tags and use them as you would the built in tags" title="Custom Tags"></i></a></li>
			<li class="nowrap"><a href="#buildURL("extension.addFunctions?name=#rc.name#")#">Functions <i class="icon-question-sign" data-content="Allows you to add functions and use them as you would the built in functions" title="Functions"></i></a></li>
			<li class="nowrap"><a href="#buildURL("extension.addJars?name=#rc.name#")#">Java Libraries <i class="icon-question-sign" data-content="Allows you to add any Java libraries you want to deploy with your extension" title="Java Libraries"></i></a></li>	
			<li class="nowrap"><a href="#buildURL("plugins?name=#rc.name#")#">Admin Plugins <i class="icon-question-sign" data-content="Allows you to add plugins to the Web or Server Administrator that can be used to control your extension (if it requires a UI)" title="Administrator Plugins"></i></a></li>	
			<li class="nav-header nowrap">Install Settings</li>	
			<li class="nowrap"><a href="#buildURL("extension.steps?name=#rc.name#")#">Step Screens <i class="icon-question-sign" data-content="Step screens allow you to gather install information before Railo actually installs your extension. You can then use this information to modify the install steps" title="Steps"></i></a></li>
			<li class="nowrap"><a href="#buildURL("extension.installactions?name=#rc.name#")#">Installer Actions <i class="icon-question-sign" data-content="Allows you to add additional code that should be run by the installer" title="Install Actions"></i></a></li>
			<li class="nowrap"><a href="#buildURL("extension.editconfig?name=#rc.name#")#">Edit Config.xml <i class="icon-question-sign" data-content="Manually edit the Config.xml that describes this plugin" title="Config.xml"></i></a></li>
		</ul>
	</div>
</cfoutput>