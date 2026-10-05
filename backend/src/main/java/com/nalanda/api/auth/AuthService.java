package com.nalanda.api.auth;

import com.nalanda.api.auth.AuthController.ChangePasswordRequest;
import com.nalanda.api.auth.AuthController.ForgotPasswordRequest;
import com.nalanda.api.auth.AuthController.LoginRequest;
import com.nalanda.api.auth.AuthController.LoginResponse;
import com.nalanda.api.auth.AuthController.ResetPasswordRequest;
import com.nalanda.api.auth.AuthController.UserProfile;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.crypto.SecretKey;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.Instant;
import java.util.Date;

@Service
public class AuthService {

    private final String jwtSecret;
    private final Duration accessTokenLifetime;

    public AuthService(@Value("${nalanda.auth.jwt-secret}") String jwtSecret,
                       @Value("${nalanda.auth.access-token-minutes:30}") long accessTokenMinutes) {
        this.jwtSecret = jwtSecret;
        this.accessTokenLifetime = Duration.ofMinutes(accessTokenMinutes);
    }

    public LoginResponse login(LoginRequest request) {
        UserProfile profile = new UserProfile(1L, request.username(), "Admin", "ADMIN");
        return new LoginResponse(createToken(profile), profile.userId(), profile.name(), profile.role());
    }

    public UserProfile currentUser() {
        return new UserProfile(1L, "admin", "Admin", "ADMIN");
    }

    public MessageResponse logout() {
        return new MessageResponse("Logged out successfully");
    }

    public LoginResponse refresh() {
        UserProfile profile = currentUser();
        return new LoginResponse(createToken(profile), profile.userId(), profile.name(), profile.role());
    }

    public MessageResponse forgotPassword(ForgotPasswordRequest request) {
        return new MessageResponse("If the account exists, password reset instructions will be sent");
    }

    public MessageResponse resetPassword(ResetPasswordRequest request) {
        return new MessageResponse("Password reset successfully");
    }

    public MessageResponse changePassword(ChangePasswordRequest request) {
        return new MessageResponse("Password changed successfully");
    }

    private String createToken(UserProfile profile) {
        Instant now = Instant.now();
        return Jwts.builder()
                .subject(profile.username())
                .claim("userId", profile.userId())
                .claim("name", profile.name())
                .claim("role", profile.role())
                .issuedAt(Date.from(now))
                .expiration(Date.from(now.plus(accessTokenLifetime)))
                .signWith(signingKey())
                .compact();
    }

    private SecretKey signingKey() {
        return Keys.hmacShaKeyFor(jwtSecret.getBytes(StandardCharsets.UTF_8));
    }

    public record MessageResponse(String message) {
    }
}