package edu.hitwh.homework;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(CorsRegistry registry) {
                registry.addMapping("/course/**") // 允许跨域访问的路径
                        .allowedOrigins("http://localhost:7000") // 允许访问的前端应用地址
                        .allowedMethods("GET", "POST", "PUT", "DELETE") // 允许的 HTTP 方法
                        .allowedHeaders("*"); // 允许的请求头
            }
        };
    }
}
