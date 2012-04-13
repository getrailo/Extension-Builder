<cfparam name="rc.stepsinfo" default="#[]#">

<h1>Installation Steps</h1>
<p>The installation steps defined here will be presented to the user as they install your extension</p>
<cfsavecontent variable='js'>
	<script>
		$(function(){
			$('#step_tree').jstree({
				core : {
								
				}
				, plugins : [ "themes", "html_data"]
				
			});
				
		});
	
	</script>
</cfsavecontent>
<cfset ArrayAppend(rc.js, js)>

<cfscript>
	function displayAttribute(node, attr){
		var ret = "";
		if(!StructKeyExists(node.XMLAttributes, attr) OR !Len(node.XMLAttributes[attr])){
				return "Unnamed";
		}		
		
		return node.XMLAttributes[attr];
	}

</cfscript>

<cfoutput>
<div class="row">
	<div class="span4" style="overflow:scroll;">
		<button class="btn btn-mini btn-primary" data-toggle="modal" href="##addStep">Add Step</button>
		<div id="step_tree">
			<ul>
				<cfset stepcounter = 1>
				<cfloop array="#rc.stepsinfo#" index="step">
					<li id="step_#stepcounter#">#displayAttribute(step, "label")#
					<cfif ArrayLen(step.XMLChildren)>
						<ul>
							<!--- Go through the groups --->						
							
							
						</ul>
					</cfif>
					</li>
					<cfset stepcounter++>
				</cfloop>
			</ul>
		</div>
	</div>
	<div class="span8" id="step_target">
	<cfdump var="#rc.stepsinfo#">
	</div>
</div></cfoutput>

<!--- hidden modals --->

<cfoutput>
<div id="addStep" class="modal hide">
	<form action="#buildURL("extension.savestep")#" method="post">
	<div class="modal-header">
		<button class="close" data-dismiss="modal">x</button>
   		<h3>Add Step</h3>
	</div>
		<div class="modal-body">
			<input type="hidden" name="step" value="0">
			<input type="hidden" name="name" value="#rc.name#">
			<label>Label</label>
			<input type="text" name="label" value="" class="span2">
			<label>Description</label>
			<input type="text" name="description" value="" class="span3">
	  	</div>
	  <div class="modal-footer">
	    <a href="##" class="btn" data-dismiss="modal">Close</a>
	    <button class="btn btn-primary" type="submit" >Save</button>
	  </div>
	</div>
	</form>
</div>
</cfoutput>

