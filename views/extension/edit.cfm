<cfparam name="rc.info" default="#{}#">
<cfparam name="rc.message" default="">
<cfoutput>
	
<!--- JavaScript --->
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

<cfsavecontent variable="js">
	<script type="text/javascript">
		$(function(){
			$('##imgtypeurl,##imgtypefile').click(function(){
				var imgfieldurl = $('##imageurl');
				var imgfieldfile = $('##imagefile');
				if ($('##imgtypefile:checked').length)
				{
					imgfieldfile.show().prop('disabled', null);
					imgfieldurl.hide().prop('disabled', 'disabled');
				} else
				{
					imgfieldurl.show().prop('disabled', null);
					imgfieldfile.hide().prop('disabled', 'disabled');
				};
			}).filter(':first').triggerHandler('click');
		});

		$(function(){
			$('##editform').submit(function(e){
				var rv = $('##railo_version').val();
				if (rv != '' && !rv.match(/^([0-9]+\.){3}[0-9]+$/))
				{
					alert('The required Railo version number must be in the format \'4.0.0.0\'.');
					e.preventDefault();
					return false;
				}
			})
		})
	</script>
</cfsavecontent>
<cfset arrayAppend(rc.js, js) />

<form action="#buildURL("extension.saveinfo")#" method="post" enctype="multipart/form-data" id="editform">
	<h1>Edit #v("label")#</h1>
	<hr/>
	<div class="row-fluid">
		<div class="span6">
			<!--- pre-fill form option, if data is not yet entered --->
			<cfif arrayLen(rc.extensions) gt 1 and (v('author') eq "" or structKeyExists(rc, "prefillfrom"))>
				<cfsavecontent variable="js">
					<script>
						$('##prefillfrom').change(function(){
							self.location.href = '#buildURL("extension.edit?name=#rc.name#&prefillfrom=")#'+$(this).val();
						});

						/* If we just overrode data, highlight those fields */
						<cfif structKeyExists(rc, "overrideData")>
							<cfloop collection="#rc.overrideData#" item="key">
								<cfif rc.overrideData[key] neq "" and rc.overrideData[key] eq rc.info[key]>
									$('###lCase(key)#').parents('div.control-group:first').addClass('warning');
								</cfif>
							</cfloop>
						</cfif>
					</script>
				</cfsavecontent>
				<cfset arrayAppend(rc.js, js)>

				<cfparam name="rc.prefillfrom" default="" />
				<fieldset>
					<legend>Use data from existing extension:</legend>
					<div>
						<select name="prefillfrom" id="prefillfrom" class="span4">
							<option value=""> - none</option>
							<cfloop array="#rc.extensions#" index="ext">
								<cfif ext.info.name neq rc.name>
									<option value="#ext.info.name#"<cfif ext.info.name eq rc.prefillfrom> selected</cfif>>#ext.info.label#</option>
								</cfif>
							</cfloop>
						</select>
					</div>
				</fieldset>
			</cfif>

			<fieldset>
			 	<legend>Extension Information</legend>
			 	<div class="control-group">
					<label for="label">Display Name</label>
					<input type="text" name="label" value="#v("label")#" class="span4" id="label" placeholder="My Great Extension">
				</div>
				<div class="control-group">
			 		<label>Short Name:</label>
					#v("name")#
			 		<input type="hidden" name="name" value="#v("name")#" id="Name" placeholder="MyExtension"/>	
			 	</div>
				<div class="control-group">
					<label for="author">Author</label>
					<input type="text" name="author" value="#v("author")#" id="author" placeholder="John Smith">
				</div>
				<div class="control-group">
					<label for="email">Email</label>
					<input type="text" name="email" value="#v("email")#" id="email" placeholder="John.Smith@getrailo.org">
				</div>
				<div class="control-group">
					<label for="packaged-by">Packaged By</label>
					<input type="text" name="packaged-by" value="#v("packaged-by")#" id="packaged-by" placeholder="John.Smith@getrailo.org">
				</div>
                <div class="control-group">
                    <label for="packaged-by">Mininum Railo Version</label>
                    <input type="text" name="railo_version" value="#v("railo_version")#" id="railo_version" placeholder="4.0.0.0">
                    <i class="icon-question-sign" data-content="You can define which is the minimum version of Railo you can support with your extension. Leave it blank to skip version checking" title="Minimum Railo Version"></i>
                </div>
				<div class="control-group">
					<label for="version" class="control-label">Version</label>
					<div class="row">
						<div class="span2">
							<input type="text" name="version" value="#v("version")#" class="span2" id="version" placeholder="1.0.0">
						</div>
						<label for="auto_version_update" class="span3 checkbox">
							<input type="checkbox" name="auto_version_update" value="true" id="auto_version_update" <cfif v('auto_version_update') eq true> checked</cfif>>
							Auto update version
							<i class="icon-question-sign" data-content="When checked, the version number will be increased on every update of the extension (adding items, editing details, etc.)<br />The current date-time will be used for incrementing: 1.2.0 will become 1.2.<i>#dateformat(now(), 'yyyymmdd')##timeformat(now(), 'HHmmss')#</i>" title="Auto-update version"></i>
						</label>
					</div>
				</div>
			 	<div class="control-group">
					<cfif rc.info.hasApplication>
						<label for="type">Admin type</label>
						<select name="type" id="type">
							<option value="web">Web</option>			
						</select>
						<i class="icon-question-sign" data-content="This extension installs an application, so it can only be available for the Web Administrator" title="Admin type"></i>
					<cfelse>
						<label for="type">Admin type (was #v("type")#)</label>
						<select name="type" id="type">
							<cfset type= v("type")>
							<option value="server" <cfif type EQ "server">selected</cfif>>Server</option>
							<option value="web" <cfif type EQ "web">selected</cfif>>Web</option>			
							<option value="all" <cfif type EQ "all">selected</cfif>>Both Web and Server</option>			
						</select>
						<i class="icon-question-sign" data-content="If this extension will be available for the Server and/or Web Administrator" title="Admin type"></i>
					</cfif>
			 	</div>
			
				<div class="control-group">
					<label for="description">Description</label>
					<textarea name="description" rows="8" class="span5" id="description">#v("description")#</textarea>
				</div>
				
				<div class="control-group">
					<label for="category">Category</label>
					<input type="text" name="category" class="typeahead" value="#v("category")#" id="category" placeholder="Gateway">
					<i class="icon-question-sign" data-content="You can define the category that your extension belongs to" title="Category"></i>
				</div>
			</fieldset>
		</div>
		<div class="span6">
			<fieldset>
				<legend>Resources</legend>
				<div class="control-group">
					<cfset imgtype = isvalid('url', v("image")) ? 'url':'file' />
					<label>Image</label>
					<cfif imgtype eq 'file' and v('image') neq "">
						<input type="hidden" name="oldimage" value="#v('image')#" />
						Current uploaded file: <a href="/ext#v('image')#" title="Click to view full size"><img src="/ext#v('image')#" alt="Logo file" style="height:30px;" /></a>
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
						<br clear="all" />
					</div>
					<input type="text" name="image" value="<cfif imgtype eq 'url'>#v("image")#</cfif>" id="imageurl" class="span4" placeholder="http://mydomain.com/image.png">
					<input type="file" name="image" id="imagefile" class="span4" />
					<i class="icon-question-sign" data-content="Upload an image, or provide an absolute URL to the image that is the logo for your Extension" title="ImageURL"></i>
				</div>
			 	<div class="control-group">
					<label for="mailinglist">Mailing List</label>
					<input type="text" name="mailinglist" value="#v("mailinglist")#" class="span4" id="mailinglist" placeholder="http://groups.google.com/group/railo-beta">
				</div>
				
				<div class="control-group">
					<label for="support">Support URL</label>
					<input type="text" name="support" value="#v("support")#" id="support" class="span4" placeholder="http://groups.google.com/group/railo-beta">
				</div>
				
				<div class="control-group">
					<label for="documentation">Documentation URL</label>
					<input type="text" name="documentation" value="#v("documentation")#" class="span4" id="documentation" placeholder="http://groups.google.com/group/railo-beta">
				</div>
			</fieldset>
			
			<fieldset>
				<legend>Payment / donation Information</legend>
				<div class="control-group">
					<label for="paypal">Paypal Address</label>
					<input type="text" name="paypal" value="#v("paypal")#" id="paypal" placeholder="joe.user@mydomain.com">

				</div>			
			</fieldset>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span12">
			<div class="form-actions">
            <button type="submit" class="btn btn-primary">Save Information</button>
            <button class="btn" type="reset">Cancel</button>
 	        </div>
		</div>
	</div>
</form>	


</cfoutput>