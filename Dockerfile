FROM openjdk:17-slim as builder
WORKDIR /build
COPY . /build
RUN ./gradlew clean bootJar -x test

FROM openjdk:17-slim
WORKDIR /app

RUN mkdir -p /app/images
RUN mkdir -p /app/logs

COPY --from=builder /build/build/libs/*.jar /app/app.jar
COPY --from=builder /build/src/main/resources/keystore.p12 /app/keystore.p12

ENV SPRING_PROFILES_ACTIVE=docker
ENTRYPOINT ["java", "-Dserver.ssl.key-store=/app/keystore.p12", "-Dserver.ssl.key-store-password=Rlagkstn1@", "-Dserver.ssl.key-store-type=PKCS12", "-jar", "/app/app.jar"]
