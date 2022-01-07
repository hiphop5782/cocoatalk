package com.hacademy.cocoatalk.chat;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class SimpleCORSFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        //log.info("Initilisation du Middleware");
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest requestToUse = (HttpServletRequest)servletRequest;
        HttpServletResponse responseToUse = (HttpServletResponse)servletResponse;

        responseToUse.setHeader("Access-Control-Allow-Origin",requestToUse.getHeader("Origin"));
        filterChain.doFilter(requestToUse,responseToUse);
    }

    @Override
    public void destroy() {

    }
}