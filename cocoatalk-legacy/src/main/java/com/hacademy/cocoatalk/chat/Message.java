package com.hacademy.cocoatalk.chat;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Message {
	private User sender;
	private String content;
	private final String time = LocalDateTime.now().format(DateTimeFormatter.ofPattern("a h:mm"));
}
