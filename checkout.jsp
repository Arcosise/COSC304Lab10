<!DOCTYPE html>
<html>
<head>
    <title>CheckOut</title>
    <style>
        body {
            background-color: pink;
        }
        .custom-button {
            padding: 12px 24px;
            background-color: #0a73e3; 
            color: #080808;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 10px;
        }
        .text-input {
            padding: 8px 15px;
            margin: 8px 0;
            border-radius: 4px;
            border: 1px solid #ccc;
        }
    </style>
    <link rel="shortcut icon" href="img/Vigor.jpg" type="image/jpeg">
    <link rel="icon" href="img/Vigor.jpg" type="image/jpeg">
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

<div align="center">

    <h1>Enter your customer id and password to complete the transaction:</h1>

    <form method="get" action="order.jsp">
        <input type="text" name="customerId" size="50" class="text-input" placeholder="Customer Id">
        <input type="text" name="password" size="30" class="text-input" placeholder="Password"><br>
        <button type="submit" class="custom-button">Submit</button>
        <button type="reset" class="custom-button">Reset</button>
    </form>
</div>

</body>
</html>
