<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

String userName = (String) session.getAttribute("authenticatedUser");

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String sql = "SELECT * FROM customer WHERE userid = ?";
    PreparedStatement pstmt = con.prepareStatement(sql); 
    pstmt.setString(1, userName);
    ResultSet rst = pstmt.executeQuery();

    out.println("<h3>Customer Profile Information:</h3>");
    out.println("<table>");

    while(rst.next()) {
        out.println("<tr><th>First Name:</th><td>" + rst.getString("firstName") + "</td></tr>");
        out.println("<tr><th>Last Name:</th><td>" + rst.getString("lastName") + "</td></tr>");
        out.println("<tr><th>Email:</th><td>" + rst.getString("email") + "</td></tr>");
        out.println("<tr><th>Phone:</th><td>" + rst.getString("phonenum") + "</td></tr>");
        out.println("<tr><th>Address:</th><td>" + rst.getString("address") + "</td></tr>");
        out.println("<tr><th>City:</th><td>" + rst.getString("city") + "</td></tr>");
        out.println("<tr><th>State:</th><td>" + rst.getString("state") + "</td></tr>");
        out.println("<tr><th>Postal Code:</th><td>" + rst.getString("postalCode") + "</td></tr>");
        out.println("<tr><th>Country:</th><td>" + rst.getString("country") + "</td></tr>");
        out.println("<tr><th>User Id:</th><td>" + rst.getString("userid") + "</td></tr>");
    }
    out.println("</table>");

} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>

</body>
</html>
