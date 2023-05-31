package com.hacademy.cocoatalk.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity @Table(name = "room") @SequenceGenerator(name = "room_seq", initialValue = 1, allocationSize = 1)
@Data @NoArgsConstructor @AllArgsConstructor @Builder
@JsonIgnoreProperties
public class Room {
	@Id @GeneratedValue(generator = "room_seq", strategy = GenerationType.AUTO)
	private Long no;
	@Column
	private String name;
}
