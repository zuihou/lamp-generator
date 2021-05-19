<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <!-- 本地开发时，在bootstrap-xxx.yml中通过 logging.config=classpath:logback-spring-dev.xml 文件，表示本地的日志实时打印出来 -->
    <include resource="logback/defaults-sync.xml"/>

    <logger name="${packageBase}.controller" additivity="true" level="${r"${"}log.level.controller${r"}"}">
        <appender-ref ref="CONTROLLER_APPENDER"/>
    </logger>
    <logger name="${packageBase}.service" additivity="true" level="${r"${"}log.level.service${r"}"}">
        <appender-ref ref="SERVICE_APPENDER"/>
    </logger>
</configuration>
