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
    <#if isChildModule>
    <artifactId>${projectPrefix}${childModuleName}-controller</artifactId>
    <#else>
    <artifactId>${projectPrefix}${serviceName}-controller</artifactId>
    </#if>
    <name>${r"${"}project.artifactId${r"}"}</name>
    <description>${description}-控制器模块</description>

    <dependencies>
        <dependency>
            <groupId>${groupId}</groupId>
            <#if isChildModule>
            <artifactId>${projectPrefix}${childModuleName}-biz</artifactId>
            <#else>
            <artifactId>${projectPrefix}${serviceName}-biz</artifactId>
            </#if>
        </dependency>

        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-security-starter</artifactId>
        </dependency>
        <dependency>
            <groupId>com.github.zuihou</groupId>
            <artifactId>zuihou-log-starter</artifactId>
        </dependency>
    </dependencies>


</project>
