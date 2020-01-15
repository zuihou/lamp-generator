import com.github.zuihoou.generator.ProjectGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import lombok.extern.slf4j.Slf4j;

/**
 * This is a Description
 *
 * @author tangyh
 * @date 2019/05/25
 */
@Slf4j
public class TestInitProject {

    public static void main(String[] args) {

        CodeGeneratorConfig config = new CodeGeneratorConfig();
        config
                .setProjectRootPath(System.getProperty("user.dir") + "/zuihou-backend")
                .setServiceName("haha")
//                .setChildModuleName("hehe")
                .setAuthor("zuihou")
                .setDescription("测试服务")
                .setVersion("1.0-SNAPSHOT")
                .setServerPort("8080")
                .setGroupId("com.github.zuihou")
        ;
        config.setPackageBase("com.github.zuihou." + config.getChildModuleName());

        System.out.println(config.getProjectRootPath());
        ProjectGenerator pg = new ProjectGenerator(config);
        pg.build();
    }
}
