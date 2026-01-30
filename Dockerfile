FROM tomcat:latest
COPY target/demo-0.0.1-SNAPSHOT.war demo.war
ENTRYPOINT ["java","-jar","demo.war"]
