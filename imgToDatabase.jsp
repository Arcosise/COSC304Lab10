<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>


<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

    String imgURL = request.getParameter("ImgURL");
    String id = request.getParameter("id");
    

    String sql = "UPDATE product SET productImageURL = ? WHERE productId = ?";

    PreparedStatement pstmt = con.prepareStatement(sql);	
    pstmt.setString(1,imgURL);
    pstmt.setString(2, id);
    pstmt.executeUpdate();

} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

%>
<jsp:forward page="admin.jsp" />
</body>
</html>