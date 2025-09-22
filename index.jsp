<%@ 
	page import="com.sample.MyUtil" 
%>
<html>
<body>
<%
    String msg = MyUtil.hello();
    out.println(msg);
%>
</body>
</html>
