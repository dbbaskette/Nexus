package com.baskettecase.nexus;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.boot.testcontainers.service.connection.ServiceConnection;
import org.springframework.context.annotation.Bean;
import org.testcontainers.containers.PostgreSQLContainer;
import org.testcontainers.utility.DockerImageName;

/**
 * Test configuration with Testcontainers for local development and testing.
 * <p>
 * Run this class to start the application with Testcontainers-managed Postgres.
 * </p>
 */
@TestConfiguration(proxyBeanMethods = false)
public class TestNexusApplication {

    @Bean
    @ServiceConnection
    PostgreSQLContainer<?> postgresContainer() {
        return new PostgreSQLContainer<>(DockerImageName.parse("postgres:16-alpine"))
                .withDatabaseName("nexus")
                .withUsername("nexus")
                .withPassword("nexus")
                .withReuse(true);
    }

    public static void main(String[] args) {
        SpringApplication
                .from(NexusApplication::main)
                .with(TestNexusApplication.class)
                .run(args);
    }
}
