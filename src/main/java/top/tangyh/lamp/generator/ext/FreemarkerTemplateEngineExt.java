package top.tangyh.lamp.generator.ext;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.map.MapUtil;
import cn.hutool.core.util.StrUtil;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.ConstVal;
import com.baomidou.mybatisplus.generator.config.FileOutConfig;
import com.baomidou.mybatisplus.generator.config.builder.ConfigBuilder;
import com.baomidou.mybatisplus.generator.config.po.TableField;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.FileType;
import com.baomidou.mybatisplus.generator.engine.AbstractTemplateEngine;
import com.baomidou.mybatisplus.generator.engine.BeetlTemplateEngine;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import top.tangyh.lamp.generator.CodeGenerator;
import top.tangyh.lamp.generator.VueGenerator;
import top.tangyh.lamp.generator.config.CodeGeneratorConfig;
import top.tangyh.lamp.generator.config.FileCreateConfig;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.EntityFiledType;
import top.tangyh.lamp.generator.type.GenerateType;
import org.apache.commons.lang3.StringUtils;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;


/**
 * 扩展 {@link BeetlTemplateEngine}
 * 便于我们加入我们自己的模板
 *
 * @author zuihou
 */
public class FreemarkerTemplateEngineExt extends FreemarkerTemplateEngine {

    /**
     * 注入字段 正则
     * 匹配： @Echo(api="", method="") RemoteData<Long, Org>
     * 匹配： @Echo(api="", method="" beanClass=Xxx.class)
     * 匹配： @Echo(api="orgApi", method="findXx" beanClass=Org.class) RemoteData<Long, com.xx.xx.Org>
     * 匹配： @Echo(feign=OrgApi.class, method="findXx" beanClass=Org.class) RemoteData<Long, com.xx.xx.Org>
     */
    private final static Pattern INJECTION_FIELD_PATTERN = Pattern.compile("([@]Echo[(](api|feign)? *= *([a-zA-Z0-9\"._]+), method *= *([a-zA-Z0-9\"._]+)(, *beanClass *= *[a-zA-Z0-9._]+)?(, *dictType *= *[a-zA-Z0-9._]+)?[)]){1}( *RemoteData(<[a-zA-Z0-9.]+,( *[a-zA-Z0-9.]+)>)?)*");

    /**
     * 枚举类 正则
     * 匹配： #{xxxx} 形式的注释
     */
    public final static String REG_EX_VAL = "#(.*?\\{(.*?)?\\})";
    /**
     * 枚举类型 正则
     * 匹配 xx:xx; 形式的注释
     */
    public final static String REG_EX_KEY = "([A-Za-z1-9_-]+):(.*?)?;";

    private CodeGeneratorConfig config;

    public FreemarkerTemplateEngineExt(CodeGeneratorConfig config) {
        this.config = config;
    }


    /**
     * 扩展父类    增加生成enum的代码。
     */
    @Override
    public AbstractTemplateEngine batchOutput() {
        ConfigBuilder cb = getConfigBuilder();

        //生成枚举
        try {
            List<TableInfo> tableInfoList = getConfigBuilder().getTableInfoList();
            for (TableInfo tableInfo : tableInfoList) {
                tableInfo.getFields().forEach(filed -> {
                    try {
                        generateEnum(tableInfo, filed);
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                });
            }
        } catch (Exception e) {
            logger.error("无法创建文件，请检查配置信息！", e);
        }
        List<TableInfo> tableList = cb.getTableInfoList();


        CodeGeneratorConfig.Vue vue = config.getVue();
        Map<String, Map<String, GenTableColumn>> tableFieldMap = vue.getTableFieldMap();
        //构造实体中的枚举类型字段
        tableList.forEach(t -> {
            t.getFields().forEach(field -> {
                Map<String, Object> customMap = field.getCustomMap();
                if (customMap == null) {
                    customMap = new HashMap<>();
                }
                Map<String, GenTableColumn> fieldMap = tableFieldMap.get(t.getName());
                if (MapUtil.isNotEmpty(fieldMap)) {
                    GenTableColumn genFiled = fieldMap.get(field.getName());
                    if (genFiled != null) {
                        customMap.put("info", genFiled);
                    }
                }
                field.setCustomMap(customMap);

                build(t, field);
                buildInjectionField(t, field);
            });
        });


        //生成实体
        List<FileOutConfig> focList = new ArrayList<>();
        if (!config.getFileCreateConfig().getIsVue()) {
            StringBuilder basePathSb = getBasePath();
            String packageBase = config.getPackageBase().replace(".", File.separator);
            basePathSb.append(File.separator).append(packageBase);
            focList.add(new FileOutConfigExt(basePathSb.toString(), ConstVal.ENTITY, config));
        }

        InjectionConfig cfg = new InjectionConfig() {
            @Override
            public void initMap() {
                Map<String, Object> map = CodeGenerator.initImportPackageInfo(config);

                Map<String, Object> vueMap = VueGenerator.initImportPackageInfo(config);
                //这里必须 在entity生成后，赋值
                map.put("filedTypes", config.getFiledTypes());
                map.putAll(vueMap);
                this.setMap(map);
            }

            @Override
            public void initTableMap(TableInfo tableInfo) {
                this.initMap();
            }
        };

        cfg.setFileCreate(cb.getInjectionConfig().getFileCreate());
        if (cb.getInjectionConfig().getFileOutConfigList() != null
                && !cb.getInjectionConfig().getFileOutConfigList().isEmpty()) {
            cb.getInjectionConfig().getFileOutConfigList().addAll(focList);
            cfg.setFileOutConfigList(cb.getInjectionConfig().getFileOutConfigList());
        } else {
            cfg.setFileOutConfigList(focList);
        }
        cfg.setConfig(cb.getInjectionConfig().getConfig());

        cb.setInjectionConfig(cfg);


        //执行mybatis plus的代码生成器
        super.batchOutput();

        return this;
    }


    private static String trim(String val) {
        return val == null ? StringPool.EMPTY : val.trim();
    }


    public static void main(String[] args) {
//        String comment = "@Echo(api=\"xxxx\", method=\"bbbbb\", beanClass=1) RemoteData<Long, Org>";
        String comment = "@Echo(api=\"xxxx\", method=\"bbbbb\", beanClass=1, dictType = DictionaryType.NATION) RemoteData<Long, Org>";
//        String comment = "@Echo(feign=FreemarkerTemplateEngineExt.class, method=\"bbbbb\"   beanClass=  Xxx.class) RemoteData<Long, Org>";
        Matcher matcher = INJECTION_FIELD_PATTERN.matcher(comment);
        if (matcher.find()) {
            String annotation = trim(matcher.group(1)); //@Echo(api="xxxx", method="bbbbb")
            String api = trim(matcher.group(3)); //xxxx
            String method = trim(matcher.group(4));  //bbbbb
            String type = trim(matcher.group(7)); //RemoteData<Long, Org>
            // 5 <Long, Org>
            String typePackage = trim(matcher.group(9)); //Org
            System.out.println(111);
        }
    }


    /**
     * 生成 需要注入 类型的字段
     *
     * @param table
     * @param field
     */
    private void buildInjectionField(TableInfo table, TableField field) {
        //注释
        String comment = field.getComment();
        if (comment == null) {
            return;
        }
        Set<String> importPackages = table.getImportPackages();
        Matcher matcher = INJECTION_FIELD_PATTERN.matcher(comment);
        if (matcher.find()) {
            String annotation = trim(matcher.group(1));
            String api = trim(matcher.group(3));
            String method = trim(matcher.group(4));
            String type = trim(matcher.group(7));
            String typePackage = trim(matcher.group(9));

            if (StrUtil.isNotEmpty(type) && StrUtil.contains(typePackage, ".")) {
                String data = StrUtil.subAfter(typePackage, ".", true);
                if (StrUtil.isNotEmpty(data)) {
                    type = StrUtil.replace(type, typePackage, data);
                }
            }

            field.getCustomMap().put("annotation", annotation);
//            field.getCustomMap().put("api", api);
//            field.getCustomMap().put("method", method);
            field.getCustomMap().put("type", type);
//            field.getCustomMap().put("type", type);

            if (!api.contains("\"")) {
                if (api.contains(".")) {
                    if (api.endsWith("class")) {
                        // 导入feign class
                        importPackages.add(StrUtil.subBefore(api, ".", true));


                    } else {
                        importPackages.add(StrUtil.format("{}.common.constant.EchoConstants", config.getGroupId()));
                    }
                } else {
                    importPackages.add(StrUtil.format("static {}.common.constant.EchoConstants.{}", config.getGroupId(), api));
                }
            }
            if (!method.contains("\"")) {
                if (method.contains(".")) {
                    importPackages.add(StrUtil.format("{}.common.constant.EchoConstants", config.getGroupId()));
                } else {
                    importPackages.add(StrUtil.format("static {}.common.constant.EchoConstants.{}", config.getGroupId(), method));
                }
            }
            if (typePackage.contains(".")) {
                importPackages.add(typePackage);
            }
            importPackages.add(StrUtil.format("{}.annotation.echo.Echo", config.getUtilPackage()));
            importPackages.add(StrUtil.format("{}.model.RemoteData", config.getUtilPackage()));
        }
    }

    /**
     * 生成枚举类型类
     *
     * @throws Exception
     */
    private void generateEnum(TableInfo tableInfo, TableField field) throws Exception {
        String comment = field.getComment();
        if (StringUtils.isBlank(comment) || !comment.contains("{") || !comment.contains("}") || !comment.contains(";")) {
            return;
        }
        // 排除boolean类型值
        if (Boolean.class.getSimpleName().equals(field.getColumnType().getType())) {
            return;
        }
        String propertyName = field.getPropertyName();
        Set<EntityFiledType> filedTypes = config.getFiledTypes();

        Map<String, Object> objectMap = getObjectMap(tableInfo);
        Map<String, String> packageInfo = (Map) objectMap.get("package");
        String entityPackage = packageInfo.get("Entity");

        String defEnumPackage = entityPackage.replaceAll("entity", "enumeration");

        String enumName = comment.substring(comment.indexOf(StringPool.HASH) + 1, comment.indexOf(StringPool.LEFT_BRACE));
        if ("".equals(enumName)) {
            enumName = tableInfo.getEntityName() + (Character.toUpperCase(propertyName.charAt(0)) + propertyName.substring(1)) + "Enum";
        }
        String finalEnumName = enumName;
        List<EntityFiledType> collect = filedTypes.stream().filter((filed) -> filed.getType().equals(finalEnumName)).collect(Collectors.toList());
        EntityFiledType entityFiledType = EntityFiledType.builder()
                .name(field.getPropertyName()).packagePath(defEnumPackage + "." + enumName).gen(GenerateType.OVERRIDE)
                .build();
        if (!collect.isEmpty()) {
            entityFiledType = collect.get(0);
        }

        String firstTypeNumber = "true";
        Map<String, List<String>> allFields = new LinkedHashMap<>();
        if (comment.contains(StringPool.HASH) && comment.contains(StringPool.RIGHT_BRACE)) {
            String enumComment = comment.substring(comment.indexOf(StringPool.HASH), comment.indexOf(StringPool.RIGHT_BRACE) + 1);
            // 编译正则表达式
            Pattern pattern = Pattern.compile(REG_EX_VAL);
            Matcher matcher = pattern.matcher(enumComment);
            while (matcher.find()) {
                String val = matcher.group(2);
                if (!val.endsWith(";")) {
                    val += ";";
                }

                Pattern keyPattern = Pattern.compile(REG_EX_KEY);
                Matcher keyMatcher = keyPattern.matcher(val);

                while (keyMatcher.find()) {
                    String key = keyMatcher.group(1);
                    String value = keyMatcher.group(2);

                    List<String> subList = new ArrayList<>();
                    if (value.contains(",")) {
                        String[] split = value.split(StringPool.COMMA);
                        subList = Arrays.asList(split);
                        try {
                            Integer.valueOf(split[0]);
                        } catch (Exception e) {
                            //字符串
                            firstTypeNumber = "false";
                        }

                    } else {
                        try {
                            Integer.valueOf(value);
                        } catch (Exception e) {
                            //字符串
                            firstTypeNumber = "false";
                        }
                        subList.add(value);
                    }

                    allFields.put(key, subList);
                }

            }
        }


        Map<String, Object> enumCustom = new HashMap<>();
        enumCustom.put("package", entityFiledType);
        enumCustom.put("enumName", enumName);

        enumCustom.put("comment", StringUtils.substring(comment, 0, comment.indexOf("\n")).trim());
        enumCustom.put("firstTypeNumber", firstTypeNumber);
        enumCustom.put("list", allFields);
        enumCustom.put("filedTypes", filedTypes);

        objectMap.put("enumCustom", enumCustom);

        field.getCustomMap().put("enumCustom", enumCustom);

        StringBuilder basePathSb = getBasePath();
        basePathSb.append(File.separator).append(entityFiledType.getPath())
                .append(".java");


        Map<String, Object> customMap = field.getCustomMap();
        if (customMap == null) {
            customMap = new HashMap<>();
        }
        customMap.put("isEnum", "1");
        field.setCustomMap(customMap);

        FileCreateConfig fileCreateConfig = config.getFileCreateConfig();
        if (GenerateType.ADD.eq(fileCreateConfig.getGenerateEnum())
                && FileCreateConfig.isExists(basePathSb.toString())) {
            basePathSb.append(".new");
        }

        objectMap.put("utilPackage", config.getUtilPackage());
        if (isCreate(FileType.OTHER, basePathSb.toString()) && GenerateType.IGNORE.neq(entityFiledType.getGen())) {
            writer(objectMap, templateFilePath("/templates/enum.java"), basePathSb.toString());
        }

    }


    private StringBuilder getBasePath() {
        String projectRootPath = config.getProjectRootPath();
        if (!projectRootPath.endsWith(File.separator)) {
            projectRootPath += File.separator;
        }

        StringBuilder basePathSb = new StringBuilder(projectRootPath);
        if (config.getIsGenEntity()) {
            basePathSb.append(config.getProjectPrefix()).append("-").append(config.getChildModuleName())
                    .append(config.getEntitySuffix()).append(File.separator)
                    .append(CodeGenerator.SRC_MAIN_JAVA);
        } else {
            basePathSb.append(config.getProjectPrefix()).append("-").append(config.getServiceName())
                    .append(config.getEntitySuffix()).append(File.separator)
                    .append(CodeGenerator.SRC_MAIN_JAVA);
        }

        return basePathSb;
    }


    /**
     * 生成实体类中字段的 枚举类型
     *
     * @param tableInfo
     * @param field
     */
    private void build(TableInfo tableInfo, TableField field) {
        String comment = field.getComment();
        String entityName = tableInfo.getEntityName();
        String propertyName = field.getPropertyName();
        if (StringUtils.isBlank(comment) || !comment.contains(StringPool.LEFT_BRACE)
                || !comment.contains(StringPool.RIGHT_BRACE) || !comment.contains(StringPool.SEMICOLON)) {
            return;
        }
        // 排除boolean类型值
        if (Boolean.class.getSimpleName().equals(field.getColumnType().getType())) {
            return;
        }

        String enumName = comment.substring(comment.indexOf(StringPool.HASH) + 1, comment.indexOf(StringPool.LEFT_BRACE));
        if (StringPool.EMPTY.equals(enumName)) {
            enumName = entityName + (Character.toUpperCase(propertyName.charAt(0)) + propertyName.substring(1)) + "Enum";
        }

        Set<EntityFiledType> filedTypes = config.getFiledTypes();

        EntityFiledType cur = EntityFiledType.builder().name(propertyName).table(tableInfo.getName()).build();
        if (!filedTypes.contains(cur)) {
            ConfigBuilder configBuilder = getConfigBuilder();
            Map<String, String> packageInfo = configBuilder.getPackageInfo();
            String entityPackage = packageInfo.get("Entity");
            String defEnumPackage = entityPackage.replaceAll("entity", "enumeration");

            filedTypes.add(EntityFiledType.builder()
                    .name(propertyName)
                    .packagePath(defEnumPackage + "." + enumName)
                    .table(tableInfo.getName())
                    .gen(config.getFileCreateConfig().getGenerateEnum())
                    .build());
        }
    }
}
