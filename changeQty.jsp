<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

if (productList == null)
{	// No products currently in list.  Create a list.
	productList = new HashMap<String, ArrayList<Object>>();
}

// change qty of product selected
// Get product information
String id = request.getParameter("pId");
String name = request.getParameter("pName");
String price = request.getParameter("price");
Integer changeAmt = Integer.parseInt(request.getParameter("changeAmount"));
Integer quantity = new Integer(1);

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);
product.add(name);
product.add(price);
product.add(quantity);

// Update quantity if add same item to order again
if (productList.containsKey(id))
{	product = (ArrayList<Object>) productList.get(id);
	int curAmount = ((Integer) product.get(3)).intValue();
    if(changeAmt >=0 ){
        product.set(3, new Integer(changeAmt));
    } else {
        product.set(3, new Integer(0));
    }
	

    
    if(curAmount < 0){
        curAmount = 0;
    }
}
else
	productList.put(id,product);

session.setAttribute("productList", productList);
%>
<jsp:forward page="showcart.jsp" />