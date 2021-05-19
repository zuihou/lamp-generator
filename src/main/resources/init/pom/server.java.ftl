<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <parent>
        <artifactId>${projectPrefix}-${serviceName}</artifactId>
        <groupId>${groupId}</groupId>
        <version>${version}</version>
        <relativePath>../pom.xml</relativePath>
    </parent>

    <modelVersion>4.0.0</modelVersion>
    <artifactId>${projectPrefix}-${serviceName}-server</artifactId>
    <name>${r"${"}project.artifactId${r"}"}</name>
    <description>${description}-启动模块</description>

    <dependencies>
        <dependency>
            <groupId>${groupId}</groupId>
            <artifactId>${projectPrefix}-${serviceName}-controller</artifactId>
            <version>${r"${"}lamp-project.version${r"}"}</version>
        </dependency>

        <dependency>
            <groupId>com.tangyh.basic</groupId>
            <artifactId>lamp-all</artifactId>
        </dependency>

        <dependency>
            <groupId>cn.afterturn</groupId>
            <artifactId>easypoi-spring-boot-starter</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>

    <build>
        <filters>
            <filter>../../src/main/filters/config-${r"${"}profile.active${r"}"}.properties</filter>
        </filters>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
                <executions>
                    <execution>
                        <goals>
                            <goal>repackage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>

            <!-- docker打包插件 -->
            <plugin>
                <groupId>com.spotify</groupId>
                <artifactId>dockerfile-maven-plugin</artifactId>
                <version>${r"${"}dockerfile-maven-plugin.version${r"}"}</version>
                <configuration>
                    <repository>${r"${"}docker.image.prefix${r"}"}/${r"${"}project.artifactId${r"}"}</repository>
                    <tag>${r"${"}lamp-project.version${r"}"}</tag>
                    <buildArgs>
                        <JAR_FILE>target/${r"${"}project.build.finalName${r"}"}.jar</JAR_FILE>
                    </buildArgs>
                </configuration>
            </plugin>

        </plugins>
    </build>
</project>
