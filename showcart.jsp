<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Shopping Cart</title>
    <style>
        body {
            background-color: pink;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid black; /* Add black border to the table */
        }
        th, td {
            border: 1px solid black; /* Add black border to table cells */
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #ffc0cb; /* Set a pink background for table headers */
        }
        .custom-button, .custom-button-link, .custom-link-button {
            padding: 10px 20px;
            background-color: #0a73e3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin: 10px;
            font-size: 16px;
            text-align: center;
        }
        .custom-button:hover, .custom-button-link:hover, .custom-link-button:hover {
            background-color: #0056b3;
        }
        .button-container {
            text-align: center; 
            margin-top: 20px;
        }
    </style>
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
        <button style="margin-right: 5px;">Home</button>
    </a>
    <a href="listprod.jsp" style="text-decoration: none;">
        <button>Product List</button>
    </a>
</div>


<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();

	out.println("<h1>Your Shopping Cart</h1>");
	out.print("<table><tr><th>Product Id</th><th>Product Name</th><th>Quantity</th>");
	out.println("<th>Price</th><th>Subtotal</th></tr>");

	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		
		Object price = product.get(2);

		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		
		String productName = URLDecoder.decode(product.get(1).toString(), "UTF-8"); // Decode the product name

		if(qty > 0){
			out.print("<tr><td>" + product.get(0) + "</td>");
			out.print("<td>" + productName + "</td>");
		
			out.print("<td align=\"center\">"+product.get(3)+"</td>");


			out.print("<td align=\"right\">"+currFormat.format(pr)+"</td>");
			out.print("<td align=\"right\">" + currFormat.format(pr * qty) + "</td>" +
			"<td><a href='removeCart.jsp?id=" + URLEncoder.encode(product.get(0).toString(), "UTF-8") +
			"&name=" + URLEncoder.encode(product.get(1).toString(), "UTF-8") +
			"&price=" + product.get(2).toString() +
			"' class='custom-link-button'>Remove</a></td>" +
			"<td><a href='askQty.jsp?id=" + URLEncoder.encode(product.get(0).toString(), "UTF-8") +
			"&name=" + URLEncoder.encode(product.get(1).toString(), "UTF-8") +
			"&price=" + product.get(2).toString() +
			"' class='custom-link-button'>Change QTY</a></td>");
		  
			out.println("</tr>");
		}

		total = total +pr*qty;
	}
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"
			+"<td align=\"right\">"+currFormat.format(total)+"</td></tr>");
	out.println("</table>");
}
%>

<div class="button-container">
    <a href="checkout.jsp" class="custom-button-link">Check Out</a>
    <a href="listprod.jsp" class="custom-button-link">Continue Shopping</a>
</div>
</body>
</html> 

