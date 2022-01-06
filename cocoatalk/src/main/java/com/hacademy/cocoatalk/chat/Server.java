package com.hacademy.cocoatalk.chat;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Data
public class Server {
	
	//모든 사용자
	private int userSequence = 1;
	private Set<User> users = new CopyOnWriteArraySet<>();
	private Map<String, User> userIdInformation = new HashMap<>();
	private Map<Integer, User> userSeqInformation = new HashMap<>();
	private Map<String, Integer> userIdSeqInformation = new HashMap<>();
	
	//채팅방 사용자
	private int roomSequence = 1;
	private MultiValueMap<Integer, User> relation = new LinkedMultiValueMap<>();
	private Map<User, Integer> roomInformation = new HashMap<>();
	
	public void enter(User user) {
		int sequence = userSequence;
		users.add(user);
		userIdInformation.put(user.getId(), user);
		userSeqInformation.put(sequence, user);
		userIdSeqInformation.put(user.getId(), sequence);
		userSequence++;
		log.debug("사용자 입장 : {}", user);
	}
	
	public int createChannel(User ... users) {
		int channel = roomSequence;
		for(User user : users) {
			this.users.add(user);
			this.relation.add(channel, user);
			this.roomInformation.put(user, channel);
		}
		log.debug("채널 입장 : [{}] - {}", channel, Arrays.deepToString(users));
		roomSequence++;
		return channel;
	}
	
	public User find(String id) {
		return userIdInformation.get(id);
	}
	
	public User find(int sequence) {
		return userSeqInformation.get(sequence);
	}
	
	public Integer findSequence(String id) {
		return userIdSeqInformation.get(id);
	}
}
