<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title> Brandon & Peter Grocery</title>
</head>
<body>

<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% 
String name = request.getParameter("productName");
		
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

	String q1;
    if(name == null || name.equals("")){

		q1 = "SELECT * FROM product";
		out.println("<h2>All Products:</h2>");
	} else {

		q1 = "SELECT * FROM product WHERE productName LIKE ?";
		out.print("<h2>Products Containing: '" + name + "'</h2>");
	}

	PreparedStatement pstmt = con.prepareStatement(q1);
	
	if (name != null && !name.equals("")) {
		pstmt.setString(1, "%" + name + "%");
	}

	ResultSet rst1 = pstmt.executeQuery();
	
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<table>");
	out.println("<tr><th>Product Name</th></tr>");

	while(rst1.next()){
		String pName = rst1.getString("productName");
		double price = rst1.getDouble("productPrice");
		String pId = rst1.getString("productId");
		String productImageURL = rst1.getString("productImageURL");

		out.print("<tr><td>" + pName + "</td><td><a href='product.jsp?id=" + URLEncoder.encode(pId, "UTF-8") +
			"&name=" + URLEncoder.encode(pName, "UTF-8") +
			"&price=" + price +
			(productImageURL != null ? "&productImageURL=" + URLEncoder.encode(productImageURL, "UTF-8") : "") +
			"'>ProductInfo</a></td></tr>");
		
		if (productImageURL != null) {
			out.print("<h2>'" + productImageURL + "'</h2>");
            }
		
	}

	

	out.println("</table>");
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>

</body>
</html>