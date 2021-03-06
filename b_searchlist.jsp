<%@ page import="org.baraza.web.*" %>

<%

	ServletContext context = getServletContext();
	String dbconfig = "java:/comp/env/jdbc/database";
	String ps = System.getProperty("file.separator");

	String title = context.getInitParameter("web_title");
	String xmlcnf = (String)session.getAttribute("xmlcnf");
	String xmlfile = context.getRealPath("WEB-INF") + ps + "configs" + ps + xmlcnf;
	String reportPath = context.getRealPath("reports") + ps;

	String entryformid = null;
	String view = request.getParameter("view");
	String action = request.getParameter("action");
	String value = request.getParameter("value");
	String post = request.getParameter("post");
	String process = request.getParameter("process");
	String reportexport = request.getParameter("reportexport");

	String userIP = request.getRemoteAddr();
	String userName = request.getRemoteUser();

	BWeb web = new BWeb(dbconfig, xmlfile);
	web.setUser(userIP, userName);
	web.init(request);

	String fieldTitles = web.getFieldTitles();

	if(process != null) {
		if(process.equals("Update")) {
			web.updateForm(request);
		} else if(process.equals("Delete")) {
			web.deleteForm(request);
		} else if(process.equals("Submit")) {
			web.submitGrid(request);
		}
	}

%>

<%@ include file="/resources/include/init.jsp" %>

	<script type="text/javascript">

		function updateForm(valueid, valuename) {

			opener.document.baraza.<%= web.getSearchReturn() %>.value = valueid;
			opener.document.baraza.<%= web.getSearchReturn() %>_name.value = valuename;

			self.close();

			return false;
		}
	</script>

</head>
<body>

	<form id="baraza" name="baraza" method="post" action="b_searchlist.jsp">
		<%= web.getHiddenValues() %>
		<%= web.getTabs() %>
		<%= web.getButtons() %>
		<%= web.getBody(request, reportPath) %>
		<%= web.getFilters() %>

		<% if(fieldTitles != null) { %>
			<table border="0" cellpadding="0" cellspacing="0">
			   <td width="100"><%= fieldTitles %></td>
			   <td width="100">
				<select class='fnctcombobox' name='filtertype'>
					<option value='ilike'>Contains (case insensitive)</option>
					<option value='like'>Contains (case sensitive)</option>
					<option value='='>Equal to</option>
					<option value='>'>Greater than</option>
					<option value='<'>Less than</option>
					<option value='<='>Less or Equal</option>
					<option value='>='>Greater or Equal</option>
				</select>
				</td>
			   <td width="55"><button class="i_arrow_down icon small" name="sortdesc" id="descending" value=" ">DESC</button></td>
				<td width="55"><button class="i_arrow_up icon small" name="sortasc" id="ascending" value=" ">ASC</button></td>
			   <td width="180"><input name="reportfilter" type="text" id="search" /></td>
			   <td width="55"><input name='and' type='checkbox'/> And</td>
			   <td width="55"><input name='or' type='checkbox' /> Or</td>
				<td style="text-align: left;"><button class="i_magnifying_glass icon small" name="search" value="Search">Search</button></td>
			</tr>
			</table>

		<% } %>

		<% if(web.isForm()) out.println(web.getFormButtons()); %>

		<div style='color:#FF0000'><%= web.getSaveMsg() %></div>
		<%= web.showFooter() %>
	</form>

	<% 	web.close(); %>

</body>
</html>
