package com.hacademy.cocoatalk.chat;

import java.util.Arrays;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArraySet;

import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.stereotype.Component;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class Server implements ChannelInterceptor{
	
	private final String publicChannel = "/topic/all";
	private final String privateChannelPrefix = "/topic/";
	private final String privateMessageSuffix = "-msg";
	
	@Setter
	private SimpMessagingTemplate template;

	//모든 사용자
	private Set<User> allUsers = new CopyOnWriteArraySet<>();
	
	//아이디 별 사용자
	private Map<String, User> userById = new ConcurrentHashMap<>();
	
	//채팅방 시퀀스
	private long roomSequence = 1;

	//사용자 별 채팅방
	private Map<String, Set<User>> roomByNumber = new ConcurrentHashMap<>();
	private Map<User, Set<String>> userByRoom = new ConcurrentHashMap<>();
	
	//사용자 입장
	public void enter(User user) {
		log.debug("** User Enter ** {}", user.getId());
		
		//모든 사용자 목록에 등록
		allUsers.add(user);
		
		//아이디별 사용자 목록에 등록
		userById.put(user.getId(), user);
		
		//전체 사용자에게 알림
		broadcastUserList();
	}
	
	//사용자 퇴장
	public void leave(String id) {
		log.debug("** User Leave ** {}", id);
		
		User user = userById.remove(id);
		if(user == null) return;

		allUsers.remove(user);
		broadcastUserList();
		
		Set<String> room = userByRoom.remove(user);
		//room에 알림 전송
		for(String no : room) {
			roomByNumber.get(no).remove(user);
		}
	}
	
	public User get(String id) throws IllegalArgumentException{
		User user = userById.get(id);
		if(user == null) throw new IllegalArgumentException("user not found ["+id+"]");
		
		return user;
	}
	
	//채팅방 할당
	public long createRoom() {
		return roomSequence++;
	}
	public void joinRoom(String room, Message message, User ... users) {
		if(users == null) throw new IllegalArgumentException("사용자는 반드시 1명 이상 있어야합니다");
		
		//방 입장
		Set<User> roomUsers = roomByNumber.get(room);
		if(roomUsers == null) {
			roomUsers = new CopyOnWriteArraySet<User>();
			roomByNumber.put(room, roomUsers);
		}
				
		//사용자 추가
		for(User user : users) {
			roomUsers.add(user);
			//사용자에게 방 설정
			Set<String> userRooms = userByRoom.get(user);
			if(userRooms == null) {
				userRooms = new CopyOnWriteArraySet<String>();
				userByRoom.put(user, userRooms);
			}
			userRooms.add(room);
		}

		//사용자 추가 후 방 전체에게 메세지 발송
		for(User user : roomUsers) {
			template.convertAndSend(privateChannelPrefix+user.getId(), 
					JoinMessage.builder()
					.roomNumber(room)
					.roomUsers(roomUsers)
					.message(message)
					.build());
		}
	}
	public void leaveRoom(long room, User user) {
		Set<User> users = roomByNumber.get(room);
		if(users == null) return;
		
		users.remove(user);
		
		if(users.isEmpty()) {
			roomByNumber.remove(room);
		}
		else {
			//알림
			template.convertAndSend(privateChannelPrefix+room, user.getId()+" leave");
		}
	}
	
	//사용자 목록 전송
	public void broadcastUserList() {
		template.convertAndSend(publicChannel, allUsers);
	}
	
	//전체 메세지 발송
	public void broadcastMessage(Message message) {
		template.convertAndSend(publicChannel, message);
	}
	
	public void sendMyMessage(User user, Message message) {
		template.convertAndSend(privateChannelPrefix+user.getId()+privateMessageSuffix, message);
	}
	
	public void sendMessageForRoom(String room, Message message) {
		if(!roomByNumber.containsKey(room)) return;
		template.convertAndSend(privateChannelPrefix+room, message);
	}
	
	public void sendMessageForRoom(String sender, String room, String content) {
		log.debug("send message to room : sender({}), room({}), content({})", sender, room, content);
		log.debug("room({}) - {}", room, roomByNumber.get(room));
		Message message = Message.builder().sender(sender).content(content).build();
		sendMessageForRoom(room, message);
	}
	
	public void sendMessageForUser(String sender, String target, String content) {
		log.debug("send message to target : sender({}), target({}), content({})", sender, target, content);
		User senderUser = userById.get(sender);
		if(senderUser == null) return;
		
		User targetUser = userById.get(target);
		if(targetUser == null) return;
		
		//메세지 생성
		Message message = Message.builder().sender(sender).content(content).build();
		
		//자기자신에게 메세지를 보내면 sender와 target이 같다.
		if(senderUser.equals(targetUser)) {
			if(findMyRoom(targetUser)) {
				sendMyMessage(targetUser, message);
			}
			else {
				String roomNumber = targetUser.getId()+privateMessageSuffix;
				joinRoom(roomNumber, message, targetUser);
			}
			return;
		}
		
		//자기자신에게 보내는 것이 아닐 경우
		Set<String> rooms = findRoomByUser(senderUser, targetUser);
		System.out.println("rooms result = " + rooms);

		//겹치는 방이 없다면 생성해서 메세지 전송
		if(rooms == null || rooms.size() == 0) {
			String roomNumber = String.valueOf(createRoom());
			joinRoom(roomNumber, message, senderUser, targetUser);
		}
		//겹치는 방이 존재할경우(후에 2개 이상인 경우에 대해서 고민해봐야할듯)
		else {
			for(String room : rooms) {
				sendMessageForRoom(sender, room, content);
			}
		}
	}
	
	public boolean findMyRoom(User user) {
		if(user == null) 
			throw new IllegalArgumentException("반드시 1명의 사용자를 넣어야 합니다");
		
		log.debug("find my room = {}", user.getId());
		
		Set<String> rooms = userByRoom.get(user);
		return rooms != null && rooms.contains(user.getId()+privateMessageSuffix);
	}
	
	public Set<String> findRoomByUser(User ... users) {
		if(users == null || users.length == 0) 
			throw new IllegalArgumentException("반드시 1명 이상의 사용자를 넣어야 합니다");
		
		log.debug("findRoomByUser : users = {}", Arrays.deepToString(users));
		Set<String> checker = new CopyOnWriteArraySet<>();
		
		for(int i=0; i < users.length; i++) {
			Set<String> userRoom = userByRoom.get(users[i]);
			if(userRoom == null) return null;
			
			if(i == 0) 
				checker.addAll(userRoom);
			else 
				checker.retainAll(userRoom);
			
			System.out.println("["+users[i].getId()+"] userRoom = " + userRoom);
			System.out.println("checker = " + checker);
		}
		
		if(checker.isEmpty()) {
			return null;
		}
		else {
			return checker;
		}
	}
	
	@Override
	public void postSend(org.springframework.messaging.Message<?> message, MessageChannel channel, boolean sent) {
		StompHeaderAccessor accessor = StompHeaderAccessor.wrap(message);
		String id = (String)accessor.getSessionAttributes().get("id");
		if(id == null) return;
		
        switch (accessor.getCommand()) {
            case CONNECT:
                // 유저가 Websocket으로 connect()를 한 뒤 호출됨
                break;
            case DISCONNECT:
            	log.debug("** user leave ** = {}", id);
            	leave(id);
                // 유저가 Websocket으로 disconnect() 를 한 뒤 호출됨 or 세션이 끊어졌을 때 발생함(페이지 이동~ 브라우저 닫기 등)
                break;
            default:
                break;
        }

	}
	
}
