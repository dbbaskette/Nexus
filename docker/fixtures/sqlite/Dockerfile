ARG SPRING_AI_EXAMPLES_REF=main

FROM eclipse-temurin:21-jre AS builder
ARG SPRING_AI_EXAMPLES_REF

RUN apt-get update && apt-get install -y git maven && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
RUN git clone --depth 1 --branch "${SPRING_AI_EXAMPLES_REF}" https://github.com/spring-projects/spring-ai-examples.git .

WORKDIR /workspace/model-context-protocol/sqlite
RUN mvn -B -ntp clean package -DskipTests

FROM eclipse-temurin:21-jre
ENV JAVA_OPTS="" \
    SERVER_PORT=8083

WORKDIR /app
COPY --from=builder /workspace/model-context-protocol/sqlite/target/*.jar ./app.jar

# Create sample SQLite database directory
RUN mkdir -p /data/db

EXPOSE ${SERVER_PORT}
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
