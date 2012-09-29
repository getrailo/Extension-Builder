<h1>Installer Actions</h1>
<p>The included installer.cfc should take care of most of the steps related to instaling an application.
	If you need to add separate actions you can do this here
</p>


<cfparam name="rc.availableActions" default="#[]#">

<cfoutput><form action="#buildURL("extension.saveactions")#" method="post">

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
		<div class="tab-pane #class#" id="#act#"><textarea class="span10" rows="20" name="#act#">#HTMLeditformat(rc[act])#</textarea></div>
	</cfloop>
	</div>
</div>

<div class="form-actions">
	<button class="btn btn-primary">Save Actions</button>
</div>
</form>
</cfoutput>
