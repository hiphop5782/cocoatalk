package com.hacademy.cocoatalk.controller;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class MainController {
	
	@GetMapping("/")
	public String index() {
		return "index";
	}
	
	@PostMapping("/")
	public String login(
				HttpSession session,
				@RequestParam String email
			) {
		session.setAttribute("user", email);
		return "redirect:/home";
	}
	
	@GetMapping("/home")
	public String home() {
		return "home";
	}
	
}
