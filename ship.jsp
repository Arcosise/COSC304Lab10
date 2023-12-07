<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Peter and Brandon Grocery Shipment Processing</title>
</head>
<body>
        

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
	
    int id = Integer.parseInt(request.getParameter("orderId"));

	String q1="SELECT ordersummary.orderId, COUNT(orderproduct.orderId) FROM ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId WHERE ordersummary.orderId=? GROUP BY ordersummary.orderId HAVING COUNT(orderproduct.orderId) <= 3";
	PreparedStatement pstmt = con.prepareStatement(q1);
	pstmt.setInt(1, id);
    ResultSet rst1 = pstmt.executeQuery();
	out.println("<table>");  
	if(rst1.next()){
		con.setAutoCommit(false);
		String q2="SELECT ordersummary.orderId, orderproduct.productId,orderproduct.quantity,productinventory.quantity FROM ordersummary JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId JOIN productinventory ON orderproduct.productId = productinventory.productId JOIN warehouse ON productinventory.warehouseId = warehouse.warehouseId WHERE ordersummary.orderId=? AND warehouse.warehouseId=? ORDER BY orderproduct.productId ASC";
		PreparedStatement pstmt2 = con.prepareStatement(q2);
		pstmt2.setInt(1, id);
		pstmt2.setInt(2, 1);
		ResultSet rst2 = pstmt2.executeQuery();
		con.commit();

		while(rst2.next()){
			int prodId = rst2.getInt(2);
			int newInv = (rst2.getInt(4)-rst2.getInt(3));
			if( newInv < 0){
				out.println("<tr><td>Shipment not done. Insufficient inventory for product id:</td><td>"+ rst2.getInt(2) +"</td></tr>");
				con.rollback();
				break;
			} else {
				String q3 = "UPDATE productinventory SET quantity = ? WHERE warehouseId = ? AND productId = ?";
				
				
				PreparedStatement pstmt3 = con.prepareStatement(q3);
				pstmt3.setInt(1, newInv);
				pstmt3.setInt(2, 1);
				pstmt3.setInt(3, prodId);
				pstmt3.executeUpdate();

				out.println("<tr><td>Ordered product: </td><td>"+ rst2.getInt(2) +"</td><td> Qty: </td><td>" + rst2.getInt(3) +"</td><td>Previous inventory: </td><td>" + rst2.getInt(4) +"</td><td>New inventory: </td><td>"+ newInv +"</td></tr>");

			}
		}
		if(rst2.isAfterLast()){
			String q4 = "INSERT INTO shipment(shipmentDate,shipmentDesc,warehouseId) VALUES (?,?,?)";
			PreparedStatement pstmt4 = con.prepareStatement(q4);
        	pstmt4.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
        	pstmt4.setString(2, "Shipment description"); 
        	pstmt4.setInt(3, 1); 
        	pstmt4.executeUpdate();	
			con.commit();
			con.setAutoCommit(true);
		}
		out.println("</table>");
		rst2 = pstmt2.executeQuery();
		out.println("<table>"); 
		while(rst2.next()){
			out.println("<tr><td>Ordered product: </td><td>"+ rst2.getInt(2) +"</td><td>Current inventory: </td><td>" + rst2.getInt(4) +"</td></tr>");
		}
		out.println("</table>");


		out.println("</table>");
		String ship = "SELECT shipmentId,shipmentDate,shipmentDesc,warehouseId FROM shipment";
		PreparedStatement pstmt5 = con.prepareStatement(ship);
		ResultSet rst3 = pstmt5.executeQuery();
		out.println("<table>"); 
		while(rst3.next()){
			out.println("<tr><td>ShipId: </td><td>"+ rst3.getInt(1) +"</td><td>Date: </td><td>" + rst3.getDate(2) +"</td><td>ShipDesc: </td><td>"+ rst3.getString(3) +"</td><td> warehouseId</td><td>" + rst3.getInt(4) +"</td></tr>");
		}
		out.println("</table>");
		
		
	} else{
		out.println("<tr><td>Invalid orderId</td></tr>");
	}
	
			// TODO: Get order id
          
			// TODO: Check if valid order id in database
			
			// TODO: Start a transaction (turn-off auto-commit)
			
			// TODO: Retrieve all items in order with given id
			// TODO: Create a new shipment record.
			// TODO: For each item verify sufficient quantity available in warehouse 1.
			// TODO: If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
			
			// TODO: Auto-commit should be turned back on

			
    
} catch (SQLException ex) {
	
    out.println("SQLException: " + ex);
}
%>


<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>

