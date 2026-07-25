from maven:3.9-eclipse-temurin-11 AS builder
workdir /app
copy pom.xml .
run mvn dependency:go-offline
copy src ./src
run mvn clean package


from tomcat:10-jdk11
COPY --from=builder /app/target/MyTechStore.war /usr/local/tomcat/webapps/ROOT.war
expose 8080
CMD ["catalina.sh", "run"]