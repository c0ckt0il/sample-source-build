package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @GetMapping("/")
    public String index(Model model) {
        String hostname = System.getenv("HOSTNAME");
	    String namespace = System.getenv("NAMESPACE");

		// 클러스터 정보 추가 (환경 변수에서 읽어옴)
		String clusterName = System.getenv("CLUSTER_NAME");
		String clusterId = System.getenv("CLUSTER_ID");
		
        model.addAttribute("hostname", hostname);
        model.addAttribute("namespace", namespace);
		model.addAttribute("clusterName", clusterName != null ? clusterName : "Unknown-Cluster");
		model.addAttribute("clusterId", clusterId != null ? clusterId : "Unknown-ID");

	return "index"; // /WEB-INF/index.jsp
    }

    @GetMapping("/health")
    @ResponseBody
    public String health() {
        return "OK";
    }

}
