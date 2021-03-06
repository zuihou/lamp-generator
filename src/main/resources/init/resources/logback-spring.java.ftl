<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <!-- 服务器运行时，在bootstrap.yml中通过 logging.config=classpath:logback-spring.xml文件，
      表示服务器运行时，日志异步打印出来，增加服务器的效率 -->
    <include resource="logback/defaults-async.xml"/>

    <logger name="${packageBase}.controller" additivity="true" level="${r"${"}log.level.controller${r"}"}">
        <appender-ref ref="ASYNC_CONTROLLER_APPENDER"/>
    </logger>
    <logger name="${packageBase}.service" additivity="true" level="${r"${"}log.level.service${r"}"}">
        <appender-ref ref="ASYNC_SERVICE_APPENDER"/>
    </logger>
    <logger name="${packageBase}.dao" additivity="false" level="${r"${"}log.level.dao${r"}"}">
        <appender-ref ref="ASYNC_DAO_APPENDER"/>
    </logger>
</configuration>
