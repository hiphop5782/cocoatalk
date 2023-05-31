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
		font-size: 0.75em;
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
		white-space: nowrap;
	}
	.container > .message-wrapper {
		text-align: center;
		color:#cccccc;
		height:2em;
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
	.container > .input-wrapper > label,
	.container > .help-wrapper{
		color:#cccccc;
	}
	.container > .input-wrapper.image-wrapper {
		display:flex;
		flex-wrap:wrap;
	}
	.container > .input-wrapper.image-wrapper > .image {
		width:20%;
		padding:5px;
	}
	.container > .input-wrapper.image-wrapper > .image > img{
		width:100%;
		cursor:pointer;
		opacity:0.7;
		border:2px solid transparent;
	}
	.container > .input-wrapper.image-wrapper > .image:hover > img {
		opacity:1;
	}
	.container > .input-wrapper.image-wrapper > .image > img.selected {
		border-color:white;
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
	
	@media screen and (max-width:640px){
		.warning {
			white-space: normal;
			font-size: 0.5em;
			width:90%;
			min-width:250px;
			text-align: center;
		}
	}
	
	@media screen and (max-width:400px){
		.container {
			width:90%;
			min-width:250px;
		}
		.container > .logo-wrapper {
			font-size:1.8em;
		}
		.container > .help-wrapper {
			width:90%;
			min-width:250px;
			font-size:0.5em;
		}
	}
</style>
</head>
<body>
	<div id="app">
		<div class="warning">
			이 사이트는 WebSocket의 이해를 돕기 위한 수업 자료로 사용되며 다른 용도로 사용되지 않습니다.
		</div>
		<form method="post" class="login-form" @submit.prevent="checkAndSubmit">
			<div class="container">
				<div class="logo-wrapper">
					COCOA-TALK
				</div>
				<div class="input-wrapper">
					<input type="text" placeholder="닉네임(필수)" autocomplete="off" v-model="user.nickname" @input="refreshNickname" @keydown.enter.prevent>
				</div>
				<div class="input-wrapper image-wrapper" v-show="nicknameIsReady">
					<div class="image" v-for="(profile, index) in profileList" :key="index" @click="selectProfile(index)">
						<img :src="profile.src" :class="{selected : profile.selected}">
					</div>
				</div>
				<div class="input-wrapper" v-show="userIsReady">
					<input type="text" v-model="user.status" placeholder="상태 메세지(선택)" @keydown.enter.prevent>
				</div>
				<div class="input-wrapper" v-if="userIsReady">
					<button type="submit">로그인</button>
				</div>
				<div class="message-wrapper">{{message.text}}</div>
				<!-- 
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
				 -->
			</div>	
		</form>
	</div>
	
	<script src="https://unpkg.com/vue@3.2.36"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.24.0/axios.min.js"></script>
	<script>
		Vue.createApp({
			data(){
				return {
					user:{
						nickname:"",
						profile:"",
					},
					profileList:[
						{src:"https://picsum.photos/id/0/200/200",selected:false},
						{src:"https://picsum.photos/id/10/200/200",selected:false},
						{src:"https://picsum.photos/id/1002/200/200",selected:false},
						{src:"https://picsum.photos/id/1004/200/200",selected:false},
						{src:"https://picsum.photos/id/1009/200/200",selected:false},
						{src:"https://picsum.photos/id/1011/200/200",selected:false},
						{src:"https://picsum.photos/id/1015/200/200",selected:false},
						{src:"https://picsum.photos/id/1018/200/200",selected:false},
						{src:"https://picsum.photos/id/1019/200/200",selected:false},
						{src:"https://picsum.photos/id/102/200/200",selected:false},
						{src:"https://picsum.photos/id/1027/200/200",selected:false},
						{src:"https://picsum.photos/id/103/200/200",selected:false},
						{src:"https://picsum.photos/id/1033/200/200",selected:false},
						{src:"https://picsum.photos/id/1035/200/200",selected:false},
						{src:"https://picsum.photos/id/1040/200/200",selected:false},
					],
					message:{
						text:"",
					},
				};
			},
			computed:{
				nicknameIsReady(){
					const regex = /^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9!@#$]{1,20}$/g;
					return regex.test(this.user.nickname);
				},
				profileIsReady(){
					return this.user.profile != null && this.user.profile.length > 0;
				},
				userIsReady(){
					return this.nicknameIsReady && this.profileIsReady;
				},
			},
			methods:{
				refreshNickname(e){
					this.user.nickname = e.target.value;
				},
				selectProfile(index){
					this.user.profile = this.profileList[index].src;

					for(let i = 0 ; i < this.profileList.length; i++){
						this.profileList[i].selected = (index == i);
					}
					//console.log(this.profileList);
				},
				checkAndSubmit(e){
					if(!this.userIsReady) {
						this.message.text = "항목을 모두 입력해주세요"
					}
					
					//console.log(JSON.stringify(this.user));
					
					axios.post(
						"./", JSON.stringify(this.user), 
						{headers:{"Content-Type":"application/json"}}
					).then((resp)=>{
						if(resp.data){
							this.message.text = "로그인이 완료되었습니다";
							location.href = "${pageContext.request.contextPath}/chat";
						}
					});
				},
			},
		}).mount("#app");
	</script>
</body>
</html>