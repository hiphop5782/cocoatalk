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
		transition:width 0.3s ease-in-out;
	}
	.side-bar > .user-list {
		width:290px;
		padding:0.2em;
		overflow: auto;
		transition:width 0.3s ease-in-out;
	}
	.side-bar > .user-list > .user {
		padding:8px 4px;
		display: flex;
		flex-wrap: nowrap;
		overflow: hidden;
		align-items: center;
		cursor:pointer;
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
		
		transition:margin-left 0.3s ease-in-out;
	}
	.side-bar > .user-list > .user > .user-profile > img {
		width:100%;
		height:100%;
	}
	.side-bar > .user-list > .user > .user-detail {
		width:240px;
		padding:8px;
		padding-left: 16px;
		transition:width 0.3s ease-in-out;
	}
	.side-bar > .user-list > .user > .user-detail > .user-name,
	.side-bar > .user-list > .user > .user-detail > .user-status {
		width:100%;
		overflow:hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		transition:transform 0.3s ease-in-out;
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
		display:flex;
		flex-direction:column;
		flex-wrap:nowrap;
		
		transition:left 0.3s ease-in-out;
	}
	.chat-wrapper > .room-information {
		background:white;
		font-size:18px;
		padding:0.5em;
		height:65px;
	}
	.chat-wrapper > .room-information > .title{
		overflow:hidden;
		text-overflow:ellipsis;
		white-space: nowrap;
	}
	.chat-wrapper > .room-information > .status{
		font-size:12px;
		color:#666;
		overflow:hidden;
		text-overflow:ellipsis;
		white-space: nowrap;
	}
	.chat-wrapper > .message-wrapper {
		flex-grow: 1;
		flex-shrink: 1;
		padding:15px;
		overflow: auto;
	}
	.chat-wrapper > .control-panel{
		height:200px;
		background: white;
	}
	.chat-wrapper > .control-panel > .first-panel{
		display: flex;
		height:150px;
	}
	.chat-wrapper > .control-panel > .first-panel > .input-panel {
		flex-grow: 1;
	}
	.chat-wrapper > .control-panel > .first-panel > .input-panel > textarea {
		resize:none;
		outline: none;
		padding:0.75em;
		width:100%;
		height:100%;
		font: inherit;
		border: none;
	}
	.chat-wrapper > .control-panel > .first-panel > .button-panel {
		width:100px;
		padding:15px;
	}
	.chat-wrapper > .control-panel > .first-panel > .button-panel > button {
		outline:none;
		padding:0.5em;
		font: inherit;
		background-color: #59473f;
		color:white;
		border:none;
		border-radius:15%;
		white-space: nowrap;
	}
	.chat-wrapper > .control-panel > .option-panel {
		width:100%;
		height:50px;
		padding:0.25em;
	}
	
	@media screen and (max-width:640px){
		.side-bar > .user-list {
			width:150px;
		}
		
		.side-bar > .user-list > .user > .user-detail {
			width:100px;
		}
		.chat-wrapper {
			left:210px; 
		}
	}
	
	@media screen and (max-width:550px){
		.side-bar > .icon-bar{
			width:40px;
		}
		.side-bar > .user-list {
			width:100px;
		}
		.side-bar > .user-list > .user > .user-profile {
			margin-left:-50px;
		}
		.side-bar > .user-list > .user > .user-detail {
			width:100px;
		}
		.side-bar > .user-list > .user > .user-detail > .user-status {
			transform:translateX(-100%);
		}
		.chat-wrapper {
			left:140px; 
		}
	}
	
	@media screen and (max-width:400px){
		.side-bar > .user-list {
			width:0px;
		}
		.chat-wrapper {
			left:40px; 
		}
	}
	
	/* scrollbar design */
	::-webkit-scrollbar {
		width:3px;
	}
	/* Track */
	::-webkit-scrollbar-track {
	  	background: #f1f1f1; 
	}
	 
	/* Handle */
	::-webkit-scrollbar-thumb {
	  	background: #888; 
	}
	
	/* Handle on hover */
	::-webkit-scrollbar-thumb:hover {
	  	background: #555; 
	}
	
	.icon {
		stroke:#aaaaaa;
		cursor:pointer;
	}
	.icon:hover {
		stroke:#333333;
	}
	.message-outer{
		padding:5px;
		display: flex;
	}
	.message-outer.my {
		flex-direction: row-reverse;
	}
	.message-outer > .message-profile {
		flex-shrink:0;
		width:50px;
		height:50px;
		padding:5px;
	}
	.message-outer > .message-profile:not(.first){
		height:auto;
	}
	.message-outer > .message-profile > img {
		width:100%;
		height:100%;
		border-radius:35%;
	}
	.message-outer > .message-body {
		flex-grow:1;
		display: flex;
		flex-direction: row;
		flex-wrap: wrap;
	}
	.message-outer.my > .message-body {
		display: flex;
		flex-direction: row-reverse;
		flex-wrap: wrap;
	}
	.message-outer > .message-body > .sender {
		width:100%;
		color:#EEE;
		font-size: 15px;
		padding:7px 0px;
	}
	.message-outer:not(.my) > .message-body > .sender {
		text-align: left;
	}
	.message-outer.my > .message-body > .sender {
		text-align: right;
	}
	.message-outer > .message-body > .content {
		font-size:12px;
		padding:0.35em 0.75em;
		background:#EEE;
		border-radius: 5px;
		white-space: pre-wrap;
		word-break:break-all;
		max-width: 70%;
	}
	.message-outer:not(.my) > .message-body > .content{
		margin-right: 5px;
	}
	.message-outer.my > .message-body > .content{
		margin-left: 5px;
	}
	.message-outer > .message-body > .time {
		font-size: 10px;
		color:#EEE;
		word-spacing: 1px;
		display: flex;
		align-items: flex-end;
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
						<img v-bind:src="user.profile">
					</div>
<!-- 					<div class="user-detail" v-on:click="joinChannel(user);"> -->
					<div class="user-detail" v-on:click="selectUser(user);">
						<div class="user-name">{{user.id}}</div>
						<div class="user-status">{{user.status}}</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- chat-wrapper -->
		<div class="chat-wrapper">
			<div class="room-information">
				<div class="title" v-if="currentUser">{{currentUser.id}}</div>  
				<div class="status" v-if="currentUser">{{currentUser.status}}</div>
			</div>
			<div class="message-wrapper" ref="messageWrapper">
				<div v-if="currentUser" v-for="(msg, idx) in currentUser.history" >
					<div  class="message-outer" v-bind:class="{my:msg.sender==owner}"> 
						<div class="message-profile" v-if="msg.sender != owner" :class="{first : checkFirst(idx)}">
							<img src="https://picsum.photos/50" v-if="checkFirst(idx)">
						</div>
						<div class="message-body" >
							<div class="sender" v-if="msg.sender != owner && checkFirst(idx)">{{msg.sender}}</div>
							<div class="content">{{msg.content}}</div>
							<div class="time" v-if="checkLast(idx)">{{msg.time}}</div>
						</div>
					</div>
				</div>
			</div>
			<div class="control-panel">
				<div class="first-panel">
					<div class="input-panel">
						<textarea name="message" ref="messageInput" v-bind:placeholder="textareaPlaceholder" v-model="inputMessage" v-bind:disabled="!currentUser"></textarea>
					</div>
					<div class="button-panel">
						<button v-on:click="sendMessage" v-bind:disabled="!currentUser">전송</button>
					</div>
				</div>
				<div class="option-panel">
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-mood-smile" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#2c3e50" fill="none" stroke-linecap="round" stroke-linejoin="round">
					  	<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
					  	<circle cx="12" cy="12" r="9" />
					  	<line x1="9" y1="10" x2="9.01" y2="10" />
					  	<line x1="15" y1="10" x2="15.01" y2="10" />
					  	<path d="M9.5 15a3.5 3.5 0 0 0 5 0" />
					</svg>
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-paperclip" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#2c3e50" fill="none" stroke-linecap="round" stroke-linejoin="round">
					  	<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
					  	<path d="M15 7l-6.5 6.5a1.5 1.5 0 0 0 3 3l6.5 -6.5a3 3 0 0 0 -6 -6l-6.5 6.5a4.5 4.5 0 0 0 9 9l6.5 -6.5" />
					</svg>
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-checkbox" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#2c3e50" fill="none" stroke-linecap="round" stroke-linejoin="round">
					  	<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
					  	<polyline points="9 11 12 14 20 6" />
					  	<path d="M20 12v6a2 2 0 0 1 -2 2h-12a2 2 0 0 1 -2 -2v-12a2 2 0 0 1 2 -2h9" />
					</svg>
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-capture" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#2c3e50" fill="none" stroke-linecap="round" stroke-linejoin="round">
					  	<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
					  	<path d="M4 8v-2a2 2 0 0 1 2 -2h2" />
					  	<path d="M4 16v2a2 2 0 0 0 2 2h2" />
					  	<path d="M16 4h2a2 2 0 0 1 2 2v2" />
					  	<path d="M16 20h2a2 2 0 0 0 2 -2v-2" />
					  	<circle cx="12" cy="12" r="3" />
					</svg>
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
					owner : "${id}",
					
					users:[],
					currentUser:null,
					
					//websocket
					socket:null,
					client:null,
					
					//input
					inputMessage:"",
				};
			},
			computed:{
				canSend(){
					return this.inputMessage.trim().length > 0;
				},
				textareaPlaceholder(){
					return this.currentUser ? "메세지 작성" : "사용자를 먼저 선택하세요";
				},
			},
			methods:{
				connectOperation(){
					this.client.subscribe("/topic/all", this.publicReceiveOperation);
					this.client.subscribe("/topic/${id}", this.privateReceiveOperation);
				},
				publicReceiveOperation(response){
					let userList = JSON.parse(response.body);
					userList.forEach((user, index)=>{
						if(this.users.length > 0){
							const find = this.users.find(u=>u.id == user.id);
							if(find && find.length > 0){
								user.history = find[0].history;
							}
						}
						
						if(!user.history){
							user.history = [];
						}
					});
					this.users = userList;
				},
				privateReceiveOperation(response){
					let roomData = JSON.parse(response.body);
					
					const message = roomData.message;
					delete roomData.message;
					
// 					console.log(roomData);
// 					console.log(message);
					for(let i=0; i < this.users.length; i++){
						if(this.users[i].id == roomData.target){
							this.users[i].roomData = roomData;
							this.users[i].history.push(message);
							break;
						}
					}
					this.client.subscribe("/topic/"+roomData.roomNo, this.receiveOperation);
				},
				receiveOperation(response){
					console.log("receive--------------------------");
					console.log(response);
					console.log("----------------------------------");
					for(let i=0; i < this.users.length; i++){
						console.log(this.users[i].roomData, response.headers.destination);
						if(this.users[i].roomData && "/topic/"+this.users[i].roomData.roomNo == response.headers.destination){
							this.users[i].history.push(JSON.parse(response.body));
							setTimeout(()=>{
								this.$refs.messageWrapper.scrollTop = this.$refs.messageWrapper.scrollHeight + 100;
							}, 10);
						}
					}
				},
				disconnectOperation(){
					this.client.disconnect(()=>{
						this.socket = null;
					})
					this.client = null;
				},
				sendMessage(){
					if(this.canSend){
						this.client.send("/app/chat/${id}/"+this.currentUser.id, {}, this.inputMessage);
						this.inputMessage = "";
						this.$refs.messageInput.focus();
					}
				},
				selectUser(user){
					this.currentUser = user;
				},
				//첫번째 메세지 확인(동일시간)
				checkFirst(idx){
					if(idx == 0) return true;
					
					if(this.currentUser.history[idx-1].time != this.currentUser.history[idx].time) return true;
					
					if(this.currentUser.history[idx-1].sender != this.currentUser.history[idx].sender) return true;
					
					return false;
				},
				//마지막 메세지 확인(동일시간)
				checkLast(idx){
					if(idx == this.currentUser.history.length-1) return true;
					
					if(this.currentUser.history[idx+1].time != this.currentUser.history[idx].time) return true;
					
					if(this.currentUser.history[idx+1].sender != this.currentUser.history[idx].sender) return true;
					
					return false;
				},
			},
			created(){
				this.socket = new SockJS("${pageContext.request.contextPath}/endpoint");
				this.client = Stomp.over(this.socket);
				
				this.client.connect({}, this.connectOperation);
			},
		});
		app.mount("#app");
	</script>
</body>
</html>

