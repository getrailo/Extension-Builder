<cfparam name="rc.stepsinfo" default="#[]#">

<cfsavecontent variable='js'>
	<script type="text/javascript" charset="utf-8">
		$(function(){
			$("a.localedit").live("click", function(e){
				e.preventDefault();
				var h = $(this).attr("href");
				$("#step_target").load(h + (h.indexOf('?')>-1?'&':'?')+"ajax=1", function(){
					$("#step_target i[data-content]").each(function(){
						$(this).popover();
					});
				});
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
	<h1>Installation Steps</h1>
	<p>The installation steps defined here will be presented to the user as they install your extension.
		<br />With every step, you can add form fields.
		The values of these fields can be checked with a bit of custom CFML,
		which you must add to <a href="#buildURL('extension.installactions?name=#rc.name#')###validation">Installer Actions &gt; Validation</a>.
	</p>
	<div class="row">
		<div class="span4" style="overflow:scroll;">
			<div id="step_tree">
				<ol>
					<cfset stepcounter = 1>
					<cfloop array="#rc.stepsinfo#" index="step">
						<li class="step" id="step_#stepcounter#">
							<a class="localedit" href="#buildURL("extension.editstep?name=#rc.name#&step=#stepcounter#")#" title="edit step">#displayAttribute(step, "label", "Step #stepcounter#")#</a>
							<ul>
								<cfset groupcounter = 1>
								<cfif ArrayLen(step.XMLChildren)>
									<cfloop array="#step.XMLChildren#" index="s">
										<li class="group">
											<a class="localedit" href="#buildURL("extension.editgroup?name=#rc.name#&step=#stepcounter#&group=#groupcounter#")#">#displayAttribute(s, "label", "Group #groupcounter#")#</a>
											<ul>
												<cfset fieldCounter = 1>
												<cfif ArrayLen(s.XMLChildren)>
													<cfloop array="#s.XMLChildren#" index="i">
														<li class="item">
															<a class="localedit" href="#buildURL("extension.editfield?name=#rc.name#&step=#stepcounter#&group=#groupcounter#&field=#fieldCounter#")#">#displayAttribute(i, "name", "Field #fieldCounter#")# (#displayAttribute(i, "type")#)</a>
														</li>
														<cfset fieldCounter++>
													</cfloop>									
												</cfif>
												<li>
													<a href="#buildURL("extension.editfield?name=#rc.name#&step=#stepcounter#&group=#groupcounter#&field=#fieldCounter#")#" class="btn btn-mini localedit">Add Field</a>
												</li>
											</ul>
										</li>
										<cfset groupcounter++>
									</cfloop>
									<!--- Go through the groups --->
								</cfif>
								<li>
									<a class="localedit btn-mini btn" href="#buildURL("extension.editgroup?name=#rc.name#&step=#stepcounter#&group=#groupcounter#")#">Add field group</a>
								</li>
							</ul>
						</li>
						<cfset stepcounter++>
					</cfloop>
					<li>
						<a class="localedit btn btn-mini" href="#buildURL("extension.editstep?name=#rc.name#")#">Add Step</a>
					</li>
				</ol>
			</div>
		</div>
		<div class="span8" id="step_target"></div>
	</div>
</cfoutput>