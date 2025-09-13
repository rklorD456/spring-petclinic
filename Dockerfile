# Use a small JDK runtime image
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app
COPY target/spring-petclinic-*.jar app.jar

# Add a non-root user
RUN addgroup --system spring && adduser --system --ingroup spring spring
USER spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
