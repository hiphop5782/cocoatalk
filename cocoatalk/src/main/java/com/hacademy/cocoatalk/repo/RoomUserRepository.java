package com.hacademy.cocoatalk.repo;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.hacademy.cocoatalk.entity.RoomUser;
import com.hacademy.cocoatalk.entity.User;

public interface RoomUserRepository extends JpaRepository<RoomUser, Long>{
	List<RoomUser> findByUser(User user);
}
