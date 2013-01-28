<cfparam name="rc.info" default="#{}#">
<cfparam name="rc.message" default="">
<cfset showPrefill = arrayLen(rc.extensions) gt 1 and (v('author') eq "" or structKeyExists(rc, "prefillfrom")) />
<cfparam name="rc.prefillfrom" default="" />

<cffunction name="v" output="false">
	<cfargument name="f">
	<cfreturn StructKeyExists(rc.info, f) ? Trim(rc.info[f]) : "">
</cffunction>

<cfset variables.storeCats = "Admin plugin,Application,Built-in function,Built-in tag,CMS,Database & Cache,Forum,Framework,Railo Core" />

<cfoutput>
<!--- JavaScript --->
<cfsavecontent variable="js">
	<script type="text/javascript">
		var categories ="#variables.storeCats#".split(",");
		
		$('##category').typeahead({
			source:categories
		}).blur(function(){
			if ($(this).val() == '')
			{
				return;
			}
			var isStoreCat = $.inArray($(this).val(), categories) > -1;
			if (!isStoreCat)
			{
				$('##nostorecat').show('slow');
			} else
			{
				$('##nostorecat').hide();
			}
		}).trigger('blur');


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

		$('##editform').submit(function(e){
			var rv = $('##railo_version').val();
			if (rv != '' && !rv.match(/^([0-9]+\.){3}[0-9]+$/))
			{
				alert('The required Railo version number must be in the format \'4.0.0.0\'.');
				e.preventDefault();
				return false;
			}
		})

		<cfif showPrefill>
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
		</cfif>
	</script>
</cfsavecontent>
<cfset arrayAppend(rc.js, js) />


<form action="#buildURL("extension.saveinfo")#" method="post" enctype="multipart/form-data" id="editform">
	<h1>Edit #v("label")#</h1>
	<hr/>

	<div class="tabbable tabs-top">
		<ul class="nav nav-tabs">
			<cfif showPrefill>
				<li<cfif rc.prefillfrom eq ""> class="active"</cfif>><a href="##tab-prefill" data-toggle="tab">Prefill this form</a></li>
			</cfif>
			<li<cfif not showPrefill or rc.prefillfrom neq ""> class="active"</cfif>><a href="##tab-main" data-toggle="tab">Main info</a></li>
			<li><a href="##tab-extra" data-toggle="tab">Extra info</a></li>
		</ul>

		<div class="tab-content">
			<!--- pre-fill form option, if data is not yet entered --->
			<cfif showPrefill>
				<div class="tab-pane<cfif rc.prefillfrom eq ""> active</cfif>" id="tab-prefill">
					<div class="row-fluid">
						<div class="span12">
							<fieldset>
								<legend>Use existing information from another extension to prefill this form</legend>
								<div>
									<label for="prefillfrom">Choose an extension</label>
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
						</div>
					</div>
				</div>
			</cfif>

			<!--- main info tab --->
			<div class="tab-pane<cfif not showPrefill or rc.prefillfrom neq ""> active</cfif>" id="tab-main">
				<div class="row-fluid">
					<div class="span6">
						<fieldset>
							<!--- <legend>Main Information</legend> --->
							<div class="control-group">
								<label for="label">Display Name</label>
								<input type="text" name="label" value="#v("label")#" class="span5" id="label" placeholder="My Great Extension">
							</div>


							<!--- No added value, and form is too long already
							<div class="control-group">
						        <label>Short Name:</label>
								#v("name")#
						        <input type="hidden" name="name" value="#v("name")#" id="Name" placeholder="MyExtension"/>
						    </div>--->
							<input type="hidden" name="name" value="#v("name")#" id="Name"/>


							<div class="control-group">
								<label for="author">Author</label>
								<input type="text" name="author" value="#v("author")#" id="author" class="span5" placeholder="Your name" />
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
								<label for="description">Description</label>
								<textarea name="description" rows="5" class="span5" id="description">#v("description")#</textarea>
							</div>
						</fieldset>
					</div>
					<div class="span6">
						<fieldset>
							<!---<legend>Extension details</legend>--->
							<div class="control-group">
								<label for="category">Category
									<i class="icon-question-sign" data-content="You can define the category that your extension belongs to.<br>The following are used in the Railo Extension Store: <i>#replace(replace(variables.storeCats, ' ', '&nbsp;', 'all'), ',', ', ', 'all')#</i>" title="Category"></i>
								</label>
								<input type="text" name="category" class="typeahead span4" value="#v("category")#" id="category" placeholder="Application" autocomplete="off" />
								<div id="nostorecat" class="comment" style="display: none"><i>This category does not exist in the Extension Store</i></div>
							</div>
						<!---</fieldset>


						<fieldset>
							<legend>Technical information</legend>--->
			                <div class="control-group">
								<cfif rc.info.hasApplication>
									<label for="type">Admin type
										<i class="icon-question-sign" data-content="This extension installs an application, so it can only be available for the Web Administrator" title="Admin type"></i>
									</label>
									<select name="type" id="type">
										<option value="web">Web</option>
									</select>
								<cfelse>
									<label for="type">Admin type (was #v("type")#)
										<i class="icon-question-sign" data-content="If this extension will be installable from the Railo Server and/or Web Administrator" title="Admin type"></i>
									</label>
									<select name="type" id="type" class="span4">
										<cfset type= v("type")>
										<option value="server" <cfif type EQ "server">selected</cfif>>Server</option>
										<option value="web" <cfif type EQ "web">selected</cfif>>Web</option>
										<option value="all" <cfif type EQ "all">selected</cfif>>Both Web and Server</option>
									</select>
								</cfif>
						    </div>

			               <div class="control-group">
			                    <label for="packaged-by">Mininum Railo Version
				                    <i class="icon-question-sign" data-content="You can define which is the minimum version of Railo you can support with your extension. Leave it blank to skip version checking" title="Minimum Railo Version"></i>
			                    </label>
			                    <input type="text" name="railo_version" value="#v("railo_version")#" id="railo_version" placeholder="4.0.0.0" class="span4" />
			                </div>

							<div class="control-group">
								<cfset imgtype = isvalid('url', v("image")) ? 'url':'file' />
								<div class="row">
									<cfif imgtype eq 'file' and v('image') neq "">
										<input type="hidden" name="oldimage" value="#v('image')#" />
									</cfif>
									<div class="span4">
										<label id="image">Image
											<i class="icon-question-sign" data-content="Upload an image, or provide an absolute URL to the image that is the logo for your Extension. Square images preferably" title="Image"></i>
										</label>
										<label style="float:left;">
											<input type="radio" name="imgtype" style="display:inline;" id="imgtypeurl" value="url"<cfif imgtype eq 'url'> checked</cfif> />
											URL &nbsp; &nbsp;
										</label>
										<label style="float:left;">
											or &nbsp; <input type="radio" name="imgtype" style="display:inline;" id="imgtypefile" value="file"<cfif imgtype eq 'file'> checked</cfif> />
											<cfif v("image") neq "" and imgtype eq "file">New file<cfelse>File</cfif>
										</label>
										<input type="text" name="image" value="<cfif imgtype eq 'url'>#v("image")#</cfif>" id="imageurl" class="span4" placeholder="http://mydomain.com/image.png">
										<input type="file" name="image" id="imagefile" class="span4" />
									</div>
									<div class="span2">
										<label>Current image</label>
										<div class="well">
											<cfif isValid('url', v('image'))>
												<img src="#v('image')#" alt="Logo file" />
											<cfelseif v('image') neq "">
												<img src="ext#v('image')#" alt="Logo file" />
											<cfelse>
												<img src="img/icon-gadget.png" alt="default image" />
											</cfif>
										</div>
									</div>
								</div>
							</div>
						</fieldset>

					</div>
				</div>
			</div>

			<!--- extra info --->
			<div class="tab-pane" id="tab-extra">
				<div class="row-fluid">
					<div class="span6">
						<fieldset>
							<legend>Resource links</legend>
						    <div class="control-group">
								<label for="mailinglist">Mailing List</label>
								<input type="text" name="mailinglist" value="#v("mailinglist")#" class="span5" id="mailinglist" placeholder="http://groups.google.com/group/railo-beta">
							</div>

							<div class="control-group">
								<label for="support">Support URL</label>
								<input type="text" name="support" value="#v("support")#" id="support" class="span5" placeholder="http://groups.google.com/group/railo-beta">
							</div>

							<div class="control-group">
								<label for="documentation">Documentation URL</label>
								<input type="text" name="documentation" value="#v("documentation")#" class="span5" id="documentation" placeholder="http://groups.google.com/group/railo-beta">
							</div>
						</fieldset>
					</div>
					<div class="span6">
						<fieldset>
							<legend>Payment / donation information</legend>
							<div class="control-group">
								<label for="paypal">Paypal address</label>
								<input type="text" name="paypal" value="#v("paypal")#" id="paypal" placeholder="your email address" />
							</div>
						</fieldset>

						<fieldset>
							<legend>Additional information</legend>
							<div class="control-group">
								<label for="email">Your email address</label>
								<input type="text" name="email" value="#v("email")#" id="email" placeholder="Your email address" />
							</div>
							<div class="control-group">
								<label for="packaged-by">Packaged By</label>
								<input type="text" name="packaged-by" value="#v("packaged-by")#" id="packaged-by" placeholder="Email or name">
							</div>
						</fieldset>
					</div>
				</div>
			</div>
		</div>
	</div>


	<div class="row-fluid">
		<div class="span12">
			<div class="form-actions">
            <button type="submit" class="btn btn-primary">Save Information</button>
            <button class="btn" type="reset">Reset form</button>
 	        </div>
		</div>
	</div>
</form>	


</cfoutput>