<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>${projectPrefix}${serviceName}</artifactId>
        <groupId>${groupId}</groupId>
        <version>${version}</version>
        <relativePath>../</relativePath>
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <artifactId>${projectPrefix}${serviceName}-entity</artifactId>
    <name>${r"${"}project.artifactId${r"}"}</name>
    <description>${description}-实体模块</description>

    <dependencies>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-common</artifactId>
        </dependency>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-injection-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.baomidou</groupId>
            <artifactId>mybatis-plus</artifactId>
        </dependency>
    </dependencies>

</project>
