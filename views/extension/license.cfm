<cfparam name="rc.name">
<cfparam name="rc.license" default="">

<cfsavecontent variable="js">
</cfsavecontent>

<cfset ArrayAppend(rc.js, js)>
<cfoutput>
		<h1>License</h1>
		<p>Here you can add your own license to your extension, or select from some common licenses</p>
		<form action="#buildurl("extension.addlicense")#" method="post">
		<input type="hidden" name="name" value="#rc.name#">
		<fieldset>
		    <legend>License Text</legend>
		    <div class="control-group">
				<label class="control-label" for="license">License</label>
				<div class="controls">
		        <textarea name="license" id="license"  class="span10" rows="20">#rc.license#</textarea>
				</div>
			</div>
			
			<legend>Common Open Source licenses</legend>
			<p>You can choose a common open source licenses</p>
			<div>
			<select id="license_link" name="license_link" class="span10">
				<option value="custom">Other: (fill in your own text)</option>
				<optgroup label="Common Licenses">
					<option value="http://www.opensource.org/licenses/lgpl-2.1|GNU Library or 'Lesser' General Public License version 2.1 (LGPLv2.1)">GNU Library or "Lesser" General Public License version 2.1 (LGPLv2.1) (Like Railo)</option>
					<option value="http://www.opensource.org/licenses/apache2.0|Apache License, 2.0">Apache License, 2.0</option>
					<option value="http://www.opensource.org/licenses/eclipse-1.0|Eclipse Public License">Eclipse Public License</option>
					<option value="http://www.opensource.org/licenses/lgpl-3.0|GNU Library or 'Lesser' General Public License version 3.0 (LGPLv3)">GNU Library or "Lesser" General Public License version 3.0 (LGPLv3)</option>
					<option value="http://www.opensource.org/licenses/gpl-3.0|GNU General Public License version 3.0 (GPLv3)">GNU General Public License version 3.0 (GPLv3)</option>
				</optgroup>
				<optgroup label="Other Licenses">										
					<option value="http://www.opensource.org/licenses/afl-3.0|Academic Free License 3.0 (AFL 3.0)">Academic Free License 3.0 (AFL 3.0)</option>
					<option value="http://www.opensource.org/licenses/apl-1.0|Adaptive Public License">Adaptive Public License</option>
					<option value="http://www.opensource.org/licenses/apsl-2.0|Apple Public Source License">Apple Public Source License</option>
					<option value="http://www.opensource.org/licenses/artistic-license-2.0|Artistic license 2.0">Artistic license 2.0</option>
					<option value="http://www.opensource.org/licenses/attribution|Attribution Assurance Licenses">Attribution Assurance Licenses</option>
					<option value="http://www.opensource.org/licenses/bsd-license|BSD licenses (New and Simplified)">BSD licenses (New and Simplified)</option>
					<option value="http://www.opensource.org/licenses/bsl1.0|Boost Software License (BSL1.0)">Boost Software License (BSL1.0)</option>
					<option value="http://www.opensource.org/licenses/ca-tosl1.1|Computer Associates Trusted Open Source License 1.1">Computer Associates Trusted Open Source License 1.1</option>
					<option value="http://www.opensource.org/licenses/cddl1|Common Development and Distribution License">Common Development and Distribution License</option>
					<option value="http://www.opensource.org/licenses/cpal_1.0|Common Public Attribution License 1.0 (CPAL)">Common Public Attribution License 1.0 (CPAL)</option>
					<option value="http://www.opensource.org/licenses/cuaoffice|CUA Office Public License Version 1.0">CUA Office Public License Version 1.0</option>
					<option value="http://www.opensource.org/licenses/eudatagrid|EU DataGrid Software License">EU DataGrid Software License</option>
					<option value="http://www.opensource.org/licenses/ecl2|Educational Community License, Version 2.0">Educational Community License, Version 2.0</option>
					<option value="http://www.opensource.org/licenses/ver2_eiffel|Eiffel Forum License V2.0">Eiffel Forum License V2.0</option>
					<option value="http://www.opensource.org/licenses/entessa|Entessa Public License">Entessa Public License</option>
					<option value="http://www.osor.eu/eupl/european-union-public-licence-eupl-v.1.1|European Union Public License">European Union Public License</option>
					<option value="http://www.opensource.org/licenses/fair|Fair License">Fair License</option>
					<option value="http://www.opensource.org/licenses/frameworx|Frameworx License">Frameworx License</option>
					<option value="http://www.opensource.org/licenses/agpl-v3|GNU Affero General Public License v3 (AGPLv3)">GNU Affero General Public License v3 (AGPLv3)</option>
					<option value="http://www.opensource.org/licenses/gpl-2.0|GNU General Public License version 2.0 (GPLv2)">GNU General Public License version 2.0 (GPLv2)</option>
					<option value="http://www.opensource.org/licenses/historical|Historical Permission Notice and Disclaimer">Historical Permission Notice and Disclaimer</option>
					<option value="http://www.opensource.org/licenses/ibmpl|IBM Public License">IBM Public License</option>
					<option value="http://www.opensource.org/licenses/ipafont|IPA Font License">IPA Font License</option>
					<option value="http://www.opensource.org/licenses/isc-license|ISC License">ISC License</option>
					<option value="http://www.opensource.org/licenses/lppl|LaTeX Project Public License (LPPL)">LaTeX Project Public License (LPPL)</option>
					<option value="http://www.opensource.org/licenses/lucent1.02|Lucent Public License Version 1.02">Lucent Public License Version 1.02</option>
					<option value="http://www.opensource.org/licenses/miros|MirOS Licence">MirOS Licence</option>
					<option value="http://www.opensource.org/licenses/ms-pl|Microsoft Public License (Ms-PL)">Microsoft Public License (Ms-PL)</option>
					<option value="http://www.opensource.org/licenses/ms-rl|Microsoft Reciprocal License (Ms-RL)">Microsoft Reciprocal License (Ms-RL)</option>
					<option value="http://www.opensource.org/licenses/mit-license|MIT license">MIT license</option>
					<option value="http://www.opensource.org/licenses/motosoto|Motosoto License">Motosoto License</option>
					<option value="http://www.opensource.org/licenses/mozilla1.1|Mozilla Public License 1.1 (MPL)">Mozilla Public License 1.1 (MPL)</option>
					<option value="http://www.opensource.org/licenses/multics|Multics License">Multics License</option>
					<option value="http://www.opensource.org/licenses/nasa1.3|NASA Open Source Agreement 1.3">NASA Open Source Agreement 1.3</option>
					<option value="http://www.opensource.org/licenses/ntp-license|NTP License">NTP License</option>
					<option value="http://www.opensource.org/licenses/naumen|Naumen Public License">Naumen Public License</option>
					<option value="http://www.opensource.org/licenses/nethack|Nethack General Public License">Nethack General Public License</option>
					<option value="http://www.opensource.org/licenses/nokia|Nokia Open Source License">Nokia Open Source License</option>
					<option value="http://www.opensource.org/licenses/NOSL3.0|Non-Profit Open Software License 3.0 (Non-Profit OSL 3.0)">Non-Profit Open Software License 3.0 (Non-Profit OSL 3.0)</option>
					<option value="http://www.opensource.org/licenses/oclc2|OCLC Research Public License 2.0">OCLC Research Public License 2.0</option>
					<option value="http://www.opensource.org/licenses/openfont|Open Font License 1.1 (OFL 1.1)">Open Font License 1.1 (OFL 1.1)</option>
					<option value="http://www.opensource.org/licenses/opengroup|Open Group Test Suite License">Open Group Test Suite License</option>
					<option value="http://www.opensource.org/licenses/osl-3.0|Open Software License 3.0 (OSL 3.0)">Open Software License 3.0 (OSL 3.0)</option>
					<option value="http://www.opensource.org/licenses/php|PHP License">PHP License</option>
					<option value="http://www.opensource.org/licenses/postgresql|The PostgreSQL License">The PostgreSQL License</option>
					<option value="http://www.opensource.org/licenses/pythonpl|Python license (CNRI Python License)">Python license (CNRI Python License)</option>
					<option value="http://www.opensource.org/licenses/PythonSoftFoundation|Python Software Foundation License">Python Software Foundation License</option>
					<option value="http://www.opensource.org/licenses/qtpl|Qt Public License (QPL)">Qt Public License (QPL)</option>
					<option value="http://www.opensource.org/licenses/real|RealNetworks Public Source License V1.0">RealNetworks Public Source License V1.0</option>
					<option value="http://www.opensource.org/licenses/rpl1.5|Reciprocal Public License 1.5 (RPL1.5)">Reciprocal Public License 1.5 (RPL1.5)</option>
					<option value="http://www.opensource.org/licenses/ricohpl|Ricoh Source Code Public License">Ricoh Source Code Public License</option>
					<option value="http://www.opensource.org/licenses/simpl-2.0|Simple Public License 2.0">Simple Public License 2.0</option>
					<option value="http://www.opensource.org/licenses/sleepycat|Sleepycat License">Sleepycat License</option>
					<option value="http://www.opensource.org/licenses/sunpublic|Sun Public License">Sun Public License</option>
					<option value="http://www.opensource.org/licenses/sybase|Sybase Open Watcom Public License 1.0">Sybase Open Watcom Public License 1.0</option>
					<option value="http://www.opensource.org/licenses/UoI-NCSA|University of Illinois/NCSA Open Source License">University of Illinois/NCSA Open Source License</option>
					<option value="http://www.opensource.org/licenses/vovidapl|Vovida Software License v. 1.0">Vovida Software License v. 1.0</option>
					<option value="http://www.opensource.org/licenses/W3C|W3C License">W3C License</option>
					<option value="http://www.opensource.org/licenses/wxwindows|wxWindows Library License">wxWindows Library License</option>
					<option value="http://www.opensource.org/licenses/xnet|X.Net License">X.Net License</option>
					<option value="http://www.opensource.org/licenses/zpl|Zope Public License">Zope Public License</option>
					<option value="http://www.opensource.org/licenses/zlib-license|zlib/libpng license">zlib/libpng license</option>
					</optgroup>
				</select>
			</div>
			
		</fieldset>
		<div class="form-actions">
            	<button type="submit" class="btn btn-primary">Save License</button>
			</div>
		</form>
</cfoutput>