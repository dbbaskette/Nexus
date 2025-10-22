ARG SPRING_AI_EXAMPLES_REF=main

FROM eclipse-temurin:21-jre AS builder
ARG SPRING_AI_EXAMPLES_REF

RUN apt-get update && apt-get install -y git maven && rm -rf /var/lib/apt/lists/*
WORKDIR /workspace
RUN git clone --depth 1 --branch "${SPRING_AI_EXAMPLES_REF}" https://github.com/spring-projects/spring-ai-examples.git .

WORKDIR /workspace/model-context-protocol/weather
RUN mvn -B -ntp clean package -DskipTests

FROM eclipse-temurin:21-jre
ENV JAVA_OPTS="" \
    SERVER_PORT=8081

WORKDIR /app
COPY --from=builder /workspace/model-context-protocol/weather/target/*.jar ./app.jar

EXPOSE ${SERVER_PORT}
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]
