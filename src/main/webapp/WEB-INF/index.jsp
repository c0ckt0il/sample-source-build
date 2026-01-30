<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Example</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            height: 100vh;
            display: flex;               /* flexbox 사용 */
            justify-content: center;     /* 가로 중앙 정렬 */
            align-items: center;         /* 세로 중앙 정렬 */
            text-align: center;
            background-image: url('<c:url value="/images/cloud-background.png" />');
            background-size: cover;
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-position: center;
        }

        .container {
            max-width: 600px;
            margin: auto;
            background-color: rgba(255, 255, 255, 0.85);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        img {
            max-width: 100%;
            margin-bottom: 20px;
        }

        h1, h4 {
            cursor: pointer;
            margin: 10px 0;
        }
    </style>
</head>
<body>
<div class="container">
    <!-- 이미지 -->
    <img src="<c:url value='/images/cocktail-log.jpg' />" alt="Daegu Logo" style="max-width: 500px; height: auto;"/>

    <h1 class="text_h1">글자를 클릭하면 빨간색으로 변경</h1>
    <h4 class="text_h2">글자를 클릭하면 파란색으로 변경</h4>


    <h3>배경색과 글자색 변경</h3>
    <input type="button" value="Black" onclick="
        alert('Daegu in Cloud');
        document.querySelector('body').style.backgroundColor='black';
        document.querySelector('body').style.color='orange';
    ">
    <input type="button" value="White" onclick="
        alert('Daegu with Cloud');
        document.querySelector('body').style.backgroundColor='white';
        document.querySelector('body').style.color='black';
    ">
</div>

<script>
    document.querySelector('.text_h1').onclick = function () {
        this.style.color = 'red';
    };
    document.querySelector('.text_h2').onclick = function () {
        this.style.color = 'blue';
    };
</script>
</body>
</html>
