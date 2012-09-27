<cfparam name="rc.plugins" default="#[]#">
<cfoutput>
<h1>Add Plugins</h1>
    <p>Plugins extend the functionality of the Railo Server/Web Administrators by adding extra screens and panels. You can read about creating here:
    <a href="https://github.com/getrailo/railo/wiki/Contributing%3AAdminPlugins">Building Administrator Plugins</a>
    </p>
    <p>In this section you can add your own Administrator plugins, by uploading them, they will be automatically installed (and uninstalled)</p>


    <form action="#buildURL("plugins.add")#" class="well form-inline <!--- progressuploader --->" method="post" enctype="multipart/form-data">
        <label>Plugin to upload</label>
            <input type="hidden" name="name" value="#rc.name#">
        <input type="file" class="span4 uploadfield" name="functionUpload" placeholder="Select a plugin zip file">
        <input type="submit" class="btn" value="Add Plugin">
    </form>
    <div class="progress progress-striped active hide">
        <div class="bar" style="width: 0%;"></div>
    </div>

    <div class="alert alert-success hide" id="upload_success"></div>
        <cfif ArrayLen(rc.plugins)>
            <h2>Currently added Admin Plugins</h2>

            <table class="table table-bordered table-striped">
                <thead>
                <tr><th colspan="2">Function</th></tr>
                </thead>
            <tbody>
            <cfloop array="#rc.plugins#" index="plugin">
                <tr>
                <td><a href="#buildURL("plugins.edit?name=" & rc.name& "&plugin=" & plugin)#">#plugin#</a></td>
            <td width="20%"><a class="btn btn-danger" href="#buildURL("plugins.remove?name=#rc.name#&plugin=#func#")#"><i class="icon-remove-sign icon-white"></i> Remove</a></td>
            </tr>
            </cfloop>
            </tbody>
            </table>
        </cfif>

</cfoutput>