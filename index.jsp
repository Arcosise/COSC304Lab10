<!DOCTYPE html>
<html>
<head>
    <title>Vigor Multivitamin</title>
    <style>
        body {
            background-color: pink;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .custom-button {
            padding: 12px 24px;
            background-color: #0a73e3;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin: 10px;
            width: 200px;
        }
        .custom-button:hover {
            background-color: #0056b3;
        }
        .logo-container {
            margin-bottom: 20px; 
        }
        .button-container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
    </style>
    <link rel="shortcut icon" href="img/Vigor.jpg" type="image/jpeg">
    <link rel="icon" href="img/Vigor.jpg" type="image/jpeg">
</head>
<body>

<div class="logo-container">
    <img src="img/Vigor.jpg" alt="Vigor Renewed Logo" height="300" width="300">
</div>

<div class="button-container">
    <button type="button" class="custom-button" onclick="loadContent('login.jsp')">Login</button>
    <button type="button" class="custom-button" onclick="loadContent('listorder.jsp')">List All Orders</button>
    <button type="button" class="custom-button" onclick="loadContent('customer.jsp')">Customer Info</button>
</div>

<form action="listprod.jsp" method="get">
    <button type="submit" class="custom-button">Begin Shopping</button>
</form>
<form action="admin.jsp" method="get">
    <button type="submit" class="custom-button">Administrators</button>
</form>
<form action="logout.jsp" method="get">
    <button type="submit" class="custom-button">Log out</button>
</form>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<div id="dynamicContent">
</div>
<script>
    function loadContent(url) {
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                document.getElementById("dynamicContent").innerHTML = this.responseText;
            }
        };
        xhr.open("GET", url, true);
        xhr.send();
    }
</script>

</body>
</html>
