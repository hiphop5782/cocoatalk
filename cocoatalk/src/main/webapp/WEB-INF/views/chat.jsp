<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>CocoaTalk</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/commons.css">
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
	.side-bar > .room-list > .room > .room-profile {
		display: flex;
		flex-wrap: wrap;
	}
	.side-bar > .room-list > .room > .room-profile > .image-wrapper {
		width:50%;
		flex-grow: 1;
	}
	.side-bar > .room-list > .room > .room-profile > .image-wrapper > img {
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
	.chat-wrapper > .control-panel > .first-panel > .button-panel > button[disabled] {
		background-color: #59473f55;
		cursor: not-allowed;
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
	
	.profile-modal {
		position: fixed;
		top:50%;
		left:50%;
		transform:translate(-50%, -50%);
		width:350px;
		height: 550px;
		padding:15px;
		
		display:none;
		flex-direction: column;
		
		border:1px solid black;		
		background-color: white;
	}
	.profile-modal.show {
		display: flex;
	}
	
	.profile-modal > .profile-header {
		text-align: center;
		font-size:30px;
		margin:0.5em 0;
	}
	
	.profile-modal > .row {
		margin-top:5px;
		margin-bottom:5px;
	}
	.profile-modal > .row.label {
		margin-top:15px;
	}
	.profile-modal > .row.profile-wrapper {
		display:flex;
		flex-wrap:wrap;
	}
	.profile-modal > .row.profile-wrapper > .profile-image {
		width:20%;
		overflow:hidden;
		padding:5px;
		cursor:pointer;
	}
	.profile-modal > .row.profile-wrapper > .profile-image > img {
		width:100%;
		border:2px solid transparent;
	}
	
	.profile-modal > .row.profile-wrapper > .profile-image:hover > img,
	.profile-modal > .row.profile-wrapper > .profile-image > img.selected {
		border:2px solid #59473f;
	}
	.profile-modal > .row-empty {
		flex-grow: 1
	}
	.profile-modal > .profile-footer {
		text-align: right;
	}
	.profile-modal > .profile-footer > button {
		margin-left: 5px;
		outline: none;
		border:1px solid #59473f;
		background-color: white;
		color:#59473f;
		padding:0.5em;
		cursor:pointer;
	}
	.profile-modal > .profile-footer > button:hover {
		background-color: #59473f;
		color: white;
	}
	
	.profile-modal input {
		border:none;
		border-bottom:2px solid #59473f;
		width:100%;
		outline: none;
		font-size: 15px;
		padding: 0.5em;
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
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-users" 
					width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" 
					stroke-linecap="round" stroke-linejoin="round" 
					@click="mode = 'user'" :class="{active : mode == 'user'}">
						  <path stroke="none" d="M0 0h24v24H0z" fill="none"/>
						  <circle cx="9" cy="7" r="4" />
						  <path d="M3 21v-2a4 4 0 0 1 4 -4h4a4 4 0 0 1 4 4v2" />
						  <path d="M16 3.13a4 4 0 0 1 0 7.75" />
						  <path d="M21 21v-2a4 4 0 0 0 -3 -3.85" />
					</svg>
				</div>
				
				<!-- 채팅방 아이콘 -->
				<div class="icon-wrapper">
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-message-circle" 
					width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" 
					fill="none" stroke-linecap="round" stroke-linejoin="round" 
					@click="mode = 'room'" :class="{active : mode == 'room'}">
					  	<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
					  	<path d="M3 20l1.3 -3.9a9 8 0 1 1 3.4 2.9l-4.7 1" />
					  	<line x1="12" y1="12" x2="12" y2="12.01" />
					  	<line x1="8" y1="12" x2="8" y2="12.01" />
					  	<line x1="16" y1="12" x2="16" y2="12.01" />
					</svg>
<!-- 					<div class="badge" v-show="remainCount > 0">{{remainCount}}</div> -->
					<div class="badge">1</div>
				</div>
				
				<!-- 수정 관련 코드(예정) -->
				<!-- 
				<div class="icon-wrapper">
					<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-user-search" width="36" height="36" viewBox="0 0 24 24" stroke-width="1.5" stroke="#000000" fill="none" stroke-linecap="round" stroke-linejoin="round" @click="showModal">
						<path stroke="none" d="M0 0h24v24H0z" fill="none"/>
						<circle cx="12" cy="7" r="4" />
						<path d="M6 21v-2a4 4 0 0 1 4 -4h1" />
						<circle cx="16.5" cy="17.5" r="2.5" />
						<path d="M18.5 19.5l2.5 2.5" />
					</svg>
				</div>
				 -->
				
			</div>
			<div class="user-list" v-show="mode == 'user'">
				<div class="user" v-for="(user, idx) in  userList" :key="idx">
					<div class="user-profile">
						<img v-bind:src="user.profile">
					</div>
					<div class="user-detail" v-on:click="selectUser(user);">
						<div class="user-name">
							{{user.nickname}}
							<span v-if="user.seq == parseInt(owner.seq)">(자신)</span> 
						</div>
						<div class="user-status">
							{{user.status}}
							<span v-if="!user.status">&nbsp;</span>
						</div>
					</div>
				</div>
			</div>
			
			<div class="room-list" v-show="mode == 'room'">
				<div class="room" v-for="(data, idx) in roomList" :key="idx">
					<div class="room-profile">
						<div class="image-wrapper" v-for="(user, index) in data.users">
							<img :src="user.profile">
						</div>
					</div>
					<div class="room-detail" v-on:click="selectRoom(room);">
						<div class="room-name">
							<span v-show="true">{{data.room.no}}번 방</span>
<!-- 							{{convertToUserString(room.users)}} -->
						</div>
						<div class="room-preview">
							preview
						</div>
						<div class="badge" v-show="true">1</div>
					</div>
				</div>
			</div>
			
		</div>
		
		<!-- chat-wrapper -->
		<div class="chat-wrapper">
			<div class="room-information">
				<div class="title" v-if="isTempRoom">
					<span v-if="currentRoom.users[0].seq == parseInt(owner.seq)">내 대화방</span>
					<span v-else>{{currentRoom.users[0].nickname}} 님과의 대화</span>
				</div>
				<div class="title" v-else-if="isExistRoom">
					<span v-show="false">{{currentRoom.no}}번 방</span>
					{{calculateRoomTitle(currentRoom.users)}}
				</div>
			</div>
			<div class="message-wrapper" ref="messageWrapper">
				<div v-if="isExistRoom" v-for="(msg, idx) in currentRoom.history" >
					<div  class="message-outer" v-bind:class="{my:msg.sender.seq==owner.seq}"> 
						<div class="message-profile" v-if="msg.sender.seq != owner.seq" :class="{first : checkFirst(idx)}">
							<img :src="msg.sender.profile" v-if="checkFirst(idx)">
						</div>
						<div class="message-body" >
							<div class="sender" v-if="msg.sender.seq != owner.seq && checkFirst(idx)">{{msg.sender.nickname}}</div>
							<div class="content">{{msg.content}}</div>
							<div class="time" v-if="checkLast(idx)">{{timeFormat(msg.ctime)}}</div>
						</div>
					</div>
				</div>
			</div>
			<div class="control-panel">
				<div class="first-panel">
					<div class="input-panel">
						<textarea name="message" ref="editor" v-bind:placeholder="textareaPlaceholder" 
							v-model="editorMessage" v-bind:disabled="!isEditorValid" 
							v-on:keypress.enter.exact.prevent="sendEditorMessage" 
							v-on:keydown.shift.enter.prevent.exact="textareaNextline"></textarea>
					</div>
					<div class="button-panel">
						<button v-on:click="sendEditorMessage" v-bind:disabled="!isEditorValid">전송</button>
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
	<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.24.0/axios.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/locale/ko.min.js"></script>
	<script>
		var app = Vue.createApp({
			data(){
				return {
					owner : {
						seq:"${user.seq}",
						nickname:"${user.nickname}",
						profile:"${user.profile}",
						status:"${user.status}"
					},
					
					//websocket
					socket:null,
					
					//editor
					editorMessage:"",
					
					//userList
					userList:[],
					
					mode:"user",
					
					//room
					currentRoom:null,
					roomList:[],
					
					//room message list
					roomMessageList:[],
				};
			},
			computed:{
				isTempRoom(){
					return this.currentRoom != null && this.currentRoom.roomNo == 0;
				},
				isExistRoom() {
					return this.currentRoom != null && this.currentRoom.roomNo > 0;
				},
				isEditorValid() {
					return this.currentRoom != null;
				},
				textareaPlaceholder(){
					return this.isEditorValid ? "채팅 메세지 입력" : "사용자 또는 방을 선택하세요";
				},
				
			},
			methods:{
				openHandler(){},
				closeHandler(){},
				errorHandler(){},
				messageHandler(text){
					const obj = JSON.parse(text);
					switch(obj.type) {
					case "userList":
						this.userList.splice(0);
						this.userList.push(this.owner);
						this.userList.push(...obj.data.filter(u=>u.seq !== parseInt(this.owner.seq)));
						break;
					case "roomList":
						this.roomList.splice(0);
						this.roomList.push(...obj.data);
						break;
					case "message":
						this.addMessageStack(obj);
						break;
					}
				},
				sendEditorMessage(e) {  
					if(!(this.isExistRoom || this.isTempRoom)) return;
					if(!this.editorMessage) return;
					
					const data = {
						roomNo : this.currentRoom.roomNo,
						content : this.editorMessage
					};
					
					if(this.isTempRoom) {
						data.target = this.currentRoom.users.map(user=>user.seq);
					}
					
					this.socket.send(JSON.stringify(data));
					this.editorMessage = "";
				},
				arrayEquals(a, b){
					return a.length === b.length && a.every((v,i)=> parseInt(v) === parseInt(b[i]));
				},
				selectUser(user) {
					//선택한 유저와 둘만의 메세지룸 찾기
					const dummy = [this.owner.seq, user.seq].sort();
					const target = this.roomMessageList.filter((obj, idx)=>{
						const array = obj.users.map(d=>d.seq).sort();
						return this.arrayEquals(dummy, array);
					});
					
					if(target.length == 0) {
						this.currentRoom = {
							roomNo:0,
							users:[user],               
							history:[],
						};
					}
					else {
						this.currentRoom = target[0];
					}
				},
				
				textareaNextline() {
					const editor = this.$refs.editor;
					editor.value += '\n';
				},
				addMessageStack(obj) {
					const data = obj.data;
					const isNew = obj.isNew;
					const userList = obj.userList;
					
					let index = -1;
					const target = this.roomMessageList.filter((obj, idx)=>{
						if(obj.roomNo == data.room.no) {
							index = idx;
							return true;
						}
						return false;
					});
					
					if(index == -1) {//신규
						const obj = {
							roomNo : data.room.no,
							users : userList,
							history : [data] 
						};
						this.roomMessageList.unshift(obj);
						
						if(isNew) {
							this.currentRoom = obj;
						}
					}
					else {//기존
						const obj = target[0];
						obj.users = userList;
						obj.history.push(data);
						this.roomMessageList.splice(index, 1);
						this.roomMessageList.unshift(obj);
					}
				},
				//첫번째 메세지 확인(동일시간)
				checkFirst(idx){
					if(idx == 0) return true;
					
					const messageList = this.currentRoom.history;
					
					if(messageList[idx-1].time != messageList[idx].time) return true;
					if(messageList[idx-1].sender.seq != messageList[idx].sender.seq) return true;
					
					return false;
				},
				//마지막 메세지 확인(동일시간)
				checkLast(idx){
					const messageList = this.currentRoom.history;
					
					if(idx == messageList.length-1) return true;
					if(messageList[idx+1].time != messageList[idx].time) return true;
					if(messageList[idx+1].sender.seq != messageList[idx].sender.seq) return true;
					
					return false;
				},
				
				timeFormat(time) {
					return moment.utc(time).format("LT");
				},
				
				calculateRoomTitle(users) {
					const withoutOwner = users.filter(user=>user.seq !== parseInt(this.owner.seq));
					
					//한명도 안남았으면 자신과의 대화
					switch(withoutOwner.length) {
					case 0: return "내 대화방";
					case 1: return withoutOwner[0].nickname + " 님과의 대화";
					default: return withoutOwner.join(',') + " 님과의 그룹 대화";
					}
				}
			},
			watch:{
				
			},
			created(){
				this.socket = new SockJS("${pageContext.request.contextPath}/websocket");
				this.socket.onopen = ()=>{};
				this.socket.onclose = ()=>{};
				this.socket.onerror = ()=>{ this.errorHandler(); };
				this.socket.onmessage = (e)=>{ this.messageHandler(e.data); };
			},
		});
		app.mount("#app");
	</script>
</body>
</html>

