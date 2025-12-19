<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="forum.Message,java.util.Date,java.util.List"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="forum.ComparatorHotBest"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Document</title>
	<link rel="stylesheet" type="text/css" href="css/reset.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">	
	<script src="js/jquery-1.10.1.min.js"></script>
	<script type="text/javascript" src="js/vote.js" ></script>
        <style type="text/css">

        </style>
<body>
        <jsp:useBean id="now" class="java.util.Date" scope="page" />
        <%
            //4.时间格式化
                DecimalFormat df = new DecimalFormat("#0");
                List<Message> msgs = (List<Message>)request.getAttribute("list");
                if (msgs == null) {
                    // JSP 直接访问时没有预置 list，尝试查询一遍并防空
                    try {
                        dao.MessageDao dao = new dao.MessageDaoImpl();
                        msgs = dao.list();
                    } catch (Exception ignore) {}
                }
                if (msgs == null) {
                    msgs = new java.util.ArrayList<Message>();
                }
            int wishs = 0;
            int overs = 0;

	    int lows = 0;
	    int mids = 0;
	    int highs = 0;
	    int count = msgs.size();
	    for(Message msg:msgs){
	    	if(msg.getInterest().equals("wish")){
	    		wishs++;
	    	}else{
	    		overs++;
	    	}
	    	
	    	if(msg.getScore() <=2){
	    		lows++;
	    	}else if(msg.getScore() ==3){
	    		mids++;
	    	}else{
	    		highs++;
                }
            }

            request.setAttribute("wishs", wishs);
            request.setAttribute("overs", overs);
            if (count > 0) {
                request.setAttribute("highPercent", df.format(1.0f*highs/count*100));
                request.setAttribute("midPercent", df.format(1.0f*mids/count*100));
                request.setAttribute("lowPercent", df.format(1.0f*lows/count*100));
            } else {
                request.setAttribute("highPercent", "0");
                request.setAttribute("midPercent", "0");
                request.setAttribute("lowPercent", "0");
            }
	    
	    
	%>
	<div class="container">
		<div>
			<h1>我不是药神 短评</h1>
		</div>
		<div class="Comments-hd clearfix">
                        <ul class="commentTabs fl">
                                <li class="active">看过(<c:out value="${overs}" />)</li>
                                <li><a href="#">想看(<c:out value="${wishs}" />)</a></li>
                        </ul>
			<div class="fr">
                                <a class="comment_btn " href="add.jsp">我来写短评</a>
			</div>
			<div class="title_line"></div>
		</div>
		<div class="comments-sortby">
			<span>热门</span>
			<a href="#">最新</a>
			<a href="#">好友</a>
			<div class="title_line"></div>
		</div>
		
		<div class="comment-filter">
			<label for="">
				<input type="radio" name="sort" >
				<span class="filter-name">全部</span>
			</label>
			<label for="">
                                <input type="radio" name="sort" checked="checked">
                                <span class="filter-name">好评</span>
                                <span class="comment-percent"><c:out value="${highPercent}" />%</span>
                        </label>
                        <label for="">
                                <input type="radio" name="sort" >
                                <span class="filter-name">一般</span>
                                <span class="comment-percent"><c:out value="${midPercent}" />%</span>
                        </label>
                        <label for="">
                                <input type="radio" name="sort" >
                                <span calss="filter-name">差评</span>
                                <span class="comment-percent"><c:out value="${lowPercent}" />%</span>
                        </label>
                        <div class="title_line"></div>
                </div>
                <div class="mod-bd ">
                    <c:forEach items="${list}" var="m">
                    <div class="comment-item">
                                <div class="avatar fl">
                                        <a title="用户名"><img src="image/headshot.jpg"></a>
                                </div>
                                <div class="comment">
                                        <span class="comment-info">
                                                <a href="#"><c:out value="徐若风" /></a>   <!-- m.getUser() -->
                                                <c:choose>
                                                        <c:when test="${m.interest eq 'over'}">
                                                                <span>看过</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                                <span>想看</span>
                                                        </c:otherwise>
                                                </c:choose>
                                                <img src="image/star${m.score}.png">
                                                <span class="comment-time"> <fmt:formatDate value="${m.date}" pattern="yyyy-MM-dd" /></span>
                                        </span>
                                        <span class="comment-vote fr">
                                                <span class="vote_counts"><c:out value="${m.vote_count}" /></span>
                                                <input type="button" class="vote" value="有用">
                                                <span style="display:none"><c:out value="${m.id}" /></span>
                                        </span>
                                        <p>
                                                <span class="short">
                                                        <c:out value="${m.comment}" />
                                                </span>
                                        </p>
                                </div>
                                <div class="title_line"></div>
                        </div>
                    </c:forEach>
                    <c:set var="htmlTestComment" value="<script>alert('xss')</script> <b>Bold Text</b>" />
                    <div class="comment-item">
                                <div class="avatar fl">
                                        <a title="测试用户"><img src="image/headshot.jpg"></a>
                                </div>
                                <div class="comment">
                                        <span class="comment-info">
                                                <a href="#">测试用户</a>
                                                <span>看过</span>
                                                <img src="image/star5.png">
                                                <span class="comment-time"> <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></span>
                                        </span>
                                        <span class="comment-vote fr">
                                                <span class="vote_counts">0</span>
                                                <input type="button" class="vote" value="有用">
                                                <span style="display:none">test</span>
                                        </span>
                                        <p>
                                                <span class="short">
                                                        <c:out value="${htmlTestComment}" />
                                                </span>
                                        </p>
                                </div>
                                <div class="title_line"></div>
                        </div>
                </div>

		

	</div>
</body>
</html>
