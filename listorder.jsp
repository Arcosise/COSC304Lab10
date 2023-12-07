<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title> Order List</title>
<style>
    body {
        background-color: pink; /* Set the background color to pink */
    }
</style>
<link rel="shortcut icon" href="img/Vigor.jpg" type="image/jpeg">
<link rel="icon" href="img/Vigor.jpg" type="image/jpeg">

</head>
<body>

<h1> Order List</h1>

<%
try {
    Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
} catch (java.lang.ClassNotFoundException e) {
    out.println("ClassNotFoundException: " + e);
}

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String q1 = "SELECT * FROM ordersummary join customer on ordersummary.customerId = customer.customerId";
    Statement s1 = con.createStatement();
    ResultSet rst1 = s1.executeQuery(q1);

	out.println("</ul><hr>");

    while (rst1.next()) {
        int orderId = rst1.getInt("orderId");

        out.println("<h3>Order ID: " + orderId + 
				  "</h3>");
		
		out.println("<h3> Order Date: " + rst1.getTimestamp("orderDate") + "</h3>");

		out.print("<h3>Customer Id: " + rst1.getInt("customerId") +
				  ", Customer Name: " + rst1.getString("firstName") + " " + rst1.getString("lastName") +  
				  "</h3>");

        String q2 = "SELECT * FROM orderproduct WHERE orderId = ?";
        try (PreparedStatement s2 = con.prepareStatement(q2)) {
            s2.setInt(1, orderId);
            ResultSet rst2 = s2.executeQuery();

            out.println("<ul>");
            while (rst2.next()) {
                out.println("<li>" + " Product Id: " + rst2.getInt("productId") +  ", Quantity: " +
                            rst2.getInt("quantity") + ", Price: " +
                            currFormat.format(rst2.getDouble("price")) +  "</li>");
            }
			out.print("<h4>Total Amount: " + currFormat.format(rst1.getDouble("totalAmount")) + "</h4>");
            out.println("</ul><hr>");
        }
    }
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>
</body>
</html>