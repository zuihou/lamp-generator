package com.tangyh.lamp.generator.config;


import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.generator.config.po.LikeTable;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.EntityFiledType;
import com.tangyh.lamp.generator.type.EntityType;
import com.tangyh.lamp.generator.type.SuperClass;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.experimental.Accessors;

import java.io.File;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 代码生成配置
 * <p>
 * 微服务项目默认会创建4个项目，
 * cloud-authority-api、cloud-authority-rest、cloud-authority-entity、cloud-authority-repository
 * 匹配符为：${projectPrefix}${serviceName}-${apiSuffix}
 * <p>
 * 然后在每个项目的src/main/java下创建包：
 * ${packageBase}.api.${childModuleName}
 * ${packageBase}.rest.${childModuleName}
 * ${packageBase}.entity.${childModuleName}
 * ${packageBase}.enumeration.${childModuleName}
 * ${packageBase}.constant.${childModuleName}
 * ${packageBase}.dto.${childModuleName}
 * ${packageBase}.service.${childModuleName}
 * ${packageBase}.service.${childModuleName}.impl
 * ${packageBase}.dao.${childModuleName}
 * ${projectPrefix}${serviceName}-${serviceSuffix}项目的src/main/resource下创建包：
 * mapper_${serviceName}.base.${childModuleName}
 *
 * @author zuihou
 * @date 2019年05月25日20:59:57
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@Accessors(chain = true)
public class CodeGeneratorConfig {

    /**
     * 项目跟路径
     */
    String projectRootPath = System.getProperty("user.dir");
    /**
     * 服务名
     * 如消息服务 (用于创建cloud-%s-api、cloud-%s-entity等项目)
     */
    String serviceName = "";
    /**
     * 子模块名称
     * 如消息服务(cloud-msgs-new)包含消息、短信、邮件3个模块
     * 则分别填入 msgs、sms、email
     * (用于创建cloud-%s-rest、cloud-%s-repository等项目)
     */
    String childModuleName = "";
    /**
     * 子模块是否单独生成 lamp-{childModuleName}-entity模块
     */
    Boolean isGenEntity = false;
    /**
     * 是否lamp-boot
     */
    Boolean isBoot = false;

    /**
     * 基础包   所有的代码都放置在这个包之下
     */
    String packageBase = "com.tangyh.lamp.authority";
    /**
     * 子包名称
     * 会在api、controller、service、serviceImpl、dao、entity等包下面创建子包
     */
    String childPackageName = "";
    /**
     * 作者
     */
    String author = "zuihou";
    /**
     * 项目统一前缀  比如：  cloud-
     */
    private String projectPrefix = "lamp-";

    private String apiSuffix = "-api";
    private String entitySuffix = "-entity";
    private String serviceSuffix = "-biz";
    private String controllerSuffix = "-controller";
    /**
     * 版本
     */
    String version = "1.0-SNAPSHOT";
    /**
     * 端口号
     */
    String serverPort = "8080";
    String groupId = "com.tangyh.lamp";
    String description = "服务";
//    private String serverSuffix = "-server";

    public String getPackageBaseParent() {
        return StrUtil.subPre(this.packageBase, this.packageBase.lastIndexOf("."));
    }

    /**
     * entity的父类
     */
    private EntityType superEntity = EntityType.ENTITY;
    /**
     * controller的父类
     */
    private String superControllerClass = SuperClass.SUPER_CLASS.getController();

    /**
     * 自定义继承的Mapper类全称，带包名
     */
    private String superMapperClass = SuperClass.SUPER_CLASS.getMapper();
    /**
     * 自定义继承的Service类全称，带包名
     */
    private String superServiceClass = SuperClass.SUPER_CLASS.getService();
    /**
     * 自定义继承的ServiceImpl类全称，带包名
     */
    private String superServiceImplClass = SuperClass.SUPER_CLASS.getServiceImpl();
    /**
     * 表前缀
     */
    private String tablePrefix = "";
    /**
     * 字段前缀
     */
    private String fieldPrefix = "";
    /**
     * 需要包含的表名，允许正则表达式；用来自动生成代码
     */
    private String[] tableInclude = {"c_user"};
    /**
     * 排除那些表
     */
    private String[] tableExclude = {};

    /**
     * 包含表名
     *
     * @since 3.3.0
     */
    private LikeTable likeTable;
    /**
     * 不包含表名
     *
     * @since 3.3.0
     */
    private LikeTable notLikeTable;

    /**
     * 驱动连接的URL
     */
    private String url = "jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull";
    /**
     * 驱动名称
     */
    private String driverName = "com.mysql.cj.jdbc.Driver";
    /**
     * 数据库连接用户名
     */
    private String username = "root";
    /**
     * 数据库连接密码
     */
    private String password = "root";
    /**
     * 仅仅在微服务架构下面才进行分包
     */
    private boolean enableMicroService = true;

    private FileCreateConfig fileCreateConfig = new FileCreateConfig();
    /**
     * 需要制定生成路径的枚举类列表
     */
    private Set<EntityFiledType> filedTypes = new HashSet<>();

    private Vue vue = new Vue();

    @Data
    public static class Vue {
        private String viewsPath = "views" + File.separator + "lamp";

        /**
         * 表名 - <字段名 - 字段信息>
         */
        private Map<String, Map<String, GenTableColumn>> tableFieldMap = new HashMap<>();
    }

    /**
     * 必填项 构造器
     *
     * @param serviceName     服务名
     *                        eg： msgs
     * @param childModuleName 子模块名
     *                        eg: sms、emial
     * @param author          作者
     * @param tablePrefix     表前缀
     * @param tableInclude    生成的表 支持通配符
     *                        eg： msgs_.* 会生成msgs_开头的所有表
     * @return
     */
    public static CodeGeneratorConfig build(String serviceName, String childModuleName, String author, String tablePrefix, List<String> tableInclude) {
        CodeGeneratorConfig config = new CodeGeneratorConfig();
        config.setServiceName(serviceName).setAuthor(author).setTablePrefix(tablePrefix)
                .setTableInclude(tableInclude.stream().toArray(String[]::new))
                .setChildModuleName(childModuleName == null ? "" : childModuleName);
        config.setPackageBase("com.tangyh.lamp." + config.getChildModuleName());
        return config;
    }


    public static CodeGeneratorConfig buildVue(String serviceName, String tablePrefix, List<String> tableInclude) {
        CodeGeneratorConfig config = new CodeGeneratorConfig();
        config.setServiceName(serviceName).setTablePrefix(tablePrefix)
                .setTableInclude(tableInclude.stream().toArray(String[]::new))
                .setChildModuleName("");
        config.setPackageBase("com.tangyh.lamp." + config.getChildModuleName());
        return config;
    }

    public String getChildModuleName() {
        if (StringUtils.isBlank(this.childModuleName)) {
            this.childModuleName = this.serviceName;
        }
        return this.childModuleName;
    }
}
