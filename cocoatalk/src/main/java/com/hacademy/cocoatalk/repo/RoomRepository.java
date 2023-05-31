package com.hacademy.cocoatalk.repo;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hacademy.cocoatalk.entity.Room;

public interface RoomRepository extends JpaRepository<Room, Long>{

}
