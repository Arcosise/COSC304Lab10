//Ask user input for an item amount and hold needed variables
<%
    String prodid, custid;

    prodid = request.getParameter("id");
    custid = request.getParameter("custId");


 %>


<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>

<h1>Enter your review and then rating: </h1>

<form method="get" action="addReview.jsp">
<input type="text" name="review" size="1000">
<input type="text" name="rating" size="1">
<input type="hidden" name="prodid" value= <%= prodid %>>
<input type="hidden" name="custid" value= <%= custid %>>

<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>