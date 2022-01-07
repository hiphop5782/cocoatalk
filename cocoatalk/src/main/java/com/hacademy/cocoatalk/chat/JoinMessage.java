package com.hacademy.cocoatalk.chat;

import java.util.Set;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class JoinMessage {
	private String roomNumber;
	private Set<User> roomUsers;
	private Message message;
}
