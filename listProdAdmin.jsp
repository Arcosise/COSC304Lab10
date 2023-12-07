<!DOCTYPE html>
<html>
<head>
    
<title>Customer List</title>
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
    String q2 = "SELECT * FROM product";
    Statement s2 = con.createStatement();
    ResultSet rst2 = s2.executeQuery(q2);

    out.println("<h2>Product List</h2>");
    out.print("<tr><td><a href='addProductCheck.jsp?id='>Add a Product</a></td></tr>");
    out.println("<table>");
    out.println("<tr><td>" + "ID" + "</td><td>" + " " + "Name" + "</td><td>" + " " + "Price" + "</td><td>" + " " + "Amount per item" + "</td><td>"+ " "  + "Category ID" + "</td></tr>");
    while(rst2.next()){
        out.println("<tr><td>" + rst2.getString(1) + "</td><td>" + " " + rst2.getString(2) + "</td><td>" + " " + rst2.getString(3) + "</td><td>" + " " + rst2.getString(4) + "</td><td>"+ " "  + rst2.getString(6) + "</td><td>"+ " "  + rst2.getString(7) + "</td><td><a href='deleteProdCheck.jsp?id=" + URLEncoder.encode(rst2.getString(1).toString(), "UTF-8") + "&name=" + URLEncoder.encode(rst2.getString(2).toString(), "UTF-8") + "&price=" + rst2.getString(3).toString() + "'>Delete Item</a></td>"+ " " +"<td><a href='updateItemCheck.jsp?id=" + URLEncoder.encode(rst2.getString(1).toString(), "UTF-8") + "&name=" + URLEncoder.encode(rst2.getString(2).toString(), "UTF-8") + "&price=" + rst2.getString(3).toString() + "'>Update Item</a></td></tr>");
    }
    out.println("</table>");
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

%>

</body>
</html>