package com.hacademy.cocoatalk.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hacademy.cocoatalk.entity.Room;
import com.hacademy.cocoatalk.entity.RoomMessage;

public interface RoomMessageRepository extends JpaRepository<RoomMessage, Long>{
	List<RoomMessage> findByRoom(Room room);
}
