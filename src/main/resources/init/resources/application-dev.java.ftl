# 开发环境需要使用p6spy进行sql语句输出
# 但p6spy会有性能损耗，不适合在生产线使用，故其他环境无需配置
spring:
  datasource:
    driver-class-name: com.p6spy.engine.spy.P6SpyDriver
    url: jdbc:p6spy:mysql://${r"${"}zuihou.mysql.ip${r"}"}:${r"${"}zuihou.mysql.port${r"}"}/${r"${"}zuihou.mysql.database${r"}"}?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull&allowMultiQueries=true
    db-type: mysql

## 请在nacos中新建一个名为: ${projectPrefix}${serviceName}-server-dev.yml 的配置文件，并将： ${projectPrefix}${serviceName}-server/src/main/resources/${projectPrefix}${serviceName}-server-dev.yml 配置文件的内容移动过去
## 然后删除此文件！！！
