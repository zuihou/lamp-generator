import com.github.zuihoou.generator.ProjectGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import lombok.extern.slf4j.Slf4j;

/**
 * 初始化项目 代码
 *
 * @author zuihou
 * @date 2019/05/25
 */
@Slf4j
public class TestInitProject {

    public static void main(String[] args) {
        CodeGeneratorConfig config = new CodeGeneratorConfig();
        config
                // zuihou-admin-cloud 项目的 绝对路径！
                .setProjectRootPath(System.getProperty("user.dir") + "/zuihou-backend")
                // 需要新建的 服务名      该例会生成 zuihou-haha 服务
                .setServiceName("haha")
                // 子模块的设置请参考 消息服务 （msgs 服务下的 sms 模块即 视为子模块）
//                .setChildModuleName("hehe")
                // 生成代码的注释 @author zuihou
                .setAuthor("zuihou")
                // 项目描述
                .setDescription("测试服务")
                // 项目的版本， 一定要跟 zuihou-backend 下的其他服务版本一致， 否则会出错哦
                .setVersion("1.0-SNAPSHOT")
                // 服务的端口号
                .setServerPort("8080")
                // 项目的 groupId
                .setGroupId("com.github.zuihou")
        ;
        // 项目的业务代码 存放的包路径
        config.setPackageBase("com.github.zuihou." + config.getChildModuleName());

        System.out.println(config.getProjectRootPath());
        ProjectGenerator pg = new ProjectGenerator(config);
        pg.build();
    }
}
