<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>${projectPrefix}${serviceName}</artifactId>
        <groupId>${groupId}</groupId>
        <version>${version}</version>
        <relativePath>../</relativePath>
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <#if isChildModule>
    <artifactId>${projectPrefix}${childModuleName}-biz</artifactId>
    <#else>
    <artifactId>${projectPrefix}${serviceName}-biz</artifactId>
    </#if>
    <name>${r"${"}project.artifactId${r"}"}</name>
    <description>${description}-业务模块</description>

    <dependencies>
        <dependency>
            <groupId>${groupId}</groupId>
            <artifactId>${projectPrefix}${serviceName}-entity</artifactId>
        </dependency>

        <dependency>
            <groupId>${groupId}</groupId>
            <artifactId>${projectPrefix}oauth-api</artifactId>
            <version>${r"${"}zuihou-project.version${r"}"}</version>
        </dependency>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-databases</artifactId>
        </dependency>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-dozer-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-j2cache-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-boot</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>

        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus</artifactId>
        </dependency>

    </dependencies>

</project>
