package com.hacademy.cocoatalk.controller;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.hacademy.cocoatalk.entity.User;
import com.hacademy.cocoatalk.repo.UserRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class HomeController {

	@Autowired
	private UserRepository userRepository;
	
	@GetMapping("/")
	public String index(HttpSession session) {
		if(session.getAttribute("user") != null) {
			return "redirect:/chat";
		}
		return "index";
	}
	
	@PostMapping("/")
	@ResponseBody
	public boolean login(HttpSession session, @RequestBody User user) {
		log.debug("[POST] login request : {}", user);
		
		User target = userRepository.findByNickname(user.getNickname());
		if(target == null) {
			User result = userRepository.save(user);
			session.setAttribute("user", result);
		}
		else {
			session.setAttribute("user", target);
		}
		return true;
	}
	
	@GetMapping("/chat")
	public String home() {
		return "chat";
	}
	
}
