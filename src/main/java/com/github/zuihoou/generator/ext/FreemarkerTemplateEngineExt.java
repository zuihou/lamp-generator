package com.github.zuihoou.generator.ext;

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
import com.github.zuihoou.generator.CodeGenerator;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.config.FileCreateConfig;
import com.github.zuihoou.generator.type.EntityFiledType;
import com.github.zuihoou.generator.type.GenerateType;

import org.apache.commons.lang3.StringUtils;


/**
 * 扩展 {@link BeetlTemplateEngine}
 * 便于我们加入我们自己的模板
 *
 * @author zuihou
 */
public class FreemarkerTemplateEngineExt extends FreemarkerTemplateEngine {

    private final static Pattern DICT_PATTERN = Pattern.compile("[@]Dict[{]([a-zA-Z0-9._]+)[}]");

    public final static String REG_EX_VAL = "#(.*?\\{(.*?)?\\})";
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
        //构造实体中的枚举类型字段
        tableList.forEach(t -> {
            t.getFields().forEach(field -> {
                build(t, field);
//                buildDict(t, field);
            });
        });


        //生成实体
        List<FileOutConfig> focList = new ArrayList<>();
        StringBuilder basePathSb = getBasePath();
        String packageBase = config.getPackageBase().replace(".", File.separator);
        basePathSb.append(File.separator).append(packageBase);
        focList.add(new FileOutConfigExt(basePathSb.toString(), ConstVal.ENTITY, config));

        InjectionConfig cfg = new InjectionConfig() {
            @Override
            public void initMap() {
                Map<String, Object> map = CodeGenerator.initImportPackageInfo(config.getPackageBase(), config.getChildPackageName());
                //这里必须 在entity生成后，赋值
                map.put("filedTypes", config.getFiledTypes());
                this.setMap(map);
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
/*
//    private void buildDict(TableInfo table, TableField field) {
//        String comment = field.getComment();//注释
//        if (comment == null) {
//            return;
//        }
//        Set<String> importPackages = table.getImportPackages();
//        Matcher matcher = DICT_PATTERN.matcher(comment);
//        if (matcher.find()) {
//            String dictCode = matcher.group(1);
//            field.getCustomMap().put("dict", dictCode);
//            importPackages.add(Dictionary.class.getName());
//            importPackages.add(DictionaryType.class.getName());
//        }
//    }
*/


    /**
     * 生成枚举值
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

        StringBuilder basePathSb = getBasePath();
        basePathSb.append(File.separator).append(entityFiledType.getPath())
                .append(".java");


//        String packageBase = config.getPackageBase().replace(".", File.separator);
//        basePathSb .append(File.separator).append(packageBase);
//        basePathSb.append(File.separator)
//                .append("enumeration");
//        if (StringUtils.isNotEmpty(config.getChildPackageName())) {
//            basePathSb.append(File.separator).append(config.getChildPackageName());
//        }
//        basePathSb.append(File.separator)
//                .append(enumName)
//                .append(StringPool.DOT_JAVA);

        FileCreateConfig fileCreateConfig = config.getFileCreateConfig();
        if (GenerateType.ADD.eq(fileCreateConfig.getGenerateEnum())
                && FileCreateConfig.isExists(basePathSb.toString())) {
            basePathSb.append(".new");
        }

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
        basePathSb.append(config.getProjectPrefix()).append(config.getServiceName())
                .append(config.getEntitySuffix()).append(File.separator)
                .append(CodeGenerator.SRC_MAIN_JAVA);


        return basePathSb;
    }


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
