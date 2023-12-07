<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Vigor Multivitamin</title>
	<style>
        body {
            background-color: pink; /* Set the background color to pink */
        }
		.custom-button {
            padding: 10px 20px; 
            background-color: #0a73e3; 
            color: rgb(0, 0, 0); 
            border: none; 
            border-radius: 5px; 
            cursor: pointer; 
            margin: 10px; 
            font-size: 16px; 
        }

        .custom-input {
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #000000; 
            font-size: 16px; 
            margin-right: 10px; 
            width: calc(60% - 22px); 
        }

        .search-container {
            margin-bottom: 20px;
        }

        form {
            display: flex;
            justify-content: center; 
            align-items: center; 
            gap: 10px; 
        }

        input[type="reset"] {
            background-color: #f44336; 
        }

        .form-header-container {
            text-align: center; 
        }

    </style>
    <link rel="shortcut icon" href="img/Vigor.jpg" type="image/jpeg">
    <link rel="icon" href="img/Vigor.jpg" type="image/jpeg">
</head>
<body>

<div style="position: absolute; top: 0; right: 0; padding: 10px;">
    <%
        String userName = (String) session.getAttribute("authenticatedUser");
        if (userName != null) {
            out.println("<h3>Signed in as: " + userName + "</h3>");
        }
    %>
    <a href="index.jsp" style="text-decoration: none;">
        <button style="margin-top: 5px;">Main Page</button>
    </a>
</div>


<div class="form-header-container">
    <h1>Search for the products you want to buy:</h1>

    <form method="get" action="listprod.jsp" class="search-container">
        <input type="text" name="productName" class="custom-input" placeholder="Enter product name...">
        <input type="submit" value="Submit" class="custom-button">
        <input type="reset" value="Reset" class="custom-button">
    </form>
</div>

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

	while(rst1.next()) {
		String pName = rst1.getString("productName");
		double price = rst1.getDouble("productPrice");
		String pId = rst1.getString("productId");
	
		out.println("<tr><td>" + pName + "</td><td>");
		out.println("<form action='product.jsp' method='get' style='display:inline;'>"); // Make sure the form is inline
		out.println("<input type='hidden' name='id' value='" + URLEncoder.encode(pId, "UTF-8") + "'>");
		out.println("<input type='hidden' name='name' value='" + URLEncoder.encode(pName, "UTF-8") + "'>");
		out.println("<input type='hidden' name='price' value='" + price + "'>");
		out.println("<button type='submit' class='custom-button'>Product Info</button>"); // Apply custom-button class
		out.println("</form>");
		out.println("</td></tr>");
	}

	out.println("</table>");

	out.println("<h2>Products By Category:</h2>");


	String q2 = "SELECT category.categoryName,product.productName,productPrice,productId,category.categoryId FROM category JOIN product ON category.categoryId = product.categoryId";
	PreparedStatement pstmt2 = con.prepareStatement(q2);

	ResultSet rst2 = pstmt2.executeQuery();
	String currentCategory = null;

	while(rst2.next()){

		int cId = rst2.getInt("categoryId");
		String cName = rst2.getString("categoryName");
		String pName = rst2.getString("productName");
		double pPrice = rst2.getDouble("productPrice");
		String pId = rst2.getString("productId");
	
		if (!cName.equals(currentCategory)) {
			if (currentCategory != null) {
				out.println("</table>");
			}
			out.println("<h3>" + cName + ":</h3>");
			out.println("<table>");
			out.println("<tr><th>Product Name</th></tr>");
			currentCategory = cName;
		}
	
		out.println("<tr><td>" + pName + "</td><td>");
		out.println("<form action='product.jsp' method='get'>");
		out.println("<input type='hidden' name='id' value='" + URLEncoder.encode(pId, "UTF-8") + "'>");
		out.println("<input type='hidden' name='name' value='" + URLEncoder.encode(pName, "UTF-8") + "'>");
		out.println("<input type='hidden' name='price' value='" + pPrice + "'>");
		out.println("<button type='submit' class='custom-button'>Product Info</button>");
		out.println("</form>");
		out.println("</td></tr>");
	}
	
	if (currentCategory != null) {
		out.println("</table>");
	}
	
	out.println("<h2>Products By Warehouse:</h2>");
	String q3 = "SELECT p.productName, pi.quantity, w.warehouseName FROM product p JOIN productinventory pi ON p.productId = pi.productId JOIN warehouse w ON pi.warehouseId = w.warehouseId";
	
	PreparedStatement pstmt3 = con.prepareStatement(q3);
	ResultSet rst3 = pstmt3.executeQuery();
	
	out.println("<table>");
	out.println("<tr><th>Warehouse</th><th>Product Name</th><th>Quantity</th></tr>");
	
	while (rst3.next()) {
        String warehouseName = rst3.getString("warehouseName");
        String productName = rst3.getString("productName");
        int quantity = rst3.getInt("quantity");

        out.println("<tr>");
        out.println("<td>" + warehouseName + "</td>");
        out.println("<td>" + productName + "</td>");
        out.println("<td>" + quantity + "</td>");
        out.println("</tr>");
    }
	out.println("</table>");

}  catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>
</body>
</html>