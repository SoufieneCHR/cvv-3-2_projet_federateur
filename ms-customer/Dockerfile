# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the application JAR file
COPY target/ms-customer-0.0.1-SNAPSHOT.jar /app/ms-customer.jar

# Copy the application.properties file
COPY src/main/resources/application.properties /app/config/application.properties

# Additional files
COPY src/main/resources/data.sql /app/data.sql
COPY data/customerdb.mv.db /app/data/customerdb.mv.db

# Expose the application port
EXPOSE 8085

# Run the application
ENTRYPOINT ["java", "-jar", "ms-customer.jar"]
