<!DOCTYPE html>
<html>
<head>
    
<title>Delete Product</title>
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
    try{
        con.setAutoCommit(false);

        // Delete from related tables first (if applicable)
    
        // Delete from the product table
        String id = request.getParameter("id");

        String disableFKConstraints = "ALTER TABLE orderproduct NOCHECK CONSTRAINT ALL";
        PreparedStatement disableFKStmt = con.prepareStatement(disableFKConstraints);
        disableFKStmt.executeUpdate();



        String sql3 = "DELETE FROM incart WHERE productId = ?";
        PreparedStatement pstmt3 = con.prepareStatement(sql3);
        pstmt3.setString(1, id);
        pstmt3.executeUpdate();

        String sql4 = "DELETE FROM productinventory WHERE productId = ?";
        PreparedStatement pstmt4 = con.prepareStatement(sql4);
        pstmt4.setString(1, id);
        pstmt4.executeUpdate();

        String sql6 = "DELETE FROM review WHERE productId = ?";
        PreparedStatement pstmt6 = con.prepareStatement(sql6);
        pstmt6.setString(1, id);
        pstmt6.executeUpdate();
        
        String sql2 = "DELETE FROM category WHERE productId = ?";
        PreparedStatement pstmt2 = con.prepareStatement(sql2);
        pstmt2.setString(1, id);
        pstmt2.executeUpdate();
    

    



    
        String sql = "DELETE FROM product WHERE productId = ?";
        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, id);
        pstmt.executeUpdate();
        
        String enableFKConstraints = "ALTER TABLE orderproduct WITH CHECK CHECK CONSTRAINT ALL";
        PreparedStatement enableFKStmt = con.prepareStatement(enableFKConstraints);
        enableFKStmt.executeUpdate();
    
        con.commit();
        con.setAutoCommit(true);
    } catch (SQLException ex) {
        con.rollback();
    }

    
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

response.sendRedirect("listProdAdmin.jsp");
%>

</body>
</html>