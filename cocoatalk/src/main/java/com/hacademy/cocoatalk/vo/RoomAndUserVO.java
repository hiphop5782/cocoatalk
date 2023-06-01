package com.hacademy.cocoatalk.vo;

import java.util.Set;

import com.hacademy.cocoatalk.entity.Room;
import com.hacademy.cocoatalk.entity.User;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class RoomAndUserVO {
	private Room room;
	private Set<User> users;
}
