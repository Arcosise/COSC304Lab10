//Ask user input for an item amount and hold needed variables
<%
    String id, name, price;

    id = request.getParameter("id");
    name = request.getParameter("name");
    price = request.getParameter("price");

 %>


<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>

<h1>Enter new amount:</h1>

<form method="get" action="changeQty.jsp">
<input type="text" name="changeAmount" size="5">
<input type="hidden" name="pId" value= <%= id %>>
<input type="hidden" name="pName" value= <%= name %>>
<input type="hidden" name="price" value= <%= price %>>
<input type="submit" value="Submit"><input type="reset" value="Reset">
</form>

</body>
</html>
