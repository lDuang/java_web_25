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
	<script type="text/javascript">
		$(function(){
			function matchFilter(score, val){
				if (val === "high") { return score >= 4; }
				if (val === "mid") { return score === 3; }
				if (val === "low") { return score <= 2; }
				return true;
			}
			var currentInterest = "over";
			var currentSort = "hot";
			var $container = $(".mod-bd");
			var $items = $(".comment-item[data-sortable='1']");

			function sortItems(list){
				return list.sort(function(a, b){
					var $a = $(a), $b = $(b);
					if (currentSort === "latest") {
						var da = parseInt($a.data("date"), 10) || 0;
						var db = parseInt($b.data("date"), 10) || 0;
						return db - da; // 时间最新在前
					}
					// 热门：优先 vote_count，其次 score
					var va = parseInt($a.data("vote"), 10) || 0;
					var vb = parseInt($b.data("vote"), 10) || 0;
					if (vb !== va) return vb - va;
					var sa = parseInt($a.data("score"), 10) || 0;
					var sb = parseInt($b.data("score"), 10) || 0;
					return sb - sa;
				});
			}

			function applyFilters(){
				var val = $("input[name='sort']:checked").val();
				var matched = [];
				$items.each(function(){
					var score = parseInt($(this).data("score"), 10);
					var interest = $(this).data("interest");
					var showScore = matchFilter(score, val);
					var showInterest = (currentInterest === "all") || (interest === currentInterest);
					if (showScore && showInterest) {
						$(this).show();
						matched.push(this);
					} else {
						$(this).hide();
					}
				});
				var sorted = sortItems(matched);
				// 将匹配项按照排序附加到容器顶部（保持示例评论留在末尾）
				for (var i = 0; i < sorted.length; i++) {
					$container.prepend(sorted[i]);
				}
			}
			$("input[name='sort']").change(function(){
				applyFilters();
			});
			$(".commentTabs li").click(function(){
				$(".commentTabs li").removeClass("active");
				$(this).addClass("active");
				currentInterest = $(this).data("filter-interest") || "all";
				applyFilters();
			});
			$(".sort-tab").click(function(e){
				e.preventDefault();
				$(".sort-tab").removeClass("active");
				$(this).addClass("active");
				var sort = $(this).data("sort");
				if (sort === "friend") {
					currentSort = "hot"; // 好友未实现，沿用热门
				} else {
					currentSort = sort || "hot";
				}
				applyFilters();
			});
			applyFilters();
		});
	</script>
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
                                <li class="active" data-filter-interest="over">看过(<c:out value="${overs}" />)</li>
                                <li data-filter-interest="wish"><a href="#">想看(<c:out value="${wishs}" />)</a></li>
                        </ul>
			<div class="fr">
                                <a class="comment_btn " href="add.jsp">我来写短评</a>
			</div>
			<div class="title_line"></div>
		</div>
		<div class="comments-sortby">
			<span class="sort-tab active" data-sort="hot">热门</span>
			<a href="#" class="sort-tab" data-sort="latest">最新</a>
			<a href="#" class="sort-tab" data-sort="friend">好友</a>
			<div class="title_line"></div>
		</div>
		
		<div class="comment-filter">
			<label for="">
				<input type="radio" name="sort" value="all" checked="checked">
				<span class="filter-name">全部</span>
			</label>
			<label for="">
                                <input type="radio" name="sort" value="high">
                                <span class="filter-name">好评</span>
                                <span class="comment-percent"><c:out value="${highPercent}" />%</span>
                        </label>
                        <label for="">
                                <input type="radio" name="sort" value="mid">
                                <span class="filter-name">一般</span>
                                <span class="comment-percent"><c:out value="${midPercent}" />%</span>
                        </label>
                        <label for="">
                                <input type="radio" name="sort" value="low">
                                <span calss="filter-name">差评</span>
                                <span class="comment-percent"><c:out value="${lowPercent}" />%</span>
                        </label>
                        <div class="title_line"></div>
                </div>
                <div class="mod-bd ">
                    <c:forEach items="${list}" var="m">
                    <div class="comment-item" data-sortable="1" data-score="${m.score}" data-interest="${m.interest}" data-vote="${m.vote_count}" data-date="${m.date.time}">
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
                                                <input type="button" class="vote" value="有用" data-id="${m.id}">
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
