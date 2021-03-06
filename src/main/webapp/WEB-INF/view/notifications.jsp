<%@ page import="codeu.model.data.User" %>
<%@ page import="codeu.model.store.basic.UserStore" %>
<%@ page import="codeu.model.data.Event" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%
  String username = (String) request.getSession().getAttribute("user");
  List<Event> notifications = (List<Event>) request.getAttribute("eventsToShow");
%>

<!DOCTYPE html>
<html>
<head>
  <title>Notification</title>
  <%@ include file="navbar.jsp" %>
  <link rel="stylesheet" href="/css/main.css">
</head>
<body>

  <div id="notifications">
      <p> Back from fishing? This is what you missed:</p>
      <ul>
    <% for (Event notification : notifications) { %>
      <%
        Date date = Date.from(notification.getCreationTime());
        List<String> notifcationInfo = notification.getInformation();
        String Username = notifcationInfo.get(0);
        String type = notification.getType();
      %>
      <%if(type.equals("Conversation")){%>
          <div class="alert alert-info alert-dismissible fade show" role="alert">
            <li> <strong> <%= Date.from(notification.getCreationTime()) %>: </strong>
            <strong><%= Username %></strong> opened a conversation!
            Conversation:   <a href="/chat/<%= notifcationInfo.get(2) %>"> <%= notifcationInfo.get(1)%> </a>
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
        </li>
      <% }else if(type.equals("Message")){ %>
            <div class="alert alert-primary alert-dismissible fade show" role="alert">
              <li> <strong> <%= Date.from(notification.getCreationTime()) %>: </strong>
              <strong><%= Username %></strong> sent a message!
              Check conversation:   <a href="/chat/<%=notifcationInfo.get(3)%>"><%= notifcationInfo.get(1)%></a>
              <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
          </li>
        <%}%>
      <%}%>
    </ul>
  </div>
</body>
</html>
