package com.hacademy.cocoatalk.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hacademy.cocoatalk.entity.RoomMessage;

public interface RoomMessageRepository extends JpaRepository<RoomMessage, Long>{
	
}
