package controller;

import java.io.IOException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
                request.setCharacterEncoding("UTF-8");
                resp.setCharacterEncoding("UTF-8");
                resp.setContentType("text/html;charset=UTF-8");
                String path = request.getServletPath();
                if("/add.do".equals(path)) {
                        String user = "张三";  //已登录用户

                        String interest = request.getParameter("interest");
                        String scoreParam = request.getParameter("score");
                        String comment = request.getParameter("comment");

                        Map<String, String> errors = new HashMap<>();

                        if(interest == null || interest.trim().isEmpty()) {
                                errors.put("interest", "请选择看过或想看状态");
                        }

                        int score = 0;
                        if(scoreParam == null || scoreParam.trim().isEmpty()) {
                                errors.put("score", "请提供评分");
                        } else {
                                try {
                                        score = Integer.parseInt(scoreParam);
                                } catch (NumberFormatException e) {
                                        errors.put("score", "评分格式不正确");
                                }
                        }

                        if(comment == null || comment.trim().isEmpty()) {
                                errors.put("comment", "评论不能为空");
                        }

                        if(!errors.isEmpty()) {
                                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                                request.setAttribute("errors", errors);
                                request.setAttribute("interest", interest);
                                request.setAttribute("score", scoreParam);
                                request.setAttribute("comment", comment);
                                request.getRequestDispatcher("add.jsp").forward(request, resp);
                                return;
                        }

                        Message msg = new Message(user,score,interest,comment,new Date(),1);
                        //插入到表comment中
                        MessageDao dao = new MessageDaoImpl();
                        int result = dao.saveMessage(msg);

                        List<Message> list = dao.list();
                        request.setAttribute("list", list);

                        request.getRequestDispatcher("list.jsp").forward(request, resp);
                        return;
                }

                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

}
