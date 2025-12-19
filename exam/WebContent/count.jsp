<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="dao.MessageDao"%>
<%@ page import="dao.MessageDaoImpl"%>

<%
    request.setCharacterEncoding("UTF-8");
	int id = Integer.parseInt(request.getParameter("id"));
	MessageDao dao = new MessageDaoImpl();
	int count = dao.incrementVoteCount(id);
	out.print(count);
%>
