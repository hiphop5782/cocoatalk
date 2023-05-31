package com.hacademy.cocoatalk.entity;

import java.sql.Timestamp;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.CreationTimestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity @Table(name = "room_message") @SequenceGenerator(name = "room_message_seq", initialValue = 1, allocationSize = 1)
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class RoomMessage {
	
	@Id @GeneratedValue(generator = "room_message_seq", strategy = GenerationType.AUTO)
	private Long id;
	
	@ManyToOne(targetEntity = User.class)
	private User sender;
	
	@ManyToOne(targetEntity = Room.class)
	private Room room;
	
	@Column(nullable = false)
	private String content;

	@CreationTimestamp
	private Timestamp ctime;
	
}






