package com.hacademy.cocoatalk.chat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatController {
	
	@Autowired
	private Server server;
	
	@MessageMapping("/chat/{type}/{target}")
	public void receiveTarget(@DestinationVariable String type, @DestinationVariable String target, String content, SimpMessageHeaderAccessor accessor) {
		User user = (User)accessor.getSessionAttributes().get("user");
		if(user == null) return;
		
		String[] targetArray = target.split(",");
		switch(type) {
		case "room":
			server.sendMessageForRoom(user, content, target);
			break;
		case "id":
			server.sendMessageForUser(user, content, targetArray);
			break;
		}
		
	}
	
//	private int tempSequence = 1;
	
	@SubscribeMapping("/all")// "/topic/all"의 구독을 감지(applicationPrefix에 /topic이 있어야 함)
	public void subscribe(SimpMessageHeaderAccessor accessor) {
		log.debug("subscribe mapping /topic/all : {}", accessor.getSessionAttributes());
		User user = (User)accessor.getSessionAttributes().get("user");
		if(user == null) return;
//		String profile = "https://picsum.photos/seed/"+(tempSequence++)+"/200";
//		String status = "";
//		server.enter(User.builder().id(id).profile(profile).status(status).build());
		server.enter(user);
	}
	
}
