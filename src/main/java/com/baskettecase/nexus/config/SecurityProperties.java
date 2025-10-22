package com.baskettecase.nexus.config;

import org.springframework.boot.context.properties.ConfigurationProperties;

import java.util.List;

/**
 * Security configuration properties.
 */
@ConfigurationProperties(prefix = "nexus.security")
public record SecurityProperties(
        JwtProperties jwt,
        CorsProperties cors
) {
    public record JwtProperties(
            String secret,
            long expiration,
            String issuer
    ) {
    }

    public record CorsProperties(
            List<String> allowedOrigins,
            List<String> allowedMethods,
            List<String> allowedHeaders,
            boolean allowCredentials
    ) {
    }
}
