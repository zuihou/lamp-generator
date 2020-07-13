import com.baomidou.mybatisplus.core.enums.SqlLike;
import com.baomidou.mybatisplus.generator.config.po.LikeTable;
import com.github.zuihoou.generator.CodeGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.config.FileCreateConfig;
import com.github.zuihoou.generator.type.EntityFiledType;
import com.github.zuihoou.generator.type.EntityType;
import com.github.zuihoou.generator.type.GenerateType;
import com.github.zuihoou.generator.type.SuperClass;

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
public class TestCodeGenerator {
    /***
     * 注意，想要在这里直接运行，需要手动增加 mysql 驱动
     * @param args
     */
    public static void main(String[] args) {
//        CodeGeneratorConfig build = buildHeheEntity();
//        CodeGeneratorConfig build = buildMallEntity();
        CodeGeneratorConfig build = buildMallByTreeEntity();

        //mysql 账号密码
        build.setUsername("root");
        build.setPassword("root");

        System.out.println("输出路径：");
        System.out.println(System.getProperty("user.dir") + "/alijiujiu-mall");
        build.setProjectRootPath(System.getProperty("user.dir") + "/alijiujiu-mall");
        build.setProjectPrefix("alijiujiu-");
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
//                EntityFiledType.builder().name("httpMethod").table("c_common_opt_log")
//                        .packagePath("com.github.zuihou.common.enums.HttpMethod").gen(GenerateType.IGNORE).build()
        ));
        build.setFiledTypes(filedTypes);

        build.setPackageBase("com.alijiujiu.platform." + build.getChildModuleName());

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
        build.setUrl("jdbc:mysql://127.0.0.1:3306/zuihou_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    /**
     * @return
     */
    private static CodeGeneratorConfig buildMallEntity() {
        // 包含的表名
        List<String> tables = Arrays.asList(
//                "m_product", "m_order"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("mall",//  服务名
                        "", // 子模块
                        "zuihou", // 作者
                        "m_", // 表前缀
                        tables);

        // 模糊匹配表名 详情查看源码：ConfigBuilder 478行
        build.setLikeTable(new LikeTable("m\\_", SqlLike.RIGHT));
//        build.setNotLikeTable(new LikeTable("c_", SqlLike.RIGHT));
//        build.setTableExclude()

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
        build.setUrl("jdbc:mysql://127.0.0.1:3306/zuihou_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

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
        build.setUrl("jdbc:mysql://127.0.0.1:3306/zuihou_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

        return build;
    }
}
