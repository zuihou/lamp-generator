package boot;

import com.tangyh.lamp.generator.ProjectGenerator;
import com.tangyh.lamp.generator.config.CodeGeneratorConfig;
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
//        String path = System.getProperty("user.dir");
        String path = "/Users/tangyh/github/lamp-boot";
        config
                // lamp-cloud 项目的 绝对路径！
                .setProjectRootPath(path)
                // 项目的前缀
                .setProjectPrefix("lamp-")

                // 需要新建的 服务名      该例会生成 lamp-mall 服务
                .setServiceName("mall")

                // 子模块的设置请参考 消息服务 （msgs 服务下的 sms 模块即 视为子模块）
                .setChildModuleName("test")

                .setIsGenEntity(true)
                .setIsBoot(true)

                // 生成代码的注释 @author zuihou
                .setAuthor("zuihou")
                // 项目描述
                .setDescription("商城")
                // 项目的版本， 一定要跟 zuihou-admin-cloud 下的其他服务版本一致， 否则会出错哦
                .setVersion("3.0.0-SNAPSHOT")
                // 服务的端口号
                .setServerPort("12080")
                // 项目的 groupId
                .setGroupId("com.tangyh.lamp")
        ;
        // 项目的业务代码 存放的包路径
        config.setPackageBase("com.tangyh.lamp." + config.getChildModuleName());

        System.out.println("项目初始化根路径：" + config.getProjectRootPath());
        ProjectGenerator pg = new ProjectGenerator(config);
        pg.build();
    }
}
