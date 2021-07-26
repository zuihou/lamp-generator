package cloud.biz;

import top.tangyh.lamp.generator.CodeGenerator;
import top.tangyh.lamp.generator.config.CodeGeneratorConfig;
import top.tangyh.lamp.generator.config.FileCreateConfig;
import top.tangyh.lamp.generator.type.EntityFiledType;
import top.tangyh.lamp.generator.type.EntityType;
import top.tangyh.lamp.generator.type.GenerateType;

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
public class TestAuthorityCodeGenerator {
    public static void main(String[] args) {
        CodeGeneratorConfig build = buildAuthEntity();
        // 项目、配置文件的前缀
        build.setProjectPrefix("lamp");
        // lamp-cloud 或者 lamp-boot 项目的 包
        build.setGroupId("top.tangyh.lamp");
        // lamp-util 项目的 包
        build.setUtilPackage("top.tangyh.basic");
//        CodeGeneratorConfig build = buildManEntity();

        //mysql 账号密码
        build.setUsername("root");
        build.setPassword("root");
        build.setIsBoot(false);

        String path = "/Users/tangyh/gitlab/lamp-cloud-plus/lamp-authority";
        System.out.println("输出路径：" + path);
        build.setProjectRootPath(path);

        // 指定全部代码的生成策略
        GenerateType generate = GenerateType.OVERRIDE;
//        generate = null;
        // 构造器传入null，下面设置的策略（setGenerate*）才会生效， 构造器传入不为null时，下面设置的策略（setGenerate*）无效，将全部使用构造器传入的策略
        FileCreateConfig fileCreateConfig = new FileCreateConfig(generate);
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
//                        .packagePath("top.tangyh.lamp.common.enums.HttpMethod").gen(GenerateType.IGNORE).build()
        ));
        build.setFiledTypes(filedTypes);

        build.setPackageBase(build.getGroupId() + "." + build.getChildModuleName());

        // 运行
        CodeGenerator.run(build);
    }

    public static CodeGeneratorConfig buildDefaultsEntity() {
        List<String> tables = Arrays.asList(
                "d_global_user",
                "d_tenant"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "d_", tables);
        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("defaults");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_defaults?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    private static CodeGeneratorConfig buildAuthEntity() {
        List<String> tables = Arrays.asList(
//                "c_user_token"
//                , "c_application"
//                , "c_resource"
//                , "c_role"
                 "c_user"
//                "c_menu"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_", tables);
//                build("authority", "", "zuihou", "c_", tables);
        build.setSuperEntity(EntityType.ENTITY);
//        build.setSuperEntity(EntityType.TREE_ENTITY);
        build.setChildPackageName("auth");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_none?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    public static CodeGeneratorConfig buildAuthSuperEntity() {
        List<String> tables = Arrays.asList(
                "c_role_authority"
                , "c_role_org"
                , "c_user_role"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_", tables);
        build.setSuperEntity(EntityType.SUPER_ENTITY);
        build.setChildPackageName("auth");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    private static CodeGeneratorConfig buildCommonEntity() {
        List<String> tables = Arrays.asList(
                "c_area"
//                "c_parameter"
//                 "c_dictionary"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_", tables);

        build.setSuperEntity(EntityType.TREE_ENTITY);
//        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("common");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_none?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    public static CodeGeneratorConfig buildCommonSuperEntity() {
        List<String> tables = Arrays.asList(
                "c_opt_log", "c_opt_log_ext", "c_login_log"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_", tables);
        build.setSuperEntity(EntityType.SUPER_ENTITY);
        build.setChildPackageName("common");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

    public static CodeGeneratorConfig buildCoreEntity() {
        List<String> tables = Arrays.asList(
//                "c_org"
                "c_station"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_", tables);
//        build.setSuperEntity(EntityType.TREE_ENTITY);
        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("core");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_none?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }
}
