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
	}
	body {
		display:flex;
		width:100%;
		height:100%;
	}
	
	.side-bar {
		position:fixed;
		top:0;
		left:0;
		bottom:0;
		width:350px;
		background:white;
		display:flex;
	}
	.side-bar > .icon-bar{
		width:60px;
		background:#CCCCCC;
	}
	.side-bar > .user-list {
		width:290px;
		padding:0.2em;
		overflow: auto;
	}
	.side-bar > .user-list > .user {
		padding:8px 4px;
		display: flex;
		flex-wrap: nowrap;
		overflow: hidden;
		align-items: center;
	}
	.side-bar > .user-list > .user:hover {
		background-color: #EEEEEE;
	}
	.side-bar > .user-list > .user > .user-profile {
		border-radius:35%;
		width:35px;
		height:35px;
		overflow: hidden;
		flex-basis: 35px;
		flex-shrink: 0;
	}
	.side-bar > .user-list > .user > .user-profile > img {
		width:100%;
		height:100%;
	}
	.side-bar > .user-list > .user > .user-detail {
		width:240px;
		padding:8px;
		padding-left: 16px;
	}
	.side-bar > .user-list > .user > .user-detail > .user-name,
	.side-bar > .user-list > .user > .user-detail > .user-status {
		width:100%;
		overflow:hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
	}
	
	.side-bar > .user-list > .user > .user-detail > .user-status {
		font-size: 0.95em;
		color: #666666;
	}
	
	.chat-wrapper {
		position: fixed;
		top:0;
		left:350px;
		right:0;
		bottom:0;
		background-color: #59473f;
		
		font-size: 20px;
		padding:1em;
	}
	.chat-wrapper > .message-wrapper {}
	.chat-wrapper > .control-panel {
		display: flex;
		flex-wrap:wrap;
		
		position:absolute;
		bottom:0;
		left:0;
		right:0;
		height:150px;
		background: white;
	}
	.chat-wrapper > .control-panel > .input-panel {
		flex-grow: 1;
	}
	.chat-wrapper > .control-panel > .input-panel > textarea {
		resize:none;
		outline: none;
		padding:0.75em;
		width:100%;
		font: inherit;
		border: none;
	}
	.chat-wrapper > .control-panel > .button-panel {
		width:100px;
		padding:15px;
	}
	.chat-wrapper > .control-panel > .button-panel > button {
		outline:none;
		padding:0.5em;
		font: inherit;
		background-color: #59473f;
		color:white;
		border:none;
		border-radius:15%;
	}
	.chat-wrapper > .control-panel > .option-panel {
		width:100%;
		height:50px;
		padding:0.25em;
	}
</style>
</head>
<body>
	<div id="app">
		<!-- sidebar -->
		<div class="side-bar">
			<div class="icon-bar">
				
			</div>
			<div class="user-list">
				<div class="user" v-for="(user, idx) in users">
					<div class="user-profile">
						<img v-bind:src="user.userProfile">
					</div>
					<div class="user-detail">
						<div class="user-name">{{user.userId}}</div>
						<div class="user-status">{{user.userStatus}}</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- chat-wrapper -->
		<div class="chat-wrapper">
			<div class="message-wrapper">
			
			</div>
			<div class="control-panel">
				<div class="input-panel">
					<textarea name="message" placeholder="메세지 작성"></textarea>
				</div>
				<div class="button-panel">
					<button>전송</button>
				</div>
				<div class="option-panel">
					옵션 패널
				</div>
			</div>
		</div>
	</div>
	
	<script src="https://unpkg.com/vue@next"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.2/sockjs.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
	<script>
		var app = Vue.createApp({
			data(){
				return {
					users:[
						{userId:"test1", userProfile:"https://picsum.photos/seed/1/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"}, 
						{userId:"test2", userProfile:"https://picsum.photos/seed/2/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test3", userProfile:"https://picsum.photos/seed/3/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test4", userProfile:"https://picsum.photos/seed/4/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test5", userProfile:"https://picsum.photos/seed/5/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test6", userProfile:"https://picsum.photos/seed/6/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test7", userProfile:"https://picsum.photos/seed/7/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test8", userProfile:"https://picsum.photos/seed/8/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test9", userProfile:"https://picsum.photos/seed/9/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test10", userProfile:"https://picsum.photos/seed/10/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test11", userProfile:"https://picsum.photos/seed/11/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test12", userProfile:"https://picsum.photos/seed/12/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test13", userProfile:"https://picsum.photos/seed/13/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test14", userProfile:"https://picsum.photos/seed/14/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test15", userProfile:"https://picsum.photos/seed/15/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test16", userProfile:"https://picsum.photos/seed/16/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test17", userProfile:"https://picsum.photos/seed/17/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test18", userProfile:"https://picsum.photos/seed/18/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test19", userProfile:"https://picsum.photos/seed/19/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
						{userId:"test20", userProfile:"https://picsum.photos/seed/20/100/100", userStatus:"아예~ 음오아예~ 너에게빠져들겠어~"},
					],
				};
			},
			created(){
				this.socket = new SockJS("${pageContext.request.contextPath}/endpoint");
				this.client = Stomp.over(this.socket);
			},
		});
		app.mount("#app");
	</script>
</body>
</html>
