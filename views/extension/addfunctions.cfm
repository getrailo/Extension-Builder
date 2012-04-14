<cfoutput><cfparam name="rc.functions" default="#[]#">
	<h1>Add Functions</h1>
	<p>You can add your own functions  that will then be treated like Built-in Functions in Railo Server.</p>
	<form action="#buildURL("extension.addfunction")#" class="well form-inline <!--- progressuploader --->" method="post" enctype="multipart/form-data">
	<label>Tag to upload</label>
	  <input type="hidden" name="name" value="#rc.name#">
	  <input type="file" class="span3 uploadfield" name="functionUpload" placeholder="Select a Function file">
	<input type="submit" class="btn" value="Add Function">
	</form>
		<div class="progress progress-striped active hide">
	  		<div class="bar" style="width: 0%;"></div>
	  	</div>
	  	
	  	<div class="alert alert-success hide" id="upload_success"></div>
	
		
	<cfif ArrayLen(rc.functions)>
	<h2>Currently added functions</h2>
		
	<table class="table table-bordered table-striped">
		<thead>
			<tr><th colspan="2">Function</th></tr>
		</thead>
		<tbody>
		<cfloop array="#rc.functions#" index="func">
			<tr>
				<td><a href="#buildURL("extension.editfunction?name=" & rc.name& "&function=" & func)#">#func#</a></td>
				<td width="20%"><a class="btn btn-danger" href="#buildURL("extension.removefunction?name=#rc.name#&function=#func#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
			</tr>
		</cfloop>
		</tbody>
	</table>	
	</cfif>
</cfoutput>