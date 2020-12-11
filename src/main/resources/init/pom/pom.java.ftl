<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>${groupId}</groupId>
        <#if !isBoot>
        <artifactId>${projectPrefix}cloud</artifactId>
        <#else >
        <artifactId>${projectPrefix}boot</artifactId>
        </#if>
        <version>${version}</version>
        <relativePath>../pom.xml</relativePath>
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <artifactId>${projectPrefix}${serviceName}</artifactId>
    <name>${r"${"}project.artifactId${r"}"}</name>
    <description>${description}服务</description>
    <packaging>pom</packaging>

    <modules>
        <#if !isBoot>
        <module>${projectPrefix}${serviceName}-api</module>
        <module>${projectPrefix}${serviceName}-server</module>
        <module>${projectPrefix}${serviceName}-entity</module>
        <module>${projectPrefix}${serviceName}-biz</module>
        <module>${projectPrefix}${serviceName}-controller</module>
        <#else >
        <module>${projectPrefix}${childModuleName}-entity</module>
        <module>${projectPrefix}${childModuleName}-biz</module>
        <module>${projectPrefix}${childModuleName}-controller</module>
        </#if>
    </modules>



</project>
