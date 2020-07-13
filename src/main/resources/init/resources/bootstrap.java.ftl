# @xxx@ 从pom.xml中取值, 所以 @xx@ 标注的值，都不能从nacos中获取
zuihou:
  nacos:
    ip: ${r"${"}NACOS_IP:@nacos.ip@${r"}"}
    port: ${r"${"}NACOS_PORT:@nacos.port@${r"}"}
    namespace: ${r"${"}NACOS_ID:@nacos.namespace@${r"}"}
    username: ${r"${"}NACOS_ID:@nacos.username@${r"}"}
    password: ${r"${"}NACOS_ID:@nacos.password@${r"}"}

spring:
  main:
    allow-bean-definition-overriding: true
  application:
    name: @project.artifactId@
  profiles:
    active: @profile.active@
  cloud:
    nacos:
      config:
        server-addr: ${r"${"}zuihou.nacos.ip${r"}"}:${r"${"}zuihou.nacos.port${r"}"}
        file-extension: yml
        namespace: ${r"${"}zuihou.nacos.namespace${r"}"}
        shared-configs:
          - dataId: common.yml
            refresh: true
          - dataId: redis.yml
            refresh: false
          - dataId: mysql.yml
            refresh: true
          - dataId: rabbitmq.yml
            refresh: false
        enabled: true
        username: ${r"${"}zuihou.nacos.username${r"}"}
        password: ${r"${"}zuihou.nacos.password${r"}"}
      discovery:
        username: ${r"${"}zuihou.nacos.username${r"}"}
        password: ${r"${"}zuihou.nacos.password${r"}"}
        server-addr: ${r"${"}zuihou.nacos.ip}:${r"${"}zuihou.nacos.port${r"}"}
        namespace: ${r"${"}zuihou.nacos.namespace${r"}"}
        metadata: # 元数据，用于权限服务实时获取各个服务的所有接口
          management.context-path: ${r"${"}server.servlet.context-path:${r"}"}${r"${"}spring.mvc.servlet.path:${r"}"}${r"${"}management.endpoints.web.base-path:${r"}"}

# 只能配置在bootstrap.yml ，否则会生成 log.path_IS_UNDEFINED 文件夹
# window会自动在 代码所在盘 根目录下自动创建文件夹，  如： D:/data/projects/logs
logging:
  file:
    path: @logging.file.path@
    name: ${r"${"}logging.file.path${r"}"}/${r"${"}spring.application.name}/root.log

# 用于/actuator/info
info:
  name: '@project.name@'
  description: '@project.description@'
  version: '@project.version@'
