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
<%@ page import="java.math.BigDecimal" %>



<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {


    String name = request.getParameter("name");
    String price = request.getParameter("price");
    String desc = request.getParameter("desc");
    String catId = request.getParameter("catId");
    String id = request.getParameter("id");
    

    String sql = "UPDATE product SET productName=?, categoryId=?, productDesc=?, productPrice=? WHERE productId = ?";

    PreparedStatement pstmt = con.prepareStatement(sql);	
    pstmt.setString(1,name);
    pstmt.setString(2, catId);
    pstmt.setString(3, desc);
    pstmt.setString(4, price);
    pstmt.setString(5, id);
    int rowsAffected = pstmt.executeUpdate();

} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

%>
<jsp:forward page="listProdAdmin.jsp" />
</body>
</html>