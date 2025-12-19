<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="forum.Message,java.util.Date,java.util.List"%>
<%@ page import="java.text.DecimalFormat,java.text.SimpleDateFormat"%>
<%@ page import="forum.ComparatorHotBest"%>  
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
	<% 
	    //4.时间格式化
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		DecimalFormat df = new DecimalFormat("#0");
		List<Message> msgs = (List<Message>)request.getAttribute("list");
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
	    
	    
	%>
	<div class="container">
		<div>
			<h1>我不是药神 短评</h1>
		</div>
		<div class="Comments-hd clearfix">
			<ul class="commentTabs fl">
				<li class="active">看过(<%=overs %>)</li>
				<li><a href="#">想看(<%=wishs %>)</a></li>
			</ul>
			<div class="fr">
				<a class="comment_btn " href="add.html">我来写短评</a>
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
				<span class="comment-percent"><%= df.format(1.0f*highs/count*100)%>%</span>
			</label>
			<label for="">
				<input type="radio" name="sort" >
				<span class="filter-name">一般</span>
				<span class="comment-percent"><%= df.format(1.0f*mids/count*100)%>%</span>
			</label>
			<label for="">
				<input type="radio" name="sort" >
				<span calss="filter-name">差评</span>
				<span class="comment-percent"><%= df.format(1.0f*lows/count*100)%>%</span>
			</label>
			<div class="title_line"></div>
		</div>
		<div class="mod-bd ">
		    <% 
		        for(Message m:msgs){
		    %>
		    <div class="comment-item">
				<div class="avatar fl">
					<a title="用户名"><img src="image/headshot.jpg"></a>
				</div>
				<div class="comment">
					<span class="comment-info">
						<a href="#"><%="徐若风" %></a>   <!-- m.getUser() -->
						<%
							if(m.getInterest().equals("over")){
						%>
						<span>看过</span>
						<%}else{
						%>
						<span>想看</span>
						<%} %>
						<img src="image/star<%=m.getScore() %>.png">
						<span class="comment-time"> <%=sdf.format(m.getDate()) %></span>
					</span>
					<span class="comment-vote fr">
						<span class="vote_counts"><%=m.getVote_count() %></span>
						<input type="button" class="vote" value="有用">
						<span style="display:none"><%=m.getId() %></span>
					</span>
					<p>
						<span class="short">
							<%=m.getComment() %>
						</span>
					</p>
				</div>
				<div class="title_line"></div>
			</div>
		    <% 
		        }
		    %>
		</div>

		

	</div>
</body>
</html>
