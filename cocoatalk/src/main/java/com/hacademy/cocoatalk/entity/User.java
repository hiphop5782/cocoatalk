package com.hacademy.cocoatalk.entity;

import java.util.Map;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.springframework.web.socket.WebSocketSession;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Entity @Table(name = "users")
@SequenceGenerator(name = "users_seq", initialValue = 1, allocationSize = 1)
@Data @NoArgsConstructor @AllArgsConstructor @Builder
@EqualsAndHashCode(of = "session")//테스트수정코드
@JsonIgnoreProperties
public class User {
	@Id @GeneratedValue(generator = "users_seq", strategy = GenerationType.AUTO)
	private Long seq;
	@Column(unique = true, nullable = false)
	private String nickname;
	@Column
	private String status;
	@Column
	private String profile;
	
	@JsonIgnore
	private transient WebSocketSession session;
	
	public static User of(WebSocketSession session) {
		Map<String, Object> attr = session.getAttributes();
		if(attr == null) return null;

		User user = (User)attr.get("user");
		user.setSession(session);
		return user;
	}
}
