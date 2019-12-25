# 简介

基于 `mybatis-plus-generator` 自定义的代码生成器，专门为 [zuihou-admin-cloud](https://github.com/zuihou/zuihou-admin-cloud "zuihou") 项目量身定做的代码生成器。
自定义的代码虽然有点不美观但还凑合着用。因为主角是：[zuihou-admin-cloud](https://github.com/zuihou/zuihou-admin-cloud "zuihou")

参考：[mybatis-plus](https://github.com/baomidou/mybatis-plus "zuihou")

# 项目地址
| 项目 | gitee | github | 备注 |
|---|---|---|---|
| 微服务项目 | https://gitee.com/zuihou111/zuihou-admin-cloud | https://github.com/zuihou/zuihou-admin-cloud | SpringCloud 版本 |
| 单体项目 | https://gitee.com/zuihou111/zuihou-admin-boot | https://github.com/zuihou/zuihou-admin-boot | SpringBoot 版本 |
| 租户后台 | https://gitee.com/zuihou111/zuihou-ui | https://github.com/zuihou/zuihou-ui | 给客户使用 |
| 开发&运营后台 | https://gitee.com/zuihou111/zuihou-admin-ui | https://github.com/zuihou/zuihou-admin-ui | 给公司内部开发&运营&运维等人员使用 |
| 代码生成器 | 无 | https://github.com/zuihou/zuihou-generator | 给开发人员使用 |


# 使用规则
- 暂时只支持生成MySQL表，Oracle需要微调代码，有需要的可以留言提交上来
- 参考 TestGenerator 类
- 每次执行前需配置参数，含代码生成目录(本地绝对目录)，数据库连接，项目名、模块名，表列表等。目前已提供模板。
- 如果表有前缀，务必配置 tablePrefix 属性。
    例如：表名为f_file，则需要进行下列配置，生成的类会自动排除掉f_前缀。
    new CodeGeneratorConfig().setTablePrefix("f_");
- serviceName、childModuleName、childPackageName的区别
    serviceName： 表示`服务名` ，如 zuihou-file 服务，就填 file  
    childModuleName： 表示`模块名` ，如 zuihou-msgs 服务下面分为  zuihou-msgs、zuihou-sms、zuihou-email等， 在生成sms、email等模块时，就需要指定为 sms、email  
    childPackageName的区别： 表示`子包名` ，用于在服务下，进行分包。如 zuihou-authority 项目下有 auth、common、core等子包
- 支持枚举类型改变存储路径。 参考CodeGeneratorConfig.setFiledTypes
- 支持controller、service、dao、xml等各个模块 自定义生成策略： 覆盖、新增、忽略。参考：FileCreateConfig config = new FileCreateConfig(GenerateType.OVERRIDE);


# 数据库设计原则
- 必须显式指定`主键`
- 任何表至少包含3个字段： bigint id、 datetime createTime、bigint createUpdate (可以自行修改 EntityType)
- 表、字段 必须加注释
- 表名注释支持换行，第一行会被视为表名。 表的介绍请换行填写。
- 字段的第一行视为字段简介，详细介绍和枚举类型请换行
- 所有字段尽量根据业务设置合理的`缺省值`，尽量避免表中出现 NULL值
- 当字段为外键时，字段名为： 关联表_id， 注释需要在字段注释基础上，换行加上 `#关联表表名` 来说明关联的哪张表。（注意英文#号）
- 当字段为枚举时，需按照模板配置：
```
    (注意： 注释内容 需要替换成当前字段的具体注释)
    
    注释模板1： 注释内容 #枚举类名{枚举值英文名:"枚举值英文注释";  ...}
    注释模板2： 注释内容 #枚举类名{枚举值英文名:val,"枚举值英文注释";  ...}
    注释模板3： 注释内容 #枚举类名{枚举值英文名:val,"枚举值英文注释",val2;  ...}
    注释模板4： 注释内容 #{枚举值英文名:"枚举值英文注释";  ...}
    其中枚举类名可以没有，如果没有，则生成的枚举值名为：表对应的实体名 + 当前字段对应的属性名(首字母大写) + Enum 
    枚举值例子：
        文件类型 #FileType{PAN:云盘数据;API:接口数据}
        数据类型 #DataType{DIR:1,目录;IMAGE:2,图片;VIDEO:3,视频;AUDIO:4,音频;DOC:5,文档;OTHER:6,其他}
        数据类型 #{DIR:目录;IMAGE:图片;VIDEO:视频;AUDIO:音频;DOC:文档;OTHER:其他}
```

完整例子：
```
CREATE TABLE `zuihou_file_dev`.`f_file`  (
  `id` bigint(20) NOT NULL COMMENT '主键',
  `data_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT 'IMAGE' COMMENT '数据类型\n#DataType{DIR:目录;IMAGE:图片;VIDEO:视频;AUDIO:音频;DOC:文档;OTHER:其他}',
  `submitted_file_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '原始文件名',
  `tree_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT ',' COMMENT '父目录层级关系',
  `grade` int(11) NULL DEFAULT 1 COMMENT '层级等级\n从1开始计算',
  `is_delete` bit(1) NULL DEFAULT b'0' COMMENT '是否删除\n#BooleanStatus{TRUE:1,已删除;FALSE:0,未删除}',
  `folder_id` bigint(20) NULL DEFAULT 0 COMMENT '父文件夹ID',
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件访问链接\n需要通过nginx配置路由，才能访问',
  `size` bigint(20) NULL DEFAULT 0 COMMENT '文件大小\n单位字节',
  `folder_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '父文件夹名称',
  `group_` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'FastDFS组\n用于FastDFS',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'FastDFS远程文件名\n用于FastDFS',
  `relative_path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件的相对路径 ',
  `file_md5` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT 'md5值',
  `context_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件类型\n取上传文件的值',
  `filename` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '唯一文件名',
  `ext` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件名后缀 \n(没有.)',
  `icon` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '文件图标\n用于云盘显示',
  `create_month` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时年月\n格式：yyyy-MM 用于统计',
  `create_week` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时年周\nyyyy-ww 用于统计',
  `create_day` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建时年月日\n格式： yyyy-MM-dd 用于统计',
  `create_time` datetime(0) NULL DEFAULT NULL COMMENT '创建时间',
  `create_user` bigint(20) NULL DEFAULT NULL COMMENT '创建人',
  `update_time` datetime(0) NULL DEFAULT NULL COMMENT '最后修改时间',
  `update_user` bigint(20) NULL DEFAULT NULL COMMENT '最后修改人',
  PRIMARY KEY (`id`) USING BTREE,
  FULLTEXT INDEX `FU_TREE_PATH`(`tree_path`)
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '文件表' ROW_FORMAT = Dynamic;
```
- 
