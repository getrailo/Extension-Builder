<cfparam name="rc.plugins" default="#[]#">
<cfoutput>
<h1>Add Plugins</h1>
    <p>Plugins extend the functionality of the Railo Server/Web Administrators by adding extra screens and panels. You can read about creating here:
    <a href="https://github.com/getrailo/railo/wiki/Contributing%3AAdminPlugins">Building Administrator Plugins</a>
    </p>
    <p>In this section you can add your own Administrator plugins, by uploading them, they will be automatically installed (and uninstalled)</p>

    <cfif !ArrayLen(rc.plugins)>
        <cfinclude template="_addplugin.cfm">
        <cfelse>
        <cfinclude template="_pluginsettings.cfm">
    </cfif>
</cfoutput>