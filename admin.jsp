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
    String q2 = "SELECT * FROM product";
    Statement s2 = con.createStatement();
    ResultSet rst2 = s2.executeQuery(q2);
    out.print("<tr><td><a href='addImg.jsp?id='>Add Image</a></td></tr>");

    out.print("<tr><td><a href='listCust.jsp?id='>List Customers</a></td></tr>");
    
    out.print("<tr><td><a href='listProdAdmin.jsp?id='>List Products</a></td></tr>");
    String q1 = "SELECT CAST(orderDate AS DATE) as OrderDay, SUM(totalAmount) as TotalSales FROM ordersummary GROUP BY CAST(orderDate AS DATE) ORDER BY CAST(orderDate AS DATE) asc";
    Statement s1 = con.createStatement();
    ResultSet rst = s1.executeQuery(q1);
    

    out.println("<h3>Administrator Sales Report by Day:</h3>");
    out.println("<table>");
    out.println("<tr><th>Order Date</th><th>Total Sales</th></tr>");

    while(rst.next()){
        out.println("<tr><td>" + rst.getDate("OrderDay") + "</td><td>" + NumberFormat.getCurrencyInstance().format(rst.getDouble("TotalSales")) + "</td>");
    }

} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

%>

</body>
</html>