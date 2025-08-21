package com.example.demo;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {


    private static final Logger logger = LoggerFactory.getLogger("OTLP");

    
    public static void main(String[] args) {
        logger.info("Application starting...COCKTAIL LOG SERVICE TEST");  // 애플리케이션 시작 로그
        SpringApplication.run(DemoApplication.class, args);
        logger.info("Application started successfully.");
    }

}
