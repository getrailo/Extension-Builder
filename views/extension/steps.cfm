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


<div id="step_tree"></div>