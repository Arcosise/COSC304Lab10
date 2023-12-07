<%@ page import="java.sql.*, java.sql.Timestamp" %>
<%@ page import="java.net.URLEncoder" %>

<%
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String uid = "sa"; 
String pw = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, uid, pw)) {
    String prodid = request.getParameter("prodid");
    String custid = request.getParameter("custid");
    String review = request.getParameter("review");
    String rating = request.getParameter("rating");

    String sql = "INSERT INTO review(reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql);

    // Set parameters in the correct order
    pstmt.setString(1, rating);
    pstmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
    pstmt.setString(3, custid);
    pstmt.setString(4, prodid);
    pstmt.setString(5, review);

    pstmt.executeUpdate();

    response.sendRedirect("viewPurchasedProd.jsp?prodId=" + URLEncoder.encode(prodid, "UTF-8") + "&custId=" + URLEncoder.encode(custid, "UTF-8"));
} catch (SQLException ex) {
    out.println("SQLException: " + ex);
}
%>