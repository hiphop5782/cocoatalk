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
		display:flex;
		flex-direction:column;
		align-items:center;
	
		width:60px;
		background:#CCCCCC;
		transition:width 0.3s ease-in-out;
	}
	.side-bar > .icon-bar > .icon-wrapper {
		position:relative;
		margin:10px 0px;
	}
	.side-bar > .icon-bar > .icon-wrapper > .badge,
	.side-bar > .room-list > .room > .room-detail > .badge {
		position:absolute;
		bottom:0;
		right:0;
		font-size: 4px;
		
		background-color: white;
		border-radius:50%;
		width:15px;
		height:15px;
		display: flex;
		justify-content: center;
		align-items:center;
		overflow: hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
	}
	.side-bar > .user-list,
	.side-bar > .room-list {
		width:290px;
		padding:0.2em;
		overflow: auto;
		transition:width 0.3s ease-in-out;
	}
	.side-bar > .user-list > .user,
	.side-bar > .room-list > .room {
		position:relative;
		padding:8px 4px;
		display: flex;
		flex-wrap: nowrap;
		overflow: hidden;
		align-items: center;
		cursor:pointer;
	}
	.side-bar > .user-list > .user:hover,
	.side-bar > .room-list > .room:hover {
		background-color: #EEEEEE;
	}
	.side-bar > .user-list > .user > .user-profile,
	.side-bar > .room-list > .room > .room-profile {
		border-radius:35%;
		width:35px;
		height:35px;
		overflow: hidden;
		flex-basis: 35px;
		flex-shrink: 0;
		
		transition:margin-left 0.3s ease-in-out;
	}
	.side-bar > .user-list > .user > .user-profile > img,
	.side-bar > .room-list > .room > .room-profile > img {
		width:100%;
		height:100%;
	}
	.side-bar > .user-list > .user > .user-detail,
	.side-bar > .room-list > .room > .room-detail {
		width:240px;
		padding:8px;
		padding-left: 16px;
		transition:width 0.3s ease-in-out;
	}
	.side-bar > .user-list > .user > .user-detail > .user-name,
	.side-bar > .user-list > .user > .user-detail > .user-status,
	.side-bar > .room-list > .room > .room-detail > .room-name,
	.side-bar > .room-list > .room > .room-detail > .room-preview {
		width:100%;
		overflow:hidden;
		white-space: nowrap;
		text-overflow: ellipsis;
		transition:transform 0.3s ease-in-out;
	}
	
	.side-bar > .user-list > .user > .user-detail > .user-status,
	.side-bar > .room-list > .room > .room-detail > .room-preview {
		font-size: 0.95em;
		color: #CCCCCC;
	}
	
	.side-bar > .room-list > .room > .room-detail > .badge {
		bottom:50%;
		transform:translate(-50%, 50%);
		background-color: #59473f;
		color:white;
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
		.side-bar > .user-list,
		.side-bar > .room-list {
			width:150px;
		}
		
		.side-bar > .user-list > .user > .user-detail,
		.side-bar > .room-list > .room > .room-detail {
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
		.side-bar > .user-list,
		.side-bar > .room-list {
			width:100px;
		}
		.side-bar > .user-list > .user > .user-profile,
		.side-bar > .room-list > .room > .room-profile {
			margin-left:-50px;
		}
		.side-bar > .user-list > .user > .user-detail,
		.side-bar > .room-list > .room > .room-detail{
			width:100px;
		}
		.side-bar > .user-list > .user > .user-detail > .user-status,
		.side-bar > .room-list > .room > .room-detail > .room-preview {
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
	.icon:hover,
	.icon.active {
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
			
				<!-- 사용자 목록 아이콘 -->
				<div class="icon-wrapper">
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-users" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round" @click="currentTab = 'user'" :class="{active : currentTab == 'user'}">
						  <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
						  <circle cx="9" cy="7" r="4" />
						  <path d="M3 21v-2a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v2" />
						  <path d="M16 3.13a4 4 0 0 1 0 7.75" />
						  <path d="M21 21v-2a4 4 0 0 0 -3 -3.85" />
					</svg>
				</div>
				
				<!-- 채팅방 아이콘 -->
				<div class="icon-wrapper">
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-message-circle" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round" @click="currentTab = 'room'" :class="{active : currentTab == 'room'}">
					  	<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
					  	<path d="M3 20l1.3 -3.9a9 8 0 1 1 3.4 2.9l-4.7 1" />
					  	<line x1="12" y1="12" x2="12" y2="12.01" />
					  	<line x1="8" y1="12" x2="8" y2="12.01" />
					  	<line x1="16" y1="12" x2="16" y2="12.01" />
					</svg>
					<div class="badge" v-show="remainCount > 0">{{remainCount}}</div>
				</div>
				
				
			</div>
			<div class="user-list" v-show="isUserMode">
				<div class="user" v-for="(user, idx) in users" :key="idx">
					<div class="user-profile">
						<img v-bind:src="user.profile">
					</div>
					<div class="user-detail" v-on:click="selectUser(user);">
						<div class="user-name">{{user.id}}</div>
						<div class="user-status">{{user.status}}</div>
					</div>
				</div>
			</div>
			
			<div class="room-list" v-show="isRoomMode">
				<div class="room" v-for="(room, idx) in rooms" :key="idx">
					<div class="room-profile">
						<img src="https://via.placeholder.com/50x50?text=R">
					</div>
					<div class="room-detail" v-on:click="selectRoom(room);">
						<div class="room-name">
							<span v-show="false">{{room.no}}번 방</span>
							{{convertToUserString(room.users)}}
						</div>
						<div class="room-preview">
							{{room.messages[room.messages.length-1].content}}
						</div>
						<div class="badge" v-show="room.count > 0">{{room.count}}</div>
					</div>
				</div>
			</div>
		</div>
		
		<!-- chat-wrapper -->
		<div class="chat-wrapper">
			<div class="room-information">
				<div class="title" v-if="isRoomSelected">
					<span v-show="false">{{currentRoom.no}}번 방</span>
					{{convertToUserString(currentRoom.users)}}
				</div>
				<div class="title" v-else-if="isUserSelected">{{currentUser.id}}</div>  
			</div>
			<div class="message-wrapper" ref="messageWrapper">
				<div v-if="currentRoom" v-for="(msg, idx) in currentRoom.messages" >
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
						<textarea name="message" ref="messageInput" v-bind:placeholder="textareaPlaceholder" v-model="inputMessage" v-bind:disabled="!isUserSelected"></textarea>
					</div>
					<div class="button-panel">
						<button v-on:click="sendMessage" v-bind:disabled="!isUserSelected">전송</button>
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
					
					currentTab : "user",//user 또는 room
					
					users:[],
					currentUser:null,
					
					rooms:[],
					currentRoom:null,
					
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
				isUserMode(){
					return this.currentTab == "user";
				},
				isRoomMode(){
					return this.currentTab == "room";
				},
				isUserSelected(){
					return this.currentUser != null;
				},
				isRoomSelected(){
					return this.currentRoom != null;
				},
				remainCount(){
					return this.rooms
									.filter(room=>room.count)
									.map(room=>room.count)
									.reduce((prev, next) => prev+next , 0);
				}
			},
			methods:{
				connectOperation(){
					this.client.subscribe("/topic/all", this.publicReceiveOperation);
					this.client.subscribe("/topic/${id}", this.privateReceiveOperation);
				},
				publicReceiveOperation(response){
					this.users = JSON.parse(response.body);
				},
				//신규 생성된 방과 관련된 메세지 수신
				privateReceiveOperation(response){
					const roomData = JSON.parse(response.body);
					
					let room = null;
					for(let i=0; i < this.rooms.length; i++){
						if(this.rooms[i].no == roomData.roomNumber) {
							room = this.rooms[i];
							break;
						}
					}
					
					if(!room){
						room = {
							no : roomData.roomNumber,
							users : roomData.roomUsers,
							messages : [roomData.message],
							count : roomData.message.sender == this.owner ? 0 : 1,
						};
						this.rooms.push(room);
						this.client.subscribe("/topic/"+roomData.roomNumber, this.receiveOperation);
						
						//발신자와 소유자가 같으면 생성메세지로 보고 방을 변경
						if(roomData.message.sender == this.owner){
							this.currentRoom = room;
						}
					}
				},
				receiveOperation(response){
					//메세지 헤더에서 방 번호 추출
					const destination = response.headers.destination;
					const idx = destination.lastIndexOf("/");
					const roomNumber = destination.substring(idx+1);
					
					//현재 방인지 아닌지 판정
					const isCurrentRoom = this.currentRoom && this.currentRoom.no == roomNumber;
					
					for(let i=0; i < this.rooms.length; i++){
						if(this.rooms[i].no == roomNumber) {
							const message = JSON.parse(response.body);
							if(isCurrentRoom) {
								this.rooms[i].count = 0;
							}
							else {
								this.rooms[i].count = this.rooms[i].count || 0;
								this.rooms[i].count++;
							}
							this.rooms[i].messages.push(message);
						}
					}
					
					//현재 방일 경우 추가 후 스크롤 갱신, 아닐 경우 배지 추가
					if(isCurrentRoom){
						setTimeout(()=>{
							this.$refs.messageWrapper.scrollTop = this.$refs.messageWrapper.scrollHeight + 100;
						}, 10);
					}
				},
				disconnectOperation(){
					this.client.disconnect(()=>{
						this.socket = null;
					})
					this.client = null;
				},
				sendMessage(){
					if(!this.canSend) return;
						
					if(this.isRoomSelected){
						this.client.send("/app/chat/room/"+this.currentRoom.no, {}, this.inputMessage);
						this.inputMessage = "";
						this.$refs.messageInput.focus();
					}
					else if(this.isUserSelected){
						this.client.send("/app/chat/id/"+this.currentUser.id, {}, this.inputMessage);
						this.inputMessage = "";
						this.$refs.messageInput.focus();
					}
					
				},
				
				selectUser(user){
					this.currentUser = user;

					//자기자신
					if(user.id == this.owner){
						console.log("자기자신 선택");
						for(let i=0; i < this.rooms.length; i++){
							if(this.rooms[i].users.length == 1) {
								this.selectRoom(this.rooms[i]);
								break;
							}
						}
						return;
					}
					
					//다른사람
					let index = -1;
					for(let i=0; i < this.rooms.length; i++){
						if(this.rooms[i].users.length != 2) continue;
						
						const a = this.rooms[i].users[0], b = this.rooms[i].users[1];
						if((this.owner == a.id && user.id == b.id) || (this.owner == b.id && user.id == a.id)){
							index = i;
							break;
						}
					}
					
					this.selectRoom(index == -1 ? null : this.rooms[index]);
				},
				
				selectRoom(room){
					this.currentRoom = room;
				},
				//첫번째 메세지 확인(동일시간)
				checkFirst(idx){
					if(idx == 0) return true;
					
					const messageList = this.currentRoom.messages;
					
					if(messageList[idx-1].time != messageList[idx].time) return true;
					if(messageList[idx-1].sender != messageList[idx].sender) return true;
					
					return false;
				},
				//마지막 메세지 확인(동일시간)
				checkLast(idx){
					const messageList = this.currentRoom.messages;
					
					if(idx == messageList.length-1) return true;
					if(messageList[idx+1].time != messageList[idx].time) return true;
					if(messageList[idx+1].sender != messageList[idx].sender) return true;
					
					return false;
				},
				convertToUserString(array){
					if(array.length == 1) return array[0].id;
					
					const id = this.owner;
					return array.filter(user=>user.id != id).map(user=> user.id).join(",");
				},
			},
			watch:{
				currentRoom : {
					deep:true,
					handler(room){
						if(room != null){
							room.count = 0;
						}
					}
				},
			},
			created(){
				this.socket = new SockJS("${pageContext.request.contextPath}/endpoint");
				this.client = Stomp.over(this.socket);
				
				this.client.connect({}, this.connectOperation);
			},
			mounted(){
				
			},
		});
		app.mount("#app");
	</script>
</body>
</html>

