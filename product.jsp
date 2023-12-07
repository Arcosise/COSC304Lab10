<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%
String id, name, price,productImageURL;

id = request.getParameter("id");
name = request.getParameter("name");
price = request.getParameter("price");
productImageURL = request.getParameter("productImageURL");

// Get product name to search for
// TODO: Retrieve and display info for the product
// String productId = request.getParameter("id");
String imgurl = request.getContextPath() + "/" + productImageURL;



%>


<html>
<head>

    <img src="img/Title.jpg" alt="Photograph of a chocolate cupcake.">
<title>Brandon and Peter's Grocery</title>
<link href="css/bootstrap.min.css" rel="stylesheet">
</head>
<body>


    <img src='<%= imgurl %>'>

    


<%

try {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
String sql = "SELECT * FROM review WHERE productId = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, id);
ResultSet rst1 = pstmt.executeQuery();


out.println("<table>");   
out.println("<h2>" + name + "</h2></tr>");
out.println("<th>Id </th><th>price</th></tr>");
out.println("<tr><td>" + id + "</td><td>" + price + "</td><td>" + productImageURL + "</td></tr>");

out.println("<tr><td><a href=\"listprod.jsp\">Continue Shopping </a></td>" + "</td><td><a href='addcart.jsp?id=" + URLEncoder.encode(id, "UTF-8") + "&name=" + URLEncoder.encode(name, "UTF-8") + "&price=" + price + "'>Add to Cart</a></td></tr>");
int count = 0;
while(rst1.next() && count < 10){
    out.println("<tr><td>" + rst1.getString("reviewComment") + "</td></tr>");
    count++;
}
out.println("</table>");
// TODO: If there is a productImageURL, display using IMG tag
		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>

</body>
</html>

