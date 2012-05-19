<cfparam name="rc.functioncontent" default="">
<cfoutput>
	<h1>Edit Function</h1>
	<p></p>
	<form action="#buildURL("extension.savefunction")#" class="<!--- progressuploader --->" method="post">
	  <input type="hidden" name="name" value="#rc.name#">
  	  <input type="hidden" name="function" value="#rc.function#">
	  <label>New File Name</label>
  	  <input type="text" name="newname" value="#rc.function#" />
	  <label>Content</label>
	  <textarea class="span10" rows="20" name="content">#HTMLeditformat(rc.functioncontent)#</textarea>
	  <div class="form-actions">
      	<button type="submit" class="btn btn-primary">Save</button>
	  </div>
	</form>
</cfoutput>