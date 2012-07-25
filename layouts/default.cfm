<cfif structKeyExists(url, "ajax")>
	<cfoutput>#body#</cfoutput>
	<cfexit method="exittemplate" />
</cfif>
<!DOCTYPE HTML>
<html>
<head>
	<title>Extension Builder SDK</title>
	<link rel="stylesheet" href="/css/bootstrap.css">
	<link rel="stylesheet" href="/css/styles.css">
	<cfparam name="rc.js" default="#[]#">
	<style>
		BODY {
			padding-top:60px;
		}
	</style>
</head>
<body>
<cfoutput>
	<div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container-fluid">
          <a class="brand" href="#buildURL("main.default")#">Extension Builder SDK</a>
          <div class="nav-collapse">
            <ul class="nav">
             <li class="">
                <a href="#buildURL("extension")#">My Extensions</a>
              </li>
             <li class="<!--- active --->">
                <a href="#buildURL("provider")#">Extension Provider</a>
              </li>
			  <li><a href="https://github.com/getrailo/Railo-Extension-Builder-SDK/wiki">Documentation</a></li>
<!--- 			  <li><a href="#buildURL("resources")#">Resources</a></li> --->
            </ul>
          </div>
        </div>
      </div>
    </div>
	</cfoutput>
	
	<div class="container-fluid">
		<cfif structKeyExists(rc, "message") and Len(rc.message)>
			<div class="alert alert-success">
				<a class="close" data-dismiss="alert">x</a>
				<cfoutput>#rc.message#</cfoutput>
			</div>
		</cfif>
		<cfif structKeyExists(rc, "error") and Len(rc.error)>
			<div class="alert alert-error">
				<a class="close" data-dismiss="alert">x</a>
				<cfoutput>#rc.error#</cfoutput>
			</div>
		</cfif>
		<cfoutput>#body#</cfoutput>	
		
	 <hr>
	 <footer class="footer">
        <p class="pull-right"><a href="#">Back to top</a></p>
        <p>Designed and built by <a href="http://www.getrailo.org" target="_blank">Railo Technologies GMBH</a></p>
     </footer>
		
	</div>
	
	
	  <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
<!---     <script type="text/javascript" src="http://platform.twitter.com/widgets.js"></script> --->
    <script src="/js/jquery.js"></script>
    <script src="/js/google-code-prettify/prettify.js"></script>
    <script src="/js/bootstrap-transition.js"></script>
    <script src="/js/bootstrap-alert.js"></script>
    <script src="/js/bootstrap-modal.js"></script>
    <script src="/js/bootstrap-dropdown.js"></script>
    <script src="/js/bootstrap-scrollspy.js"></script>
    <script src="/js/bootstrap-tab.js"></script>
    <script src="/js/bootstrap-tooltip.js"></script>
    <script src="/js/bootstrap-popover.js"></script>
    <script src="/js/bootstrap-button.js"></script>
    <script src="/js/bootstrap-collapse.js"></script>
    <script src="/js/bootstrap-carousel.js"></script>
    <script src="/js/bootstrap-typeahead.js"></script>
    <script src="/js/jquery.form.js"></script>
    <script src="/js/tooltips.js"></script>
    <script src="/js/upload.js"></script>
    <script src="/js/jstree.js"></script>
	<cfloop array="#rc.js#" index="js">
	<cfoutput>#js#</cfoutput>
	</cfloop>
</body>
</html>