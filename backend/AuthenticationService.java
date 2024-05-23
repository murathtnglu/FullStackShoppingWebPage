package com.example.databasehomework2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

@Service
public class AuthenticationService {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public AuthenticationService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Long authenticate(String email, String password) {
        String sql = "SELECT userid FROM userinfo WHERE email = ? AND password = ?";
        try {
            return jdbcTemplate.queryForObject(sql, new Object[]{email, password}, Long.class);
        } catch (Exception e) {
            return null;
        }
    }
}