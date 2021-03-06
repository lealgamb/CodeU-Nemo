<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.UUID" %>
<%@ page import="codeu.model.data.Message" %>
<%@ page import="codeu.model.data.User" %>
<%@ page import="codeu.model.data.Conversation" %>
<%@ page import="codeu.model.store.basic.ConversationStore" %>
<%
List<Message> messages = (List<Message>) request.getAttribute("messages");
String subject = (String) request.getAttribute("subject");
String user = (String) request.getSession().getAttribute("user");
String aboutMe = (String) request.getAttribute("aboutMe");
ConversationStore conversationStore = ConversationStore.getInstance();
User subjectUser = UserStore.getInstance().getUser(subject);
%>

<!DOCTYPE html>
<html>
<head>
  <title><%= subject %></title>
  <%@ include file="navbar.jsp" %>
  <link rel="stylesheet" href="/css/main.css">

  <script>
    // scroll the messages div to the bottom
    function scrollChat() {
      var chatDiv = document.getElementById('messages');
      chatDiv.scrollTop = chatDiv.scrollHeight;
    };

    function readImage() {

      if (this.files && this.files[0]) {

        var FR = new FileReader();

        FR.addEventListener("load", function(e) {

          fetch('/profile/<%= subject %>', {
            method: "PUT",
            credentials: "same-origin",
            body : e.target.result
          }).then(function(response) {
            if(response.status !== 200) {
              console.log("An error occured. Status code: " + response.status);
              return;
            }

            document.getElementById("profilePicture").src = e.target.result;
          }, function(error) {
            console.log("An error occured. " + error.message);
          })

        });

        FR.readAsDataURL( this.files[0] );
      }

    };

    $(document).ready(function(){
      if("<%=user %>" === "<%= subject %>"){
        document.getElementById("profilePictureInput").addEventListener("change", readImage);
      }
    });

  </script>
</head>
<body onload="scrollChat()">

  <div id="profileContainer">

    <div class="flex" id="picturePlusName">

      <div class="flex" id="nameAndUpload">

        <h1 id="name"> <strong> <%= subject %> </strong> </h1>

        <%
        if (user.equals(subject)) {
        %>
            <input id="profilePictureInput" type='file'>
        <%
          }
        %>
      </div>

      <%
        String picture = subjectUser.getPicture();
        if (picture != null){
      %>
          <img id="profilePicture" src="<%=picture%>">
      <%
        } else {
      %>
          <img id="profilePicture" src="/default-user.png">
      <%
        }
      %>

    </div>

    <hr/>

    <div id="aboutSection">
      <h2> About <%= subject %> </h2>

      <% if (user.equals(subject)) { %>
        <p> Edit your About Me </p>
        <form action="/profile/<%= subject %>" method="POST">
          <input type="text" name="aboutMe">
          <br/>
          <button id="aboutMe" type="submit">Submit</button>
        </form>
      <% } %>

      <br>

      <% if (!aboutMe.equals("")) { %>
        <p> <%= aboutMe %> </p>
      <% } else { %>
        <p> <%= subject %> has not provided any information.</p>
      <% } %>

    </div>

    <hr/>

    <h2> <%= subject %>'s sent messages <a href="" style="float: right">&#8635;</a></h2>

    <div id="messages">


      <ul class="list-group">
        <%
        for (Message message : messages) {
          Conversation conversation =
              conversationStore.getConversation(message.getConversationId());
          boolean isPrivate = conversation.isPrivate();
          boolean userInConversation = conversation.containsMember(user);
          if (!isPrivate && userInConversation) {
        %>
            <li class="list-group-item">
              <strong> <%= Date.from(message.getCreationTime()) %>: </strong>
              In <a href="/chat/<%= conversation.getId() %>"><%= conversation.getTitle() %></a>:
              <%= message.getContent() %>
            </li>
        <%
          }
        } %>
      </ul>
      <hr>
    </div>
    <h2> <%= subject %>'s subscriptions </h2>
    <%--Ids of subscribed to chats--%>
    <% List<UUID> conversationsIds = (List<UUID>) request.getAttribute("subscriptionIds"); %>
    <%--Names of the conversations stored on the id List--%>
    <% List<String> conversationNames = (List<String>) request.getAttribute("conversationNames"); %>

    <% for(int i = 0; i < conversationNames.size(); i++) { %>
          <a href="/chat/<%=conversationsIds.get(i)%>"> <%=conversationNames.get(i)%> </a> <br/>
    <% } %>
    <hr/>
  </div>

</body>
</html>
