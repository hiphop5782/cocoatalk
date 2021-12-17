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
		padding:1em;
		
		transition:left 0.3s ease-in-out;
	}
	.chat-wrapper > .message-wrapper {}
	.chat-wrapper > .control-panel{
		position:absolute;
		bottom:0;
		left:0;
		right:0;
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
					<div class="user-detail" v-on:click="joinChannel(user);">
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
				<div class="first-panel">
					<div class="input-panel">
						<textarea name="message" placeholder="메세지 작성" v-model="inputMessage"></textarea>
					</div>
					<div class="button-panel">
						<button v-on:click="sendMessage">전송</button>
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
	
		function Channel(name){
			this.name = name;
			this.history = [];
		}
	
		var app = Vue.createApp({
			data(){
				return {
					users:[
						{userId:"test1", userProfile:"https://picsum.photos/seed/1/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"}, 
						{userId:"test2", userProfile:"https://picsum.photos/seed/2/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test3", userProfile:"https://picsum.photos/seed/3/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test4", userProfile:"https://picsum.photos/seed/4/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test5", userProfile:"https://picsum.photos/seed/5/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test6", userProfile:"https://picsum.photos/seed/6/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test7", userProfile:"https://picsum.photos/seed/7/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test8", userProfile:"https://picsum.photos/seed/8/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test9", userProfile:"https://picsum.photos/seed/9/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test10", userProfile:"https://picsum.photos/seed/10/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test11", userProfile:"https://picsum.photos/seed/11/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test12", userProfile:"https://picsum.photos/seed/12/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test13", userProfile:"https://picsum.photos/seed/13/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test14", userProfile:"https://picsum.photos/seed/14/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test15", userProfile:"https://picsum.photos/seed/15/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test16", userProfile:"https://picsum.photos/seed/16/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test17", userProfile:"https://picsum.photos/seed/17/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test18", userProfile:"https://picsum.photos/seed/18/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test19", userProfile:"https://picsum.photos/seed/19/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
						{userId:"test20", userProfile:"https://picsum.photos/seed/20/100/100", userStatus:"치키치키차카차카초코초코초치키치카차카차카초코초코초"},
					],
					currentChannel:null,
					channels:[
// 						{name:"/topic/1", history:[]},
// 						{name:"/topic/2", history:[]},
// 						{name:"/topic/3", history:[]},
// 						{name:"/topic/4", history:[]},
// 						{name:"/topic/5", history:[]},
// 						{name:"/topic/6", history:[]},
					],
					
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
				}
			},
			methods:{
				connectOperation(){
					this.client.subscribe("/topic/all", this.receiveOperation);
					this.channels.forEach((channel)=>{
						this.client.subscribe(channel.name, this.receiveOperation);
					});
				},
				receiveOperation(response){
					console.log("---> response", response);
					var find = this.channels.filter(channel=>{
						return channel.name == response.headers.destination;
					});
					if(find.length > 0){
						find[0].history.push(response);	
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
						this.client.send("/app/chat/1", {}, this.inputMessage);
						this.inputMessage = "";
					}
				},
				joinChannel(user){
					var find = this.channels.filter(ch =>{
						return ch.name == "/topic/"+user.userId
					});
					if(find.length == 0){
						let channel = new Channel(user.userId);
						this.channels.push(channel);
						this.currentChannel = channel;
					}
					else{
						console.log("exist");
						this.currentChannel = find[0];
					}
				},
				leaveChannel(name){
					this.channels.removeIf((channel, idx)=>{
						return channel.name === name;
					});
				},
				test(){
					alert("test");
				}
			},
			created(){
				console.log("created");
				this.socket = new SockJS("${pageContext.request.contextPath}/endpoint");
				this.client = Stomp.over(this.socket);
				
				this.client.connect({}, this.connectOperation);
			},
		});
		app.mount("#app");
	</script>
</body>
</html>
