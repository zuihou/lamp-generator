package cloud;

import com.tangyh.lamp.generator.ProjectGenerator;
import com.tangyh.lamp.generator.config.CodeGeneratorConfig;
import lombok.extern.slf4j.Slf4j;

/**
 * 生成lamp-cloud项目的新服务或新模块
 *
 * @author zuihou
 * @date 2019/05/25
 */
@Slf4j
public class TestInitProject {

    public static void main(String[] args) {
        CodeGeneratorConfig config = new CodeGeneratorConfig();
        String path = "/Users/tangyh/github/lamp-examples";
        config
                // lamp-cloud 项目的 绝对路径！ 路径只能到lamp-cloud级
                .setProjectRootPath(path)
                // lamp-cloud 项目的前缀 若你的项目修改成了其他，则需要通过这里改前缀
                .setProjectPrefix("lamp")

                // 需要新建的 服务名      该例会生成 lamp-test 服务
                // 不能有中横线(-) ,最好不要有大写
                .setServiceName("noneMultipleDataSources")

                // 首次新建服务时，设置为空字符串
                // 然后想新建子模块时，可以设置成子模块名  如：msg 服务下的 sms 模块即 视为子模块
//                .setChildModuleName("man")

                // 子模块是否需要生成entity模块
                .setIsGenEntity(true)
                // 是否lamp-boot项目
                .setIsBoot(false)

                // 生成代码的开发人员Git账号
                .setAuthor("zuihou")
                // 项目描述
                .setDescription("None模式多数据源示例")
                // 项目的版本， 一定要跟 lamp-cloud 下的其他服务版本一致， 否则会出错哦
                .setVersion("3.2.1-SNAPSHOT")
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
