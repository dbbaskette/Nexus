ARG SPRING_AI_EXAMPLES_REF=main

FROM eclipse-temurin:21-jre AS builder
ARG SPRING_AI_EXAMPLES_REF

RUN apt-get update && apt-get install -y git maven && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
RUN git clone --depth 1 --branch "${SPRING_AI_EXAMPLES_REF}" https://github.com/spring-projects/spring-ai-examples.git .

WORKDIR /workspace/model-context-protocol/filesystem
RUN mvn -B -ntp clean package -DskipTests

FROM eclipse-temurin:21-jre
ENV JAVA_OPTS="" \
    SERVER_PORT=8082

WORKDIR /app
COPY --from=builder /workspace/model-context-protocol/filesystem/target/*.jar ./app.jar

# Create a sample filesystem for testing
RUN mkdir -p /data/sample && \
    echo "Hello from MCP Filesystem Server" > /data/sample/readme.txt

EXPOSE ${SERVER_PORT}
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
