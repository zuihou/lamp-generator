# lamp 快速开发平台

[![AUR](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg)](https://github.com/zuihou/lamp-cloud/blob/master/LICENSE)
[![](https://img.shields.io/badge/作者-zuihou-orange.svg)](https://github.com/zuihou)
[![](https://img.shields.io/badge/版本-3.0.2-brightgreen.svg)](https://github.com/zuihou/lamp-cloud)
[![GitHub stars](https://img.shields.io/github/stars/zuihou/lamp-cloud.svg?style=social&label=Stars)](https://github.com/zuihou/lamp-cloud/stargazers)
[![star](https://gitee.com/zuihou111/lamp-cloud/badge/star.svg?theme=white)](https://gitee.com/zuihou111/lamp-cloud/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/zuihou/lamp-cloud.svg?style=social&label=Fork)](https://github.com/zuihou/lamp-cloud/network/members)
[![fork](https://gitee.com/zuihou111/lamp-cloud/badge/fork.svg?theme=white)](https://gitee.com/zuihou111/lamp-cloud/members)

# lamp 项目名字由来
## 叙事版：
在一个夜黑风高的晚上，小孩吵着要出去玩，于是和`程序员老婆`一起带小孩出去放风，路上顺便讨论起项目要换个什么名字，在各自想出的名字都被对方一一否决后，大家陷入了沉思。
走着走着，在一盏路灯下，孩砸盯着路灯打破宁静，喊出：灯灯～ 我和媳妇愣了一下，然后对视着一起说：哈哈，这个名字好～

## 解释版：
`灯灯`： 是我小孩学说话时会说的第一个词，也是我在想了很多项目名后，小孩一语点破的一个名字，灯灯象征着光明，给困境的我们带来希望，给加班夜归的程序员们指引前方～

`灯灯`(简称灯， 英文名：lamp)，他是一个项目的统称，包含以下几个子项目

## lamp 项目组成
| 项目 | gitee | github | 备注 |
|---|---|---|---|
| 工具集 | https://gitee.com/zuihou111/lamp-util | https://github.com/zuihou/lamp-util | 业务无关的工具集，cloud和boot 项目都依赖它 |
| 微服务版 | https://gitee.com/zuihou111/lamp-cloud | https://github.com/zuihou/lamp-cloud | SpringCloud 版 |
| 单体版 | https://gitee.com/zuihou111/lamp-boot | https://github.com/zuihou/lamp-boot | SpringBoot 版(和lamp-cloud功能基本一致)|
| 租户后台 | https://gitee.com/zuihou111/lamp-web | https://github.com/zuihou/lamp-web | PC端管理系统 |
| 代码生成器 | https://gitee.com/zuihou111/lamp-generator | https://github.com/zuihou/lamp-generator | 给开发人员使用 |
| 定时调度器 | https://gitee.com/zuihou111/lamp-jobs | https://github.com/zuihou/lamp-jobs | 尚未开发 |

# lamp-generator 简介
`lamp-generator` 的前身是 `zuihou-generator`，在3.0.0版本之后，改名为lamp-generator，它是`lamp`项目的其中一员。

`lamp-generator`是基于 `mybatis-plus-generator` 自定义的代码生成器，专门为 [lamp-cloud](https://github.com/zuihou/lamp-cloud "lamp-cloud") 和 [lamp-cloud](https://github.com/zuihou/lamp-boot "lamp-boot") 项目量身定做的代码生成器。
自定义的代码规范、可读性差了一些，但还能凑合着用。因为主角是：[lamp-cloud](https://github.com/zuihou/lamp-cloud "lamp-cloud")

## 使用规则

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


## 数据库设计原则

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


# 如果觉得对您有任何一点帮助，请点右上角 "Star" 支持一下吧，谢谢！

# [点我详细查看如何使用本项目来生成代码](https://www.kancloud.cn/zuihou/zuihou-admin-cloud) 

    ps: gitee捐献 或者 二维码打赏(本页最下方)： 45元及以上 并 备注邮箱，可得开发文档一份(支持后续更新)
    打赏或者捐献后直接加群：1039545140 并备注打赏时填写的邮箱，可以持续的获取最新的文档。 

# 会员版
本项目分为开源版、会员版，github和gitee上能搜索到的为开源版本，遵循Apache协议。 会员版源码在私有gitlab托管，购买后开通账号。

会员版和会员版区别请看：[会员版](会员版.md)

# lamp 会员版项目演示地址 
- 地址： http://tangyh.top:10000/lamp-web/
- 以下内置账号仅限于内置的0000租户 
- 平台管理员： lamp_pt/lamp (内置给公司内部运营人员使用)
- 超级管理员： lamp/lamp    
- 普通管理员： general/lamp
- 普通账号： normal/lamp

# 友情链接 & 特别鸣谢
* SaaS型微服务快速开发平台：[https://github.com/zuihou/lamp-cloud](https://github.com/zuihou/lamp-cloud)
* SaaS型单体快速开发平台：[https://github.com/zuihou/lamp-boot](https://github.com/zuihou/lamp-boot)
* MyBatis-Plus：[https://mybatis.plus/](https://mybatis.plus/)
* knife4j：[http://doc.xiaominfo.com/](http://doc.xiaominfo.com/)
* hutool：[https://hutool.cn/](https://hutool.cn/)
* xxl-job：[http://www.xuxueli.com/xxl-job/](http://www.xuxueli.com/xxl-job/)
* kkfileview：[https://kkfileview.keking.cn](https://kkfileview.keking.cn)
* FEBS Cloud Web： [https://gitee.com/mrbirdd/FEBS-Cloud-Web](https://gitee.com/mrbirdd/FEBS-Cloud-Web)
    lamp-web 基于本项目改造， 感谢 [wuyouzhuguli](https://github.com/wuyouzhuguli)
* Cloud-Platform： [https://gitee.com/geek_qi/cloud-platform](https://gitee.com/geek_qi/cloud-platform)
    作者学习时接触到的第一个微服务项目
