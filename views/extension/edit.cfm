<cfparam name="rc.info" default="#{}#">
<h1>Edit Extension</h1>
<cfoutput>
	
<cffunction name="v" output="false">
	<cfargument name="f">
	<cfreturn StructKeyExists(rc.info, f) ? Trim(rc.info[f]) : "">
</cffunction>	
	
	
<form action="#buildURL("builder.step1")#" method="post">
 <fieldset>
 	<legend>Extension Information</legend>
 	<div>
		<label for="label">Display Name</label>
		<input type="text" name="label" value="#v("label")#" id="label" placeholder="My Great Extension">
	</div>
	<div>
 		<label>Short Name:</label>
 		<input type="text" name="name" value="#v("name")#" id="Name" placeholder="MyExtension"/>	
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

</cfoutput>