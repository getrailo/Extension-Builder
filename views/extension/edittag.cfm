<cfparam name="rc.tags" default="#[]#">
<cfoutput>
	<h1>Edit Tag</h1>
	<p></p>
	<form action="#buildURL("extension.savetag")#" class="<!--- progressuploader --->" method="post">
	  <input type="hidden" name="name" value="#rc.name#">
	  <label>New File Name</label>
  	  <input type="text" name="newname" value="#rc.tag#" />
  	  <input type="hidden" name="tag" value="#rc.tag#">
	
	  <label>Content</label>
	  <textarea class="span10" rows="20" name="content">#HTMLeditformat(rc.tagcontent)#</textarea>
	  <div class="form-actions">
            	<button type="submit" class="btn btn-primary">Save</button>
	  </div>
	</form>
</cfoutput>