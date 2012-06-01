<cfoutput>


<cfparam name="rc.tags" default="#[]#">
	<h1>Add Tags</h1>
	<p>You can add custom tags that will be part of the core Railo Server. These custom tags will be called as <code>&lt;cfcustomtag&gt;</code> rather than <code>&lt;f_customtag&gt;</code> </p>
	<form action="#buildURL("extension.addtag")#" class="well form-inline <!--- progressuploader --->" method="post" enctype="multipart/form-data">
	<label>Tag to upload</label>
	  <input type="hidden" name="name" value="#rc.name#">
	  <input type="file" class="span4 uploadfield" name="tagUpload" placeholder="Select a custom tag">
	<input type="submit" class="btn" value="Add Tag">
	</form>
		<div class="progress progress-striped active hide">
	  		<div class="bar" style="width: 0%;"></div>
	  	</div>
	  	<div class="alert alert-success hide" id="upload_success"></div>
	<cfif ArrayLen(rc.tags)>
		<h2>Currently added tags</h2>
		<table class="table table-bordered table-striped">
			<thead>
				<tr><th colspan="2">Tag</th></tr>
			</thead>
			<tbody>
			<cfloop array="#rc.tags#" index="tag">
				<tr>
					<td><a href="#buildURL("extension.edittag?name=" & rc.name& "&tag=" & tag)#">#tag#</a></td>
					<td width="20%"><a class="btn btn-danger" href="#buildURL("extension.removetag?name=#rc.name#&tag=#tag#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
				</tr>
			</cfloop>
			</tbody>
		</table>	
	</cfif>
	

</cfoutput>