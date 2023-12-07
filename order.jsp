<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
	<title>Vigor Multivitamin</title>
	<style>
        body {
            background-color: pink; 
        }

		button {
		background-color: #0a73e3; 
		color: white; 
		padding: 10px 20px; 
		border: none; 
		border-radius: 5px; 
		cursor: pointer; 
		font-size: 16px;
		}
		
    </style>
    <link rel="shortcut icon" href="img/Vigor.jpg" type="image/jpeg">
    <link rel="icon" href="img/Vigor.jpg" type="image/jpeg">
</head>
<body>

<% 
String custId = request.getParameter("customerId");
String custPass = request.getParameter("password");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");



String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {

	// generate the orderId and insert default values into ordersummary
	String q = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, ?, ?)";
	PreparedStatement pstmt = con.prepareStatement(q, Statement.RETURN_GENERATED_KEYS);	
	pstmt.setInt(1,Integer.parseInt(custId));
	pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
	pstmt.setDouble(3,0.0);
	pstmt.executeUpdate();

	String q4 ="SELECT customerId, password FROM customer";
	Statement stmt = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	ResultSet rst4 = stmt.executeQuery(q4);
	
	boolean loopIsRunning = true;
	while(rst4.next() && loopIsRunning){
		try{
			//Check customer Id and password
			String tempId = Integer.toString(rst4.getInt(1));
			String tempPass = rst4.getString(2);
			if(custId.equals(tempId) && custPass.equals(tempPass)){
				if (productList == null || productList.isEmpty()){
					out.println("<h3>You shopping cart is empty. Please return to the store and fill it!</h3>");
					loopIsRunning = false;
				} else {
					out.println("<h2>Your Order Summary</h2>");

					// get the orderId
					ResultSet keys = pstmt.getGeneratedKeys();
					keys.next();
					int orderId = keys.getInt(1);
					
					//start the table print
					out.println("<table>");
					out.println("<tr><th>Product Id</th><th>Product Name</th><th>Quantity</th><th>Price</th><th>Subtotal</th></tr>");
				
					double total = 0;
				
					Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
					while (iterator.hasNext()) { 
				
				
						// retrieve the input from the hashtable:
						Map.Entry<String, ArrayList<Object>> entry = iterator.next();
						ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
						String productId = (String) product.get(0);
						String price = (String) product.get(2);
						int quantity = ((Integer)product.get(3)).intValue();
						double subTotal = Double.parseDouble(price)*quantity;
						total += subTotal;
				
						// add into the database
						String q1 = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (?,?,?,?)";
						PreparedStatement pstmt1 = con.prepareStatement(q1);
						pstmt1.setInt(1,orderId);
						pstmt1.setInt(2,Integer.parseInt(productId));
						pstmt1.setInt(3,quantity);
						pstmt1.setDouble(4,Double.parseDouble(price));
						pstmt1.executeUpdate();
				
						String productName = (String) product.get(1);
						
						out.println("<tr><td>" + productId + "</td><td>" + productName + "</td><td>" + quantity + "</td><td>" + price + "</td><td>" + subTotal + "</td></tr>");
				
					}	
					
					// update the ordersummary
					String q2 = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
					PreparedStatement pstmt2 = con.prepareStatement(q2);
					pstmt2.setDouble(1, total);
					pstmt2.setInt(2, orderId);
					pstmt2.executeUpdate();
				
					out.println("<tr><td>Total Amount</td><td>" + NumberFormat.getCurrencyInstance().format(total) + "</td></tr>");
					out.println("</table>");
				
				
					// retrieve the customers name. Its probably possible to get it in an easier way but I don't know
					String q3 = "SELECT * FROM customer WHERE customerId = ?";
					PreparedStatement pstmt3 = con.prepareStatement(q3);
					pstmt3.setInt(1, Integer.parseInt(custId)); 
					ResultSet rst3 = pstmt3.executeQuery();
				
					String fn = "";
					String ln = "";
					if (rst3.next()) {
						fn = rst3.getString("firstName"); 
						ln = rst3.getString("lastName"); 
					}
					rst3.close();
					pstmt3.close();
				
					out.println("<h2>Order Completed. Will be shipped soon....</h2>");
					out.println("<h2>You order reference number is: " + orderId + "</h2>");
					out.println("<h2>Shipping to Customer: " + custId + " Name: " + fn + " " + ln + "</h2>");

					

					loopIsRunning = false;
				}
	
			} else if (rst4.isLast()) {
				out.println("<h3>Invalid ID. Please return to the previous page and enter a valid number.</h3>");
			}
		} catch (NumberFormatException e) {
			out.println("<h3>Invalid ID. Please return to the previous page and enter a valid number.</h3>");
		}

	}
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
// remove the contents of the shopping cart
session.removeAttribute("productList");
%>
<form action="index.jsp" method="get">
    <button type="submit">Return to Main Page</button>
</form>

</BODY>
</HTML>