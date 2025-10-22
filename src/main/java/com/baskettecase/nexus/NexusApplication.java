package com.baskettecase.nexus;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * Nexus MCP Gateway Application.
 * <p>
 * Unified gateway for connecting to multiple backend MCP servers and exposing
 * a single MCP interface for downstream consumers.
 * </p>
 */
@SpringBootApplication
@EnableJpaAuditing
@EnableScheduling
public class NexusApplication {

    public static void main(String[] args) {
        SpringApplication.run(NexusApplication.class, args);
    }
}
