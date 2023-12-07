
<%

String id = request.getParameter("id");
 %>


<!DOCTYPE html>
<html>
<head>
<title>Ray's Grocery CheckOut Line</title>
</head>
<body>


<form method="get" action="deleteProd.jsp">
<h1>Are you sure?</h1>
<input type="hidden" name="id" value= <%= id %>>
<input type="submit" value="Yes"><a href="listProdAdmin.jsp"><input type="button" value="No"></a>
</form>

</body>
</html>