package com.hacademy.cocoatalk.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hacademy.cocoatalk.entity.User;

public interface UserRepository extends JpaRepository<User, Long>{
	User findByNickname(String nickname);
}
