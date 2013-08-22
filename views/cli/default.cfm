<cfparam name="rc.climodules" default="#[]#">
<cfoutput>
<h1>Add CLI Modules</h1>
    <p>
    	CLI Modules extend the functionality of the Railo CLI by adding "nouns" and "verbs" that can call via:
<pre>
$ railo  &lt;noun&gt; &lt;verb&gt;
</pre>

So for example you could call the Railo package manager as:
<pre>
 $ railo pm list
</pre>


</p>
    <p>In this section you can add your own Administrator plugins, by uploading them, they will be automatically installed (and uninstalled)</p>

   
</cfoutput>