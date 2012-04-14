<h1>Installer Actions</h1>
<p>The included installer.cfc should take care of most of the steps related to instaling an application.
	If you need to add separate actions you can do this here
</p>


<cfparam name="rc.availableActions" default="#[]#">

<cfoutput><form action="#buildURL("extension.saveactions")#" method="post">

	<input type='hidden' name="name" value='#rc.name#'>
<div class="tabbable tabs-left">

  <ul class="nav nav-tabs">
	<cfset counter = 0>
	<cfloop array="#rc.availableActions#" index="act">
		<cfset class = counter EQ 0 ? "active" : "">
		<li class="#class#" style="text-transform:capitalize;"><a href="###act#" data-toggle="tab">#Replace(act, "_", " ", "all")#</a></li>
		<cfset counter++>
	</cfloop>
  </ul>

	<div class="tab-content">
	<cfset counter = 0>
	<cfloop array="#rc.availableActions#" index="act">
		<cfset class = counter EQ 0 ? "active" : "">
		<div class="tab-pane #class#" id="#act#"><textarea class="span10" rows="20" name="#act#">#HTMLeditformat(rc[act])#</textarea></div>
		<cfset counter++>
	</cfloop>
	</div>
</div>

<div class="form-actions">
	<button class="btn btn-primary">Save Actions</button>
</div>
</form>
</cfoutput>
