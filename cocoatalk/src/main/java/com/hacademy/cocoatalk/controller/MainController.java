package com.hacademy.cocoatalk.controller;

import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class MainController {
	
	private Set<String> nicknameList = new CopyOnWriteArraySet<>();
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@PostMapping("/")
	@ResponseBody
	public boolean login(
				HttpSession session,
				@RequestParam String nickname
			) {
		if(nicknameList.add(nickname)) {
			session.setAttribute("id", nickname);
			return true;
		}
		else
			return false;
	}
	
	@GetMapping("/home")
	public String home() {
		return "home";
	}
	
}
