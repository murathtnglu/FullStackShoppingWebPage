package com.example.databasehomework2;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

@Service
public class UserInfoService {

    private final JdbcTemplate jdbcTemplate;

    @Autowired
    public UserInfoService(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public List<UserInfo> getAllUserInfos() {
        String sql = "SELECT * FROM userinfo";
        return jdbcTemplate.query(sql, (rs, rowNum) -> mapRowToUserInfo(rs));
    }

    public boolean registerUser(UserInfo userInfo) {
        String sql = "INSERT INTO userinfo (email, password, fname, lname, usertype, bdate) VALUES (?, ?, ?, ?, ?, ?)";
        int result = jdbcTemplate.update(sql, userInfo.getEmail(), userInfo.getPassword(), userInfo.getFirstName(), userInfo.getLastName(), userInfo.getUserType(), userInfo.getBirthDate());
        return result > 0;
    }

    private UserInfo mapRowToUserInfo(ResultSet rs) throws SQLException {
        UserInfo userInfo = new UserInfo();
        userInfo.setUserId(rs.getLong("userid"));
        userInfo.setEmail(rs.getString("email"));
        userInfo.setPassword(rs.getString("password"));
        userInfo.setFirstName(rs.getString("fname"));
        userInfo.setLastName(rs.getString("lname"));
        userInfo.setUserType(rs.getString("usertype"));
        userInfo.setBirthDate(rs.getString("bdate"));
        return userInfo;
    }
}