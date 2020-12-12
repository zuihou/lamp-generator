package cloud.biz;

import com.tangyh.lamp.generator.CodeGenerator;
import com.tangyh.lamp.generator.config.CodeGeneratorConfig;
import com.tangyh.lamp.generator.config.FileCreateConfig;
import com.tangyh.lamp.generator.type.EntityFiledType;
import com.tangyh.lamp.generator.type.EntityType;
import com.tangyh.lamp.generator.type.GenerateType;
import com.tangyh.lamp.generator.type.SuperClass;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 测试代码生成权限系统的代码
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class TestTenantCodeGenerator {
    /***
     * 注意，想要在这里直接运行，需要手动增加 mysql 驱动
     * @param args
     */
    public static void main(String[] args) {
        CodeGeneratorConfig build = buildTenantEntity();

        //mysql 账号密码
        build.setUsername("root");
        build.setPassword("root");

//        String path = System.getProperty("user.dir");
        String path = "/Users/tangyh/gitee/lamp-cloud-plus/lamp-tenant";
        System.out.println("输出路径：");
        System.out.println(path);
        build.setProjectRootPath(path);
        build.setProjectPrefix("lamp-");
        // 指定全部代码的生成策略
        GenerateType generate = GenerateType.OVERRIDE;
        generate = null;
        FileCreateConfig fileCreateConfig = new FileCreateConfig(generate);
        // generate 为null时，下面设置的策略才会生效， generate 不为null时，全部使用generate配置的策略
        fileCreateConfig.setGenerateEntity(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateEnum(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateDto(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateXml(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateDao(GenerateType.IGNORE);
        fileCreateConfig.setGenerateServiceImpl(GenerateType.IGNORE);
        fileCreateConfig.setGenerateService(GenerateType.IGNORE);
        fileCreateConfig.setGenerateController(GenerateType.IGNORE);
        build.setFileCreateConfig(fileCreateConfig);

        //手动指定枚举类 生成的路径
        Set<EntityFiledType> filedTypes = new HashSet<>();
        filedTypes.addAll(Arrays.asList(
        ));
        build.setFiledTypes(filedTypes);

        build.setPackageBase("com.tangyh.lamp." + build.getChildModuleName());

        // 运行
        CodeGenerator.run(build);
    }


    public static CodeGeneratorConfig buildHeheEntity() {
        List<String> tables = Arrays.asList(
                "m_product"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("haha", "hehe", "zuihou", "m_", tables);
        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    /**
     * @return
     */
    private static CodeGeneratorConfig buildTenantEntity() {
        // 包含的表名
        List<String> tables = Arrays.asList(
                "c_tenant", "c_tenant_datasource_config", "c_datasource_config"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("tenant",//  服务名
                        "", // 子模块
                        "zuihou", // 作者
                        "c_", // 表前缀
                        tables);

        // 模糊匹配表名 详情查看源码：ConfigBuilder 478行
//        build.setLikeTable(new LikeTable("c\\_", SqlLike.RIGHT));
//        build.setNotLikeTable(new LikeTable("c_", SqlLike.RIGHT));

        // 排除的表
//        build.setTableExclude(Arrays.asList(""));

        // 实体父类
//        build.setSuperEntity(EntityType.TREE_ENTITY);
        build.setSuperEntity(EntityType.ENTITY);

        build.setSuperControllerClass(SuperClass.SUPER_CLASS.getController());
        build.setSuperServiceClass(SuperClass.SUPER_CLASS.getService());
        build.setSuperServiceImplClass(SuperClass.SUPER_CLASS.getServiceImpl());
        build.setSuperMapperClass(SuperClass.SUPER_CLASS.getMapper());
//        build.setSuperControllerClass(SuperClass.NONE.getController());
//        build.setSuperServiceClass(SuperClass.NONE.getService());
//        build.setSuperServiceImplClass(SuperClass.NONE.getServiceImpl());
//        build.setSuperMapperClass(SuperClass.NONE.getMapper());
//        build.setSuperControllerClass(SuperClass.SUPER_CACHE_CLASS.getController());
//        build.setSuperServiceClass(SuperClass.SUPER_CACHE_CLASS.getService());
//        build.setSuperServiceImplClass(SuperClass.SUPER_CACHE_CLASS.getServiceImpl());
//        build.setSuperMapperClass(SuperClass.SUPER_CACHE_CLASS.getMapper());

        // 子包名
        build.setChildPackageName("");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_defaults?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

        return build;
    }

    private static CodeGeneratorConfig buildMallByTreeEntity() {
        // 包含的表名
        List<String> tables = Arrays.asList(
                "m_product"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("mall",//  服务名
                        "", // 子模块
                        "zuihou", // 作者
                        "m_", // 表前缀
                        tables);

        // 模糊匹配表名 详情查看源码：ConfigBuilder 478行
//        build.setLikeTable(new LikeTable("m\\_", SqlLike.RIGHT));
//        build.setNotLikeTable(new LikeTable("c_", SqlLike.RIGHT));
//        build.setTableExclude()

        // 排除的表
//        build.setTableExclude(Arrays.asList(""));

        // 实体父类
        build.setSuperEntity(EntityType.TREE_ENTITY);
//        build.setSuperEntity(EntityType.ENTITY);

        build.setSuperControllerClass(SuperClass.SUPER_CLASS.getController());
        build.setSuperServiceClass(SuperClass.SUPER_CLASS.getService());
        build.setSuperServiceImplClass(SuperClass.SUPER_CLASS.getServiceImpl());
        build.setSuperMapperClass(SuperClass.SUPER_CLASS.getMapper());

        // 子包名
        build.setChildPackageName("");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

        return build;
    }
}
