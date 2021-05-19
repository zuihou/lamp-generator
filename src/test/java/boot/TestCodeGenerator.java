package boot;

import com.tangyh.lamp.generator.CodeGenerator;
import com.tangyh.lamp.generator.config.CodeGeneratorConfig;
import com.tangyh.lamp.generator.config.FileCreateConfig;
import com.tangyh.lamp.generator.type.EntityFiledType;
import com.tangyh.lamp.generator.type.EntityType;
import com.tangyh.lamp.generator.type.GenerateType;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 生成lamp-boot项目的代码
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class TestCodeGenerator {
    public static void main(String[] args) {
//        CodeGeneratorConfig build = buildMallEntity();
        CodeGeneratorConfig build = buildManEntity();

        //mysql 账号密码
        build.setUsername("root");
        build.setPassword("root");
        // 指定是boot项目
        build.setIsBoot(true);

        String path = "/Users/tangyh/github/lamp-boot/lamp-mall";
        System.out.println("输出路径：" + path);
        build.setProjectRootPath(path);
        // 项目前缀
        build.setProjectPrefix("lamp");
        // 指定全部代码的生成策略
        GenerateType generate = GenerateType.OVERRIDE;
//        generate = null;
        // 构造器传入null，下面设置的策略（setGenerate*）才会生效， 构造器传入不为null时，下面设置的策略（setGenerate*）无效，将全部使用构造器传入的策略
        FileCreateConfig fileCreateConfig = new FileCreateConfig(generate);
        fileCreateConfig.setGenerateEntity(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateEnum(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateDto(GenerateType.OVERRIDE);
        // 覆盖生成Xml
        fileCreateConfig.setGenerateXml(GenerateType.OVERRIDE);
        // 忽略生成Dao
        fileCreateConfig.setGenerateDao(GenerateType.IGNORE);
        fileCreateConfig.setGenerateServiceImpl(GenerateType.IGNORE);
        fileCreateConfig.setGenerateService(GenerateType.IGNORE);
        fileCreateConfig.setGenerateController(GenerateType.IGNORE);
        build.setFileCreateConfig(fileCreateConfig);

        //手动指定枚举类 生成的路径
        Set<EntityFiledType> filedTypes = new HashSet<>();
        filedTypes.addAll(Arrays.asList(
//                EntityFiledType.builder().name("httpMethod").table("c_common_opt_log")
//                        .packagePath("com.tangyh.lamp.common.enums.HttpMethod").gen(GenerateType.IGNORE).build()
        ));
        build.setFiledTypes(filedTypes);

        build.setPackageBase("com.tangyh.lamp." + build.getChildModuleName());

        // 运行
        CodeGenerator.run(build);
    }


    public static CodeGeneratorConfig buildMallEntity() {
        List<String> tables = Arrays.asList(
                "b_product"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("mall", "mall", "zuihou", "b_", tables);
        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_extend_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }
    public static CodeGeneratorConfig buildManEntity() {
        List<String> tables = Arrays.asList(
                "b_order"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("mall", "man", "zuihou", "b_", tables);
        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_extend_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

        build.setIsGenEntity(false);
        return build;
    }

}
