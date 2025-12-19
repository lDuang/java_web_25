package controller;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dao.MessageDao;
import dao.MessageDaoImpl;
import forum.Message;

@WebServlet("*.do")
public class MessageServlet extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse resp) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String path = request.getServletPath();
		if(path.contains("add")) {
			String user = "张三";  //已登录用户
			request.setCharacterEncoding("UTF-8");
			
			String interest = request.getParameter("interest");
			int score = Integer.parseInt(request.getParameter("score"));
			String comment = request.getParameter("comment");
			
			Message msg = new Message(user,score,interest,comment,new Date(),1);
			//插入到表comment中
			MessageDao dao = new MessageDaoImpl();
			int result = dao.saveMessage(msg);
			
			List<Message> list = dao.list();
			request.setAttribute("list", list);
			
			request.getRequestDispatcher("list.jsp").forward(request, resp);
		}
	}

}
