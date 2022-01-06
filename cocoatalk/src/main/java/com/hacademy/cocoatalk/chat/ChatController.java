package com.hacademy.cocoatalk.chat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

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
	
//	private Server server = new Server();
	
	private Set<User> users = new CopyOnWriteArraySet<>();
	
	int roomSequence = 1;
	private Map<String, Integer> rooms = new HashMap<>();
	
	@Autowired
	private SimpMessagingTemplate template;
	
	@MessageMapping("/chat/{owner}/{target}")
	public void receive(@DestinationVariable String owner, @DestinationVariable String target, String content, SimpMessageHeaderAccessor accessor) {
		String id = (String)accessor.getSessionAttributes().get("id");
		if(id == null || owner == null || !id.equals(owner)) return;
		
		Map<String, Object> map = new HashMap<>();
		map.put("sender", id);
		map.put("content", content);
		map.put("time", LocalDateTime.now().format(DateTimeFormatter.ofPattern("a h:mm")));
		
		if(rooms.containsKey(id)) {
			int roomNo = rooms.get(id);
			template.convertAndSend("/topic/"+roomNo, map);
		}
		else if(!rooms.containsKey(id) || !rooms.containsKey(target)) {
			int roomNo = roomSequence++;
			rooms.put(id, roomNo);
			
			Map<String, Object> roomData = new HashMap<>();
			roomData.put("roomNo", roomNo);
			roomData.put("owner", owner);
			roomData.put("target", target);
			roomData.put("message", map);
			
			template.convertAndSend("/topic/"+owner, roomData);
			template.convertAndSend("/topic/"+target, roomData);
			return;
		}
		
	}
	
	@SubscribeMapping("/all")// "/topic/all"의 구독을 감지(applicationPrefix에 /topic이 있어야 함)
	public void subscribe(SimpMessageHeaderAccessor accessor) {
		String id = (String)accessor.getSessionAttributes().get("id");
		if(id == null) return;
		String profile = "https://picsum.photos/200";
		String status = "";
		
		User user = User.builder().id(id).profile(profile).status(status).build();
		users.add(user);
		
		template.convertAndSend("/topic/all", users);
	}
	
}
