<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
        <meta charset="UTF-8">
        <title>Document</title>
        <link rel="stylesheet" type="text/css" href="css/reset.css">
        <link rel="stylesheet" type="text/css" href="css/add.css">
        <script src="js/jquery-1.10.1.min.js"></script>
        <script type="text/javascript" src="js/star.js" ></script>

<body>
        <c:set var="interestValue" value="${empty interest ? 'wish' : interest}" />
        <c:set var="scoreValue" value="${empty score ? '4' : score}" />
        <form method="post" action="add.do">
                <div class="container">
                        <div class="interest-form-hd">
                                <h2>添加收藏：写短评</h2>
                        </div>
                        <div class="interest-status">
                                <input type="radio" name="interest" value="wish" <c:if test="${interestValue eq 'wish'}">checked="checked"</c:if>>
                                <span>想看</span>
                                <input type="radio" name="interest" value="over" <c:if test="${interestValue eq 'over'}">checked="checked"</c:if>>
                                <span>看过</span>
                                <span>给个评价吧（可选）</span>
                                <div id="grade" class="fl">
                                        <ul>
                                        <li class="select" flag="star"></li>
                                        <li class="select" flag="star"></li>
                                        <li class="select" flag="star"></li>
                                        <li class="select" flag="star"></li>
                                        <li></li>
                                    </ul>
                                </div>
                                <input type="hidden" id="score" name="score" value="${scoreValue}"> <!-- 评分,默认4分-->
                                <c:if test="${not empty errors.interest}">
                                        <div class="error"><c:out value="${errors.interest}" /></div>
                                </c:if>
                                <c:if test="${not empty errors.score}">
                                        <div class="error"><c:out value="${errors.score}" /></div>
                                </c:if>
                        </div>
                        <div class="comment-area">
                                <span>简短评论：</span>
                                <textarea name="comment" class="comment" maxlength="350"><c:out value="${comment}" /></textarea>
                                <c:if test="${not empty errors.comment}">
                                        <div class="error"><c:out value="${errors.comment}" /></div>
                                </c:if>
                        </div>
                        <div class="interest-form-ft">
                                <span>分享到  豆瓣广播</span>
                                <input class="fr" type="submit" value="保存" >
                        </div>
                </div>
        </form>
</body>
</html>
