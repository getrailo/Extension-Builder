<cfparam name="rc.info" default="#{}#">
<cfparam name="rc.message" default="">
<cfoutput>
	
<cffunction name="v" output="false">
	<cfargument name="f">
	<cfreturn StructKeyExists(rc.info, f) ? Trim(rc.info[f]) : "">
</cffunction>	

<cfsavecontent variable="js">
	<script>
		var categories ="Framework,CMS,Core,Gateway,Database,Forum,E-Commerce,Demo".split(",");
		
		$('.typeahead').typeahead({
				source:categories
		});
	</script>
</cfsavecontent>

<cfset arrayAppend(rc.js, js)>





<div class="row-fluid">
	<div class="span2">
		<cfinclude template="localnav.cfm">
	</div>
	<div class="span10">
	<h1>Edit #v("label")#</h1>
	
	<cfif Len(rc.message)>
		<div class="alert alert-success">
		<a class="close" data-dismiss="alert">x</a>
		#rc.message#</div>
	</cfif>
	
	<form action="#buildURL("extension.saveinfo")#" method="post" enctype="multipart/form-data">
		
	<div class="row">
		<div class="span6">
			<fieldset>
			 	<legend>Extension Information</legend>
			 	<div>
					<label for="label">Display Name</label>
					<input type="text" name="label" value="#v("label")#" class="span4" id="label" placeholder="My Great Extension">
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
					<label for="email">Email</label>
					<input type="text" name="email" value="#v("email")#" id="email" placeholder="John.Smith@getrailo.org">
				</div>
				<div>
					<label for="version">Version</label>
					<input type="text" name="version" value="#v("version")#" class="span1" id="version" placeholder="1.0.0">
				</div>
			 	<div>
					<label for="type">Admin type (was #v("type")#)</label>
					<select name="type" id="type">
						<cfset type= v("type")>
						<option value="server" <cfif type EQ "server">selected</cfif>>Server</option>
						<option value="web" <cfif type EQ "web">selected</cfif>>Web</option>			
						<option value="all" <cfif type EQ "all">selected</cfif>>Both Web and Server</option>			
					</select>
					 <p class="help-block">If this extension will be available for the Server and/or Web Administrator</p>
			 	</div>
			
				<div>
					<label for="description">Description</label>
					<textarea name="description" rows="8" class="span5">#v("description")#</textarea>
				</div>
				
				<div>
					<label for="category">Category</label>
					<input type="text" name="category" class="typeahead" value="#v("category")#" id="category" placeholder="Gateway">
					<i class="icon-question-sign" data-content="You can define the category that your extension belongs to" title="Category"></i>
				</div>
				</fieldset>
		</div>
		<div class="span6">
			<fieldset>
				<legend>Resources</legend>
				<div>
					<cfset imgtype = isvalid('url', v("image")) ? 'url':'file' />
					<label for="imgurl">Image</label>
					<cfif imgtype eq 'file' and v('image') neq "">
						<input type="hidden" name="oldimage" value="#v('image')#" />
						Current uploaded file: <a href="/ext#v('image')#" title="Click to view full size"><img src="/ext#v('image')#" alt="Logo file" height="30" /></a>
						<br />
					</cfif>
					<div>
						<label style="float:left;">
							<input type="radio" name="imgtype" style="display:inline;" id="imgtypeurl" value="url"<cfif imgtype eq 'url'> checked</cfif> />
							URL &nbsp; &nbsp;
						</label>
						<label style="float:left;">
							or &nbsp; <input type="radio" name="imgtype" style="display:inline;" id="imgtypefile" value="file"<cfif imgtype eq 'file'> checked</cfif> />
							<cfif v("image") neq "" and imgtype eq "file">New file<cfelse>File</cfif>
						</label>
<cfsavecontent variable="js">
	<script type="text/javascript">
		$(function(){
			$('##imgtypeurl,##imgtypefile').click(function(){
				var imgfield = $('##image');
				var isfile = $('##imgtypefile:checked').length;
				imgfield.prop('placeholder', isfile ? '':'http://mydomain.com/image.png')
					.prop('type', isfile ? 'file':'text');
			}).filter(':first').triggerHandler('click');
		});
	</script>
</cfsavecontent>
<cfparam name="rc.js" default="#[]#">
<cfset arrayAppend(rc.js, js) />
						<br clear="all" />
					</div>
					<input type="text" name="image" value="#v("image")#" id="image" class="span4" placeholder="http://mydomain.com/image.png">
					<i class="icon-question-sign" data-content="Upload an image, or provide an absolute URL to the image that is the logo for your Extension" title="ImageURL"></i>
				</div>
			 	<div>
					<label for="mailinglist">Mailing List</label>
					<input type="text" name="mailinglist" value="#v("mailinglist")#" class="span4" id="mailinglist" placeholder="http://groups.google.com/group/railo-beta">
				</div>
				
				<div>
					<label for="supportURL">Support URL</label>
					<input type="text" name="support" value="#v("support")#" id="supportURL" class="span4" placeholder="http://groups.google.com/group/railo-beta">
				</div>
				
				<div>
					<label for="documentationURL">Documentation URL</label>
					<input type="text" name="documentation" value="#v("documentation")#" class="span4" id="documentationURL" placeholder="http://groups.google.com/group/railo-beta">
				</div>
			</fieldset>
			
			<fieldset>
				<legend>Payment / donation Information</legend>
				<div>
					<label for="paypal">Paypal Address</label>
					<input type="text" name="paypal" value="#v("paypal")#" id="paypal" placeholder="joe.user@mydomain.com">

				</div>			
			</fieldset>
		</div>
	
	</div>
		<div class="form-actions">
            <button type="submit" class="btn btn-primary">Save Information</button>
            <button class="btn" type="reset">Cancel</button>
          </div>
</form>	

	</div>
</div>	


</cfoutput>