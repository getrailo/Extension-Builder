<!DOCTYPE HTML>
<html>
<head>
	<title>Extension Builder SDK</title>
	<link rel="stylesheet" href="css/bootstrap.css">
	
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
        <div class="container">
          <a class="brand" href="#buildURL("main.default")#">Extension Builder SDK</a>
          <div class="nav-collapse">
            <ul class="nav">
             <li class="">
                <a href="#buildURL("extensions.list")#">My Extensions</a>
              </li>
             <li class="active">
                <a href="#buildURL("extensions.provider")#">Extension Provider</a>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
	</cfoutput>
	
	<div class="container">
		<cfoutput>#body#</cfoutput>	
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

</body>
</html>