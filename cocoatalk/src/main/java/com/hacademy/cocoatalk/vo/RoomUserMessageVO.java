package com.hacademy.cocoatalk.vo;

import java.util.List;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@JsonIgnoreProperties
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class RoomUserMessageVO {
	private long roomNo;
	private List<Long> target;
	private String content;
	
	public boolean isFirstTimeMessage() {
		return roomNo == 0;
	}
}
