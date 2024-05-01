# Use OpenJDK 11 as the base image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the compiled JAR file into the container at /app
COPY ./target/spring-boot-web.jar /app

# Expose port 8080 to the outside world
EXPOSE 8082

# Command to run the Spring Boot application
CMD ["java", "-jar", "spring-boot-web.jar"]