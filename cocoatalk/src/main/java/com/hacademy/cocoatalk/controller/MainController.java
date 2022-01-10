package com.hacademy.cocoatalk.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hacademy.cocoatalk.chat.Server;
import com.hacademy.cocoatalk.chat.User;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class MainController {
	
	@Autowired
	private Server server;
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@PostMapping("/")
	@ResponseBody
	public boolean login(
				HttpSession session,
				@RequestBody User user
			) {
		log.debug("[POST] login request : {}", user);
		if(server.exist(user)) {
			return false;
		}
		else {
			session.setAttribute("user", user);
			return true;
		}
	}
	
	@PutMapping("/")
	@ResponseBody
	public boolean update(HttpSession session, @RequestBody User user) {
		log.debug("[PUT] update request : {}", user);
		User current = (User)session.getAttribute("user");
		log.debug("current user = {}", current);
		log.debug("exist = {}", server.exist(current));
		if(server.change(current, user)) {
			session.setAttribute("user", user);
			return true;
		}
		else {
			return false;
		}
	}
	
	
	@GetMapping("/home")
	public String home() {
		return "home";
	}
	
}
