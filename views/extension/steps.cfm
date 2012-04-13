<cfparam name="rc.stepsinfo" default="#[]#">

<h1>Installation Steps</h1>
<p>The installation steps defined here will be presented to the user as they install your extension</p>
<cfsavecontent variable='js'>
	<!---
	<script>
		$(function(){
			$('#step_tree').jstree({
				 types : {
					"step" :  { icon : { image : "/img/application.png" } }, 
					"group" : { icon : { image : "/img/application_form.png"} },
					"item" :  { icon : { image : "/img/textfield.png" } }
				  }
				, plugins : [ "themes", "html_data", "ui", "types", "contextmenu"]
				
			});
				
		});
	
	</script>
	--->
	<script type="text/javascript" charset="utf-8">
		$(function(){
			$("a.localedit").click(function(e){
				e.preventDefault();
				$("#step_target").load($(this).attr("href"));
			});
		});
		
	</script>
		
</cfsavecontent>


<cfset ArrayAppend(rc.js, js)>

<cfscript>
	function displayAttribute(node, attr, defaultName = "Unnamed"){
		var ret = "";
		if(!StructKeyExists(node.XMLAttributes, attr) OR !Len(node.XMLAttributes[attr])){
				return defaultName;
		}		
		
		return node.XMLAttributes[attr];
	}

</cfscript>

<cfoutput>
<div class="row">
	<div class="span4" style="overflow:scroll;">
		<a class="btn btn-mini btn-primary" href="#buildURL("extension.editgroup?name=#rc.name#&step=0")#">Add Step</a>
		<div id="step_tree">
			<ul>
				<cfset stepcounter = 1>
				<cfloop array="#rc.stepsinfo#" index="step">
					<li class="step" id="step_#stepcounter#" title="#displayAttribute(step, "description", "")#">
						<a class="localedit btn-mini btn" href="#buildURL("extension.editgroup?name=#rc.name#&step=1&group=0")#" class="btn btn-mini">+</a>
						<a class="localedit" href="#buildURL("extension.editstep?name=#rc.name#&step=#stepcounter#")#">#displayAttribute(step, "label", "Step #stepcounter#")#</a>
					<cfif ArrayLen(step.XMLChildren)>
						<ul>
								
							<cfset groupcounter = 1>
							<cfloop array="#step.XMLChildren#" index="s">
								<li class="group"> 
								<a class="localedit" href="#buildURL("extension.editgroup?name=#rc.name#&step=#stepcounter#&group=#groupcounter#")#">#displayAttribute(s, "label", "Group #groupcounter#")#</a>
								<cfif ArrayLen(s.XMLChildren)>
									<ul>
									<cfset fieldCounter = 1>
									<cfloop array="#s.XMLChildren#" index="i">
										<li class="item">#displayAttribute(i, "name", "Field #fieldCounter#")# (#displayAttribute(i, "type")#)</li>
										<cfset fieldCounter++>
									</cfloop>									
									</ul>
								</cfif>
								</li>
								<cfset groupcounter++>
							</cfloop>
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

