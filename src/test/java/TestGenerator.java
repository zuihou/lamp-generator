import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import com.github.zuihoou.generator.CodeGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.config.FileCreateConfig;
import com.github.zuihoou.generator.type.EntityFiledType;
import com.github.zuihoou.generator.type.EntityType;
import com.github.zuihoou.generator.type.GenerateType;

/**
 * 测试代码生成
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class TestGenerator {
    /***
     * 注意，想要在这里直接运行，需要手动增加 mysql 驱动
     * @param args
     */
    public static void main(String[] args) {
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("demo", "", "zuihou", "m_",
                        Arrays.asList("m_order"));
        build.setUrl("jdbc:mysql://127.0.0.1:3306/zuihou_demo_dev?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
//        build.setPassword("root");
        build.setProjectRootPath(System.getProperty("user.dir") + "/zuihou-backend/zuihou-demo");

//        FileCreateConfig fileCreateConfig = new FileCreateConfig(null);
        FileCreateConfig fileCreateConfig = new FileCreateConfig(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateEntity(GenerateType.OVERRIDE);
        fileCreateConfig.setGenerateEnum(GenerateType.IGNORE);
        fileCreateConfig.setGenerateDto(GenerateType.IGNORE);
        fileCreateConfig.setGenerateXml(GenerateType.IGNORE);
        fileCreateConfig.setGenerateDao(GenerateType.IGNORE);
        fileCreateConfig.setGenerateServiceImpl(GenerateType.IGNORE);
        fileCreateConfig.setGenerateService(GenerateType.IGNORE);
        fileCreateConfig.setGenerateController(GenerateType.IGNORE);

        build.setFileCreateConfig(fileCreateConfig);

        build.setChildPackageName("");
        build.setSuperEntity(EntityType.ENTITY);

        //手动指定枚举类 生成的路径
        Set<EntityFiledType> filedTypes = new HashSet<>();
        filedTypes.addAll(Arrays.asList(
//                EntityFiledType.builder().name("status").packagePath("com.github.zuihou.msgs.enumeration.TaskStatus").build(),
        ));
        build.setFiledTypes(filedTypes);
        CodeGenerator.main(build);
    }
}
