<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CocoaTalk</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/commons.css">
<style>
	html {
		width:100%;
		height:100%;
		font-size:15px;
	}
	body {
		display:flex;
		justify-content: center;
		align-items:center;
		width:100%;
		height:100%;
	}
	.warning {
		position: fixed;
		top:1rem;
		left:50%;
		transform:translateX(-50%);
		white-space: nowrap;
		color: #cccccc;
	}
	.container { 
		width:300px;
	}
	.container > .logo-wrapper {
		text-align:center;
		font-size: 2.5em;
		color:#cccccc; 
		font-weight: bolder; 
		padding:0.5em;
		margin-bottom: 0.5em;
	}
	.container > .input-wrapper {
		margin:0.5em 0;
	}
	.container > .input-wrapper > input,
	.container > .input-wrapper > button {
		display:block;
		width:100%;
		font:inherit;
		font-size:13px;
		padding:0.75em;
		border:1px solid gray;
		outline:none;
	}
	.container > .input-wrapper > button{
		color:gray;
	}
	.container > .input-wrapper > label,
	.container > .help-wrapper{
		color:#cccccc;
	}
	.container > .help-wrapper {
		position:fixed;
		bottom:10%;
		left:50%;
		transform:translateX(-50%);
		text-align: center;
	}
	
	.container > .help-wrapper > a {
		color:inherit;
		text-decoration: none;
	}
</style>
</head>
<body>
	<div class="warning">
		이 사이트는 Spring websocket의 이해를 돕기 위한 수업 자료로 사용되며 다른 용도로 사용되지 않습니다.
	</div>
	<div class="container">
		<div class="logo-wrapper">
			COCOA-TALK
		</div>
		<div class="input-wrapper">
			<input type="text" name="userId" placeholder="아이디(이메일)">
			<input type="password" name="userPw" placeholder="비밀번호">
		</div>
		<div class="input-wrapper">
			<button type="submit">로그인</button>
		</div>
		<div class="input-wrapper">
			<label>
				<input type="checkbox" name="autoLogin">
				자동로그인
			</label>
		</div>
		<div class="help-wrapper">
			<a href="#">코코아계정 만들기</a> 
			| 
			<a href="#">코코아계정 찾기</a>
		</div>
	</div>
</body>
</html>