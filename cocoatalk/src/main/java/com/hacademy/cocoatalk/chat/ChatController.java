package com.hacademy.cocoatalk.chat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class ChatController {
	
	@Autowired
	private SimpMessagingTemplate template;
	
	@MessageMapping("/chat/{room}")
	public void receive(@DestinationVariable String room, String content) {
		log.debug("room = {}, content = {}", room, content);
		template.convertAndSend("/topic/"+room, content);
	}
	
}
