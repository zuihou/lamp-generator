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
 * This is a Description
 *
 * @author tangyh
 * @date 2019/05/25
 */
public class TestGen {
    public static void main(String[] args) {
        //
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_core_",
//                build("msgs", "sms", "tangyh", "",
                        Arrays.asList("c_core_.*"));
        build.setUrl("jdbc:mysql://127.0.0.1:3306/zuihou_core_dev?useUnicode=true&useSSL=false&characterEncoding=utf8");
//        build.setPassword("root");
        build.setProjectRootPath(System.getProperty("user.dir") + "/codeByCloud_V3.0/backend/cloud-authority-new");

        FileCreateConfig fileCreateConfig = new FileCreateConfig(null);
//        FileCreateConfig fileCreateConfig = new FileCreateConfig(GenerateType.ADD);
        fileCreateConfig.setGenerateXml(GenerateType.IGNORE);
        fileCreateConfig.setGenerateEnum(GenerateType.IGNORE);
        fileCreateConfig.setGenerateQuery(GenerateType.IGNORE);
        fileCreateConfig.setGenerateEntity(GenerateType.OVERRIDE);

        build.setFileCreateConfig(fileCreateConfig);

        build.setChildPackageName("core");
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
