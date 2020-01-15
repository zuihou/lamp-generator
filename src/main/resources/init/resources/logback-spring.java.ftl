<?xml version="1.0" encoding="UTF-8"?>
<configuration>

    <include resource="com/github/zuihou/log/logback/zuihou-defaults.xml"/>

    <springProfile name="test,docker,prod">
        <logger name="${packageBase}.controller" additivity="true" level="${r"${"}log.level.controller${r"}"}">
            <appender-ref ref="ASYNC_CONTROLLER_APPENDER"/>
        </logger>
        <logger name="${packageBase}.service" additivity="true" level="${r"${"}log.level.service${r"}"}">
            <appender-ref ref="ASYNC_SERVICE_APPENDER"/>
        </logger>
        <logger name="${packageBase}.dao" additivity="false" level="${r"${"}log.level.dao${r"}"}">
            <appender-ref ref="ASYNC_DAO_APPENDER"/>
        </logger>
    </springProfile>

    <springProfile name="dev">
        <logger name="${packageBase}.controller" additivity="true" level="${r"${"}log.level.controller${r"}"}">
            <appender-ref ref="CONTROLLER_APPENDER"/>
        </logger>
        <logger name="${packageBase}.service" additivity="true" level="${r"${"}log.level.service${r"}"}">
            <appender-ref ref="SERVICE_APPENDER"/>
        </logger>
    </springProfile>
</configuration>
