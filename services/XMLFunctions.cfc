<cfcomponent output="no">

	<cffunction name="indentXML" returntype="string" output="no" access="public">
		<cfargument name="code" type="string" />
		<cfset var indent = -1 />
		<cfset var findings = "" />
		<cfset var tag = "" />
		<cfset var lastTag = "" />
		<cfset var doIndent = false />
		<cfset var nextStartTagOnSameLine = false />
		<cfset var nextTagOnNewLine = false />
		
		<!---<cfset arguments.code = rereplace(arguments.code, '[\n\r\t]+', ' ', 'all') />--->
		<cfloop condition="refind('<(.*?>)', code)">
			<cfset doIndent = false />
			<cfset findings = refind('<(.*?>)', code, 1, true) />
			<cfset tag = mid(code, findings.pos[2], findings.len[2]) />
			<!--- cdata --->
			<cfif find('![CDATA[', tag) eq 1>
				<!--- just append it to the current tag --->
			<!---end-tag--->
			<cfelseif find('/', tag) eq 1>
				<cfif lastTag neq listfirst(tag, ' 	/>#chr(10)##chr(13)#')>
					<cfset indent-=1 />
					<cfset doIndent = true />
					<cfset nextTagOnNewLine = true />
				<cfelse>
					<cfset nextTagOnNewLine = false />
				</cfif>
				<cfset nextStartTagOnSameLine = true />
				<cfset lastTag = "" />
			<!--- self-closing tag --->
			<cfelseif find('/>', tag)>
				<cfset doIndent = true />
				<cfset lastTag = "" />
				<cfif nextTagOnNewLine>
					<cfset indent++ />
					<cfset nextTagOnNewLine = false />
				</cfif>
			<!--- start tag--->
			<cfelseif not find('?>', tag)>
				<cfif not nextStartTagOnSameLine>
					<cfset indent+=1 />
				<cfelse>
					<cfset nextTagOnNewLine = true />
				</cfif>
				<cfset doIndent = true />
				<cfset nextStartTagOnSameLine = false />
				<cfset lastTag = listfirst(tag, ' 	/>#chr(10)##chr(13)#') />
			</cfif>
			<cfset code = rereplace(code, '[\r\n\t ]+(<.*?>)', '\1') />
			<cfif doIndent and indent gt -1>
				<cfset code = replace(code, '<#tag#', '#chr(10)##repeatString('    ', indent)#±#tag#') />
			<cfelse>
				<cfset code = replace(code, '<#tag#', '±#tag#') />
			</cfif>
		</cfloop>
		<cfset code = replace(code, '±', '<', 'all') />
		<cfreturn code />
	</cffunction>
</cfcomponent>