package com.hacademy.cocoatalk.entity;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity @Table(name = "room_user") @SequenceGenerator(name = "room_user_seq", initialValue = 1, allocationSize = 1)
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class RoomUser {
	@Id @GeneratedValue(generator = "room_user_seq")
	private Long id;
	
	@ManyToOne(cascade = CascadeType.REMOVE, targetEntity = User.class)
	private User user;
	
	@ManyToOne(cascade = CascadeType.REMOVE, targetEntity = Room.class)
	private Room room;
}
