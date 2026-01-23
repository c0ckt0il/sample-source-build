FROM tomcat:latest
COPY target/demo-0.0.1-SNAPSHOT.jar demo.jar
CMD sleep 3600
ENTRYPOINT ["java","-jar","demo.jar"]
