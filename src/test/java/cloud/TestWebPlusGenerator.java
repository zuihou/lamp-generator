package cloud;

import cloud.column.GenTableColumnService;
import cloud.column.impl.org.GenStation;
import cloud.column.impl.org.GenUser;
import cloud.column.impl.system.GenApplication;
import cloud.column.impl.system.GenArea;
import cloud.column.impl.system.GenDictionary;
import cloud.column.impl.system.GenLoginLog;
import cloud.column.impl.system.GenOptLog;
import cloud.column.impl.system.GenParameter;
import cloud.column.impl.system.GenRole;
import cn.hutool.core.lang.Console;
import com.tangyh.lamp.generator.VueGenerator;
import com.tangyh.lamp.generator.config.CodeGeneratorConfig;
import com.tangyh.lamp.generator.config.FileCreateConfig;
import com.tangyh.lamp.generator.model.GenTableColumn;
import com.tangyh.lamp.generator.type.EntityFiledType;
import com.tangyh.lamp.generator.type.EntityType;
import com.tangyh.lamp.generator.type.GenerateType;
import com.tangyh.lamp.generator.type.VueVersion;

import java.io.File;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 生成 lamp-web 的前端代码
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class TestWebPlusGenerator {
    /***
     * 注意，想要在这里直接运行，需要手动增加 mysql 驱动
     * @param args
     */
    public static void main(String[] args) {
        // 生成前端页面，一定要设置成true
        FileCreateConfig fileCreateConfig = new FileCreateConfig(null, true, VueVersion.webplus);
//        FileCreateConfig fileCreateConfig = new FileCreateConfig(GenerateType.OVERRIDE, true);

//        CodeGeneratorConfig build = buildOrgEntity(fileCreateConfig);
        CodeGeneratorConfig build = buildSystemEntity(fileCreateConfig);

        // 项目前缀，改了影响src 下面所有的lamp文件夹
        build.setProjectPrefix("lamp");

        // 设置后台类型和ts类型的映射关系
        setMapping(build);

        //mysql 账号密码
        build.setUsername("root");
        build.setPassword("root");

        // 文件生成策略
        build.setFileCreateConfig(fileCreateConfig);

        // 前端代码的绝对路径
        String vuePath = "/Users/tangyh/gitlab/lamp-web-plus";
        build.setProjectRootPath(vuePath);
        Console.log("代码输出路径：{}", vuePath);

        //手动指定枚举类生成的路径， 不配置，则默认跟实体类平级，存放在enumeration包下
        Set<EntityFiledType> filedTypes = new HashSet<>();
        filedTypes.addAll(Arrays.asList(
        ));
        build.setFiledTypes(filedTypes);

        // 自定义前端页面字段的显示演示， 不填写时，默认生成全字段
        buildVue(build);


        //生成代码
        VueGenerator.run(build);
    }

    private static void setMapping(CodeGeneratorConfig build) {
        Map<String, String> map = new HashMap<>();
        map.put("String", "string");
        map.put("Date", "string");
        map.put("LocalDateTime", "string");
        map.put("LocalDate", "string");
        map.put("LocalTime", "string");
        map.put("Long", "string");
        map.put("Integer", "number");
        map.put("BigDecimal", "string");
        map.put("BigInteger", "string");
        map.put("Float", "number");
        map.put("Double", "number");
        map.put("Boolean", "boolean");
        map.put("Enum", "Enum");
        build.setFieldTypeMapping(map);
    }

    /**
     * 程序默认规则如下：
     * isInsert/isUpdate/isList: 排除Entity 和 SuperEntity 字段外的所有字段
     * isQuery: 字段为 必填的
     *
     * @param build
     */
    private static void buildVue(CodeGeneratorConfig build) {
        CodeGeneratorConfig.Vue vue = new CodeGeneratorConfig.Vue();
        vue.setVersion(VueVersion.webplus);

        // 生成的代码位于前端项目 src 下的什么路径？  默认是:  src/views/lamp
        vue.setViewsPath("views" + File.separator + build.getProjectPrefix());

        // 程序自动根据 表设计情况 为每个字段选择合适显示规则， 若不满足，则在此添加字段后修改即可
        Map<String, Map<String, GenTableColumn>> map = buildTableFieldMap();
        vue.setTableFieldMap(map);
        build.setVue(vue);
    }

    private static Map<String, Map<String, GenTableColumn>> buildTableFieldMap() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        List<GenTableColumnService> list = Arrays.asList(
                // org
                new GenUser(),
                new GenStation(),
                // system
                new GenApplication(),
                new GenArea(),
                new GenDictionary(),
                new GenLoginLog(),
                new GenOptLog(),
                new GenParameter(),
                new GenRole()
        );
        list.forEach(item -> map.putAll(item.map()));
        return map;
    }

    public static CodeGeneratorConfig buildOrgEntity(FileCreateConfig fileCreateConfig) {
        // 配置需要生成的表
        List<String> tables = Arrays.asList(
                "c_station",
                "c_user"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                buildVue("authority",  // 服务名 必填
                        "c_",            // 表前缀
                        tables);

//        build.setLikeTable(new LikeTable("b\\_", SqlLike.RIGHT));

        //父类是Entity
        build.setSuperEntity(EntityType.ENTITY);

        //生成的前端页面位于 src/${build.getVue().getViewsPath()}/${childPackageName} 目录下
        build.setChildPackageName("org");

        // 数据库信息
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

        fileCreateConfig.setGeneratePageIndex(GenerateType.OVERRIDE);
//        fileCreateConfig.setGenerateApi(GenerateType.OVERRIDE);
//        fileCreateConfig.setGenerateEdit(GenerateType.OVERRIDE);

        fileCreateConfig.setGenerateTreeIndex(GenerateType.IGNORE);

        // 是否生成导入导出功能以及相关的接口
        build.setIsGenerateExportApi(true);
        return build;
    }

    public static CodeGeneratorConfig buildSystemEntity(FileCreateConfig fileCreateConfig) {
        // 配置需要生成的表
        List<String> tables = Arrays.asList(
//                "c_role",
////                "c_dictionary",
//                "c_parameter",
//                "c_opt_log",
//                "c_login_log",
//                "c_application"
//                "c_area"
                "c_menu"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                buildVue("authority",  // 服务名 必填
                        "c_",            // 表前缀
                        tables);

//        build.setLikeTable(new LikeTable("b\\_", SqlLike.RIGHT));

        //父类是Entity
//        build.setSuperEntity(EntityType.ENTITY);
        build.setSuperEntity(EntityType.TREE_ENTITY);

        //生成的前端页面位于 src/${build.getVue().getViewsPath()}/${childPackageName} 目录下
        build.setChildPackageName("system");

        // 数据库信息
        build.setUrl("jdbc:mysql://127.0.0.1:3306/lamp_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");

        if (EntityType.TREE_ENTITY.eq(build.getSuperEntity())) {
            fileCreateConfig.setGeneratePageIndex(GenerateType.IGNORE);
            fileCreateConfig.setGenerateTreeIndex(GenerateType.OVERRIDE);
        } else {
            fileCreateConfig.setGeneratePageIndex(GenerateType.OVERRIDE);
            fileCreateConfig.setGenerateTreeIndex(GenerateType.IGNORE);
        }

        // 是否生成导入导出功能以及相关的接口
        build.setIsGenerateExportApi(false);
        return build;
    }

}
