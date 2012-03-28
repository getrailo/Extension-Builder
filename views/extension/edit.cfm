<cfparam name="rc.info" default="#{}#">

<cfoutput>
	
<cffunction name="v" output="false">
	<cfargument name="f">
	<cfreturn StructKeyExists(rc.info, f) ? Trim(rc.info[f]) : "">
</cffunction>	
<div class="row-fluid">
	<div class="span2">
		
		<cfinclude template="localnav.cfm">

	</div>
	<div class="span10">
	<h1>Edit #v("label")#</h1>
	<form action="#buildURL("extension.saveinfo")#" method="post">
 <fieldset>
 	<legend>Extension Information</legend>
 	<div>
		<label for="label">Display Name</label>
		<input type="text" name="label" value="#v("label")#" id="label" placeholder="My Great Extension">
	</div>
	<div>
 		<label>Short Name:</label>
		#v("name")#
 		<input type="hidden" name="name" value="#v("name")#" id="Name" placeholder="MyExtension"/>	
 	</div>
	<div>
		<label for="author">Author</label>
		<input type="text" name="author" value="#v("author")#" id="author" placeholder="John Smith">
	</div>
	<div>
		<label for="version">Version</label>
		<input type="text" name="version" value="#v("version")#" id="version" placeholder="1.0.0">
	</div>
 	<div>
		<label for="type">Type</label>
		<select name="type" id="type">
			<option value="all">All</option>
			<option value="server">Server</option>
			<option value="web">Web</option>			
		</select>
		 <p class="help-block">If this extension should be availbel to the whole server, or a specific web context</p>
 	</div>

	<div>
		<label for="description">Description</label>
		<textarea name="description" rows="8" cols="40">#v("description")#</textarea>
	</div>
	
	<div>
		<label for="category">Category</label>
		<input type="text" name="category" value="#v("category")#" id="category" placeholder="Gateway">
	</div>

	<div>
		<label for="imgurl">Image URL</label>
		<input type="text" name="image" value="#v("image")#" id="image" placeholder="http://mydomain.com/image.png">
	</div>
 	<div>
		<label for="mailinglist">Mailing List</label>
		<input type="text" name="mailinglist" value="#v("mailinglist")#" id="mailinglist" placeholder="http://groups.google.com/group/railo-beta">
	</div>
	
	<div>
		<label for="supportURL">Support URL</label>
		<input type="text" name="support" value="#v("support")#" id="supportURL" placeholder="http://groups.google.com/group/railo-beta">
	</div>
	
	<div>
		<label for="documentationURL">Documentation URL</label>
		<input type="text" name="documentation"value="#v("documentation")#"id="documentationURL" placeholder="http://groups.google.com/group/railo-beta">
	</div>
	<div class="form-actions">
            <button type="submit" class="btn btn-primary">Create Extension</button>
            <button class="btn" type="reset">Cancel</button>
          </div>
 </fieldset>
</form>	

	</div>
</div>	
<hr>
<section>
	<h1>Add Tags</h1>
	<p>You can add custom tags that will be part of the core Railo Server. These custom tags will be called as <code>&lt;cfcustomtag&gt;</code> rather than <code>&lt;f_customtag&gt;</code> </p>
	<form action="#buildURL("extension.addtag")#" class="well" id="form_upload_tag" method="post" enctype="multipart/form-data">
	<label>Tag to upload</label>
	  <input type="hidden" name="name" value="#v("name")#">
	<input type="submit" class="btn" value="Add Tag">
	  <input type="file" class="span3" name="tagUpload" placeholder="Select a custom tag">
	  <div class="progress progress-striped active hide" id="upload_tag_progress">
	  	<div class="bar" style="width: 0%;"></div>
	  </div>
	</form>

</section>

</cfoutput>