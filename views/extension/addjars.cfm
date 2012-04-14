<cfparam name="rc.jars" default="#[]#">
<cfoutput>
	<h1>Add Jars</h1>
	<p>If your application, tags or functions need specific Java libraries, you can add them here. You can even create your own extension such as an Event Gateway or specific driver
		and compile it into a Jar and add it to your extension here.
	</p>
	<form action="#buildURL("extension.addjar")#" class="well form-inline <!---progressuploader--->" method="post" enctype="multipart/form-data">
		<input type="hidden" name="name" value="#rc.name#">
		<label>Jar file to upload</label>
		<input type="file" class="span3 uploadfield" name="jarupload" placeholder="Select a JAR file">
		<input type="submit" class="btn" value="Add JAR">
	</form>
	<div class="progress progress-striped active hide">
		<div class="bar" style="width: 0%;"></div>
	</div>
	  	
	<div class="alert alert-success hide" id="upload_success"></div>
	
	<cfif ArrayLen(rc.jars)>
		<h2>Currently added JAR Files</h2>
			
		<table class="table table-bordered table-striped">
			<thead>
				<tr><th colspan="2">JAR</th></tr>
			</thead>
			<tbody>
			<cfloop array="#rc.jars#" index="tag">
				<tr>
					<td>#tag#</td>
					<td width="20%"><a class="btn btn-danger" href="#buildURL("extension.removejar?name=#rc.name#&tag=#tag#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
				</tr>
			</cfloop>
			</tbody>
		</table>	
	</cfif>
</cfoutput>