//Ask user input for an item amount and hold needed variables
<%

    String id = request.getParameter("id");
 %>


<!DOCTYPE html>
<html>
<head>
<title>Add Product</title>
</head>
<body>

<h1>Enter the following:</h1>
<table></table>
<tr><td>Name Price Amount per item Category ID</td></tr>
<form method="get" action="updateItem.jsp">
<input type="text" name="name" size="50">
<input type="text" name="price" size="10">
<input type="text" name="desc" size="50">
<input type="text" name="catId" size="5">
<input type="submit" value="Submit"><input type="reset" value="Reset">

</table>
<input type="hidden" name="pId" value= <%= id %>>
</form>

</body>
</html>