<?xml version="1.0" encoding="UTF-8"?>
<project xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xmlns="http://maven.apache.org/POM/4.0.0"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <groupId>${groupId}</groupId>
        <artifactId>${projectPrefix}admin-cloud</artifactId>
        <version>${version}</version>
        <relativePath>../</relativePath>
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <artifactId>${projectPrefix}${serviceName}</artifactId>
    <name>${r"${"}project.artifactId${r"}"}</name>
    <description>${description}服务</description>
    <packaging>pom</packaging>

    <modules>
        <module>${projectPrefix}${serviceName}-api</module>
        <module>${projectPrefix}${serviceName}-entity</module>
        <module>${projectPrefix}${serviceName}-biz</module>
        <module>${projectPrefix}${serviceName}-controller</module>
        <module>${projectPrefix}${serviceName}-server</module>
    </modules>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>${groupId}</groupId>
                <artifactId>${projectPrefix}${serviceName}-entity</artifactId>
                <version>${r"${"}zuihou-project.version${r"}"}</version>
            </dependency>
            <dependency>
                <groupId>${groupId}</groupId>
                <artifactId>${projectPrefix}${serviceName}-biz</artifactId>
                <version>${r"${"}zuihou-project.version${r"}"}</version>
            </dependency>
            <dependency>
                <groupId>${groupId}</groupId>
                <artifactId>${projectPrefix}${serviceName}-controller</artifactId>
                <version>${r"${"}zuihou-project.version${r"}"}</version>
            </dependency>
        </dependencies>
    </dependencyManagement>

</project>
