package com.hacademy.cocoatalk.websocket;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.hacademy.cocoatalk.entity.Room;
import com.hacademy.cocoatalk.entity.RoomMessage;
import com.hacademy.cocoatalk.entity.RoomUser;
import com.hacademy.cocoatalk.entity.User;
import com.hacademy.cocoatalk.repo.RoomMessageRepository;
import com.hacademy.cocoatalk.repo.RoomRepository;
import com.hacademy.cocoatalk.repo.RoomUserRepository;
import com.hacademy.cocoatalk.repo.UserRepository;
import com.hacademy.cocoatalk.vo.RoomAndUserVO;
import com.hacademy.cocoatalk.vo.RoomUserMessageVO;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class ChatWebSocketServer extends TextWebSocketHandler{

	@Autowired
	private RoomRepository roomRepository;
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private RoomUserRepository roomUserRepository;
	
	@Autowired
	private RoomMessageRepository roomMessageRepository;
	
	private Map<User, Set<Room>> users = Collections.synchronizedMap(new HashMap<>());
	private Map<Room, Set<User>> rooms = Collections.synchronizedMap(new HashMap<>());
	private ObjectMapper mapper = new ObjectMapper();
	
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		log.info("접속");
		User user = User.of(session);
		if(user == null) return;
		
		List<RoomUser> roomUserList = roomUserRepository.findByUser(user);
		//index
		Set<Room> indexRooms = users.get(user);
		if(indexRooms == null) 
			users.put(user, new CopyOnWriteArraySet<>());
		
		//rooms
		for(RoomUser roomUser : roomUserList) {
			Room room = roomUser.getRoom();
			if(!rooms.containsKey(room)) {
				rooms.put(room, new CopyOnWriteArraySet<>());
			}
			rooms.get(room).add(user);
			users.get(user).add(room);
		}
		
		broadcastUserList();
		broadcastRoomList(user);
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		log.info("종료");
		User user = User.of(session);
		if(user == null) return;
		
		users.remove(user);
		for(Room room : rooms.keySet()) {
			rooms.get(room).remove(user);
		}
		
		broadcastUserList();
	}
	
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		log.info("메세지 수신");
		
		User user = User.of(session);
		if(user == null) return;
		
		RoomUserMessageVO receiveData = mapper.readValue(message.getPayload(), RoomUserMessageVO.class);
		//log.info("receiveData = {}", receiveData);
		
		//신규 대상에게의 메세지인 경우(receiveData.room == 0)
		if(receiveData.isFirstTimeMessage()) {
			
			//방 생성
			Room room = roomRepository.save(new Room());
			rooms.put(room, new CopyOnWriteArraySet<>());
			
			//전송자 등록
			roomUserRepository.save(RoomUser.builder().room(room).user(user).build());
			rooms.get(room).add(user);
			users.get(user).add(room);
			
			//수신자 등록
			for(Long seq : receiveData.getTarget()) {
				User targetUser = userRepository.findById(seq).orElse(null);
				
				if(targetUser == null) continue;//존재하지 않는 대상
				if(targetUser.getSeq() == user.getSeq()) continue;//동일유저

				//방 참여
				roomUserRepository.save(
					RoomUser.builder().room(room).user(targetUser).build()
				);
				
				User socketUser = null;
				for(User u : users.keySet()) {
					if(u.getSeq() == targetUser.getSeq()) {
						socketUser = u;
						break;
					}
				}
				
				if(socketUser != null) {
					rooms.get(room).add(socketUser);
					users.get(socketUser).add(room);
				}
				
			}
			
			//메세지 등록
			RoomMessage roomMessage = roomMessageRepository.save(
				RoomMessage.builder()
					.sender(user)
					.room(room)
					.content(receiveData.getContent())
				.build()
			);
			
			broadcastMessage(roomMessage, true);//신규
		}
		else {
			//방 찾기
			Room room = roomRepository.findById(receiveData.getRoomNo()).orElse(null);
			if(room == null) return;
			
			//메세지 등록
			RoomMessage roomMessage = roomMessageRepository.save(
				RoomMessage.builder()
					.sender(user)
					.room(room)
					.content(receiveData.getContent())
				.build()
			);
			
			broadcastMessage(roomMessage, false);//기존
		}
	}

	private void broadcastRoomList(User user) throws IOException {
		Set<Room> roomList = users.get(user);
		List<RoomAndUserVO> roomAndUserList = new ArrayList<>(); 
		for(Room room : roomList) {
			roomAndUserList.add(RoomAndUserVO.builder()
						.room(room)
						.users(rooms.get(room))
					.build());
		}
		Map<String, Object> map = new HashMap<>();
		map.put("type", "roomList");
		map.put("data", roomAndUserList);
		TextMessage message = new TextMessage(mapper.writeValueAsString(map));
		user.getSession().sendMessage(message);
	}
	
	private void broadcastUserList() throws IOException {
		Map<String, Object> map = new HashMap<>();
		map.put("type", "userList");
		map.put("data", users.keySet());
		String jsonText = mapper.writeValueAsString(map);
		TextMessage jsonMessage = new TextMessage(jsonText);
		broadcastMessage(jsonMessage);
	}
	private void broadcastMessage(TextMessage message) throws IOException {
		for(User user : users.keySet()) {
			user.getSession().sendMessage(message);
		}
	}
	private void broadcastMessage(RoomMessage roomMessage, boolean isNew) throws IOException {
		Set<User> userList = rooms.get(roomMessage.getRoom());
		if(userList == null) return;
		
		Map<String, Object> map = new HashMap<>();
		map.put("type", "message");
		map.put("data", roomMessage);
		map.put("userList", userList);
		map.put("isNew", isNew);
		
		TextMessage message = new TextMessage(mapper.writeValueAsString(map));
		broadcastMessage(message);
	}
}
