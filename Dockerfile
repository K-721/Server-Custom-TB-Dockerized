FROM openjdk:17-jdk-slim

# Create a user for security
RUN useradd -ms /bin/bash thingsboard

# Set working directory
WORKDIR /usr/share/thingsboard

# Create folders for consistency
RUN mkdir -p data logs bin conf

# Copy application JAR
COPY thingsboard/application/target/thingsboard-4.0.0-SNAPSHOT-boot.jar bin/thingsboard.jar

# Copy install script
COPY thingsboard/application/target/bin/install/install.sh bin/install.sh

# Optional: config and logging configuration
# Only include this if these files actually exist!
COPY thingsboard/application/target/conf/thingsboard.conf conf/thingsboard.conf
COPY thingsboard/application/target/bin/install/logback.xml bin/install/logback.xml

# Permissions and execution rights
RUN chmod +x bin/install.sh && \
    chown -R thingsboard:thingsboard /usr/share/thingsboard

# Create log directory to avoid GC log errors
RUN mkdir -p /var/log/thingsboard && \
    chown -R thingsboard:thingsboard /var/log/thingsboard

# Set environment variables
ENV JAVA_OPTS="-Xms256M -Xmx512M"

# Expose ports
EXPOSE 8080 1883 7070 \
       5683/udp 5684/udp 5685/udp \
       5686/udp 5687/udp 5688/udp

# Start ThingsBoard
ENTRYPOINT ["java", "-jar", "bin/thingsboard.jar"]

