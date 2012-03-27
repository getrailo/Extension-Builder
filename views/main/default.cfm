<cfoutput>
	<h1>Extension  Builder</h1>
<form action="#buildURL("builder.step1")#" method="post">
 <fieldset>
 	<legend>Extension Information</legend>
 	<div>
		<label for="label">Display Name</label>
		<input type="text" name="label" value="" id="label" placeholder="My Great Extension">
	</div>
	<div>
 		<label>Short Name:</label>
 		<input type="text" name="name" id="Name" placeholder="MyExtension"/>	
 	</div>
	<div>
		<label for="author">Author</label>
		<input type="text" name="author" value="" id="author" placeholder="John Smith">
	</div>
	<div>
		<label for="version">Version</label>
		<input type="text" name="version" value="" id="version" placeholder="1.0.0">
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
		<textarea name="description" rows="8" cols="40"></textarea>
	</div>
	
	<div>
		<label for="category">Category</label>
		<input type="text" name="category" value="" id="category" placeholder="Gateway">
	</div>

	<div>
		<label for="imgurl">Image URL</label>
		<input type="text" name="image" value="" id="image" placeholder="http://mydomain.com/image.png">
	</div>
 	<div>
		<label for="mailinglist">Mailing List</label>
		<input type="text" name="mailinglist" value="" id="mailinglist" placeholder="http://groups.google.com/group/railo-beta">
	</div>
	
	<div>
		<label for="supportURL">Support URL</label>
		<input type="text" name="supportURL" value="" id="supportURL" placeholder="http://groups.google.com/group/railo-beta">
	</div>
	
	<div>
		<label for="documentationURL">Documentation URL</label>
		<input type="text" name="documentationURL" value="" id="documentationURL" placeholder="http://groups.google.com/group/railo-beta">
	</div>
	<div class="form-actions">
            <button type="submit" class="btn btn-primary">Create Extension</button>
            <button class="btn" type="reset">Cancel</button>
          </div>
 </fieldset>

</form>	

</cfoutput>