package com.hacademy.cocoatalk.chat;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.annotation.SubscribeMapping;
import org.springframework.stereotype.Controller;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatController {
	
	@Autowired
	private Server server;
	
	@Autowired
	private SimpMessagingTemplate template;
	
	@PostConstruct
	public void init() {
		server.setTemplate(template);
	}
	
	@MessageMapping("/chat/{type}/{target}")
	public void receiveTarget(@DestinationVariable String type, @DestinationVariable String target, String content, SimpMessageHeaderAccessor accessor) {
		System.out.println("type = "+type+", target = " + target);
		String id = (String)accessor.getSessionAttributes().get("id");
		if(id == null) return;
		
		switch(type) {
		case "room":
			server.sendMessageForRoom(id, target, content);
			break;
		case "id":
			server.sendMessageForUser(id, target, content);
			break;
		}
	}
	
	private int tempSequence = 1;
	
	@SubscribeMapping("/all")// "/topic/all"의 구독을 감지(applicationPrefix에 /topic이 있어야 함)
	public void subscribe(SimpMessageHeaderAccessor accessor) {
		String id = (String)accessor.getSessionAttributes().get("id");
		if(id == null) return;
		String profile = "https://picsum.photos/seed/"+(tempSequence++)+"/200";
		String status = "";
		
		server.enter(User.builder().id(id).profile(profile).status(status).build());
	}
	
}
