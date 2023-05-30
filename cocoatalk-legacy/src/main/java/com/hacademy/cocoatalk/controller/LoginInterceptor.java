package com.hacademy.cocoatalk.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.hacademy.cocoatalk.chat.User;

public class LoginInterceptor implements HandlerInterceptor{
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {
		HttpSession session = request.getSession();
		User user = (User)session.getAttribute("user");
		if(user == null) {
			response.sendRedirect(request.getContextPath());
			return false;
		}
		return true;		
	}
}
