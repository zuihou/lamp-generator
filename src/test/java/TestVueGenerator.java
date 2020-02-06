import cn.hutool.core.lang.Console;
import com.github.zuihoou.generator.VueGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.config.FileCreateConfig;
import com.github.zuihoou.generator.model.GenTableColumn;
import com.github.zuihoou.generator.type.EntityFiledType;
import com.github.zuihoou.generator.type.EntityType;
import com.github.zuihoou.generator.type.FieldType;
import com.github.zuihoou.generator.type.GenerateType;

import java.util.*;

import static com.github.zuihoou.generator.model.GenTableColumn.NO;
import static com.github.zuihoou.generator.model.GenTableColumn.YES;

/**
 * 前端代码生成
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class TestVueGenerator {
    /***
     * 注意，想要在这里直接运行，需要手动增加 mysql 驱动
     * @param args
     */
    public static void main(String[] args) {
        CodeGeneratorConfig build = buildHeheEntity();

        build.setUsername("root");
        build.setPassword("root");
        String vuePath = "/Users/tangyh/githubspace/zuihou-ui";
        Console.log("代码输出路径：{}", vuePath);

        build.setProjectRootPath(vuePath);

//        FileCreateConfig fileCreateConfig = new FileCreateConfig(null);
        FileCreateConfig fileCreateConfig = new FileCreateConfig(GenerateType.OVERRIDE, true);

        build.setFileCreateConfig(fileCreateConfig);

        //手动指定枚举类 生成的路径
        Set<EntityFiledType> filedTypes = new HashSet<>();
        filedTypes.addAll(Arrays.asList(
        ));
        build.setFiledTypes(filedTypes);

        buildVue(build);

        VueGenerator.run(build);
    }

    /**
     * 若这里不设置，会根据数据库设计默认 生成 input框
     *
     * @param build
     */
    private static void buildVue(CodeGeneratorConfig build) {
        CodeGeneratorConfig.Vue vue = new CodeGeneratorConfig.Vue();
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();

        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("key", new GenTableColumn("key", YES, YES, YES, YES, FieldType.INPUT));
        keyField.put("name", new GenTableColumn("name", YES, YES, YES, YES, FieldType.INPUT));
        keyField.put("value", new GenTableColumn("value", YES, YES, YES, YES, FieldType.INPUT));
        keyField.put("describe_", new GenTableColumn("describe_", YES, YES, YES, NO, FieldType.TEXTAREA));
        keyField.put("status_", new GenTableColumn("status_", YES, YES, YES, NO, FieldType.RADIO_BUTTON));
        keyField.put("readony_", new GenTableColumn("readony_", NO, NO, YES, NO, FieldType.RADIO_BUTTON));

        map.put("c_common_parameter", keyField);

        vue.setTableFieldMap(map);
        build.setVue(vue);
    }


    public static CodeGeneratorConfig buildHeheEntity() {
        List<String> tables = Arrays.asList(
                "c_common_parameter"
        );
        CodeGeneratorConfig build = CodeGeneratorConfig.
                build("authority", "", "zuihou", "c_common_", tables);
        build.setSuperEntity(EntityType.ENTITY);
        build.setChildPackageName("base");
        build.setUrl("jdbc:mysql://127.0.0.1:3306/zuihou_base_0000?serverTimezone=CTT&characterEncoding=utf8&useUnicode=true&useSSL=false&autoReconnect=true&zeroDateTimeBehavior=convertToNull");
        return build;
    }

}
