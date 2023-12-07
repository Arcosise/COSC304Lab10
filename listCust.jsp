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
    String q2 = "SELECT * FROM customer";
    Statement s2 = con.createStatement();
    ResultSet rst2 = s2.executeQuery(q2);

    out.println("<h2>CUSTOMER LIST</h2>");
    out.println("<table>");
    out.println("<tr><td>" + "FirstvName" + "</td><td>" + " " + "Last Name" + "</td><td>" + " " + "Email" + "</td><td>" + " " + "Country" + "</td><td>"+ " "  + "Phone Number" + "</td><td>"+ " "  + "Address" + "</td><td>"+ " "  + "City" + "</td><td>"+ " "  + "State" + "</td><td>"+ " "  + "Postal Code" + "</td><td>"+ " "  + "User id" + "</td><td>"+ " "  + "Password" + "</td></tr>");
    while(rst2.next()){
        out.println("<tr><td>" + rst2.getString("firstName") + "</td><td>" + " " + rst2.getString("lastName") + "</td><td>" + " " + rst2.getString("email") + "</td><td>" + " " + rst2.getString("country") + "</td><td>"+ " "  + rst2.getString("phonenum") + "</td><td>"+ " "  + rst2.getString("address") + "</td><td>"+ " "  + rst2.getString("city") + "</td><td>"+ " "  + rst2.getString("state") + "</td><td>"+ " "  + rst2.getString("postalCode") + "</td><td>"+ " "  + rst2.getString("userid") + "</td><td>"+ " "  + rst2.getString("password") + "</td></tr>");

    }
    out.println("</table>");
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}

%>

</body>
</html>