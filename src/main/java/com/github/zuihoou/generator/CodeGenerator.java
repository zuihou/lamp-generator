package com.github.zuihoou.generator;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.ConstVal;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.FileOutConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.TemplateConfig;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.ext.FileOutConfigExt;
import com.github.zuihoou.generator.ext.FreemarkerTemplateEngineExt;
import com.github.zuihoou.generator.ext.MySqlQueryExt;
import com.github.zuihoou.generator.type.GenerateType;

/**
 * 代码生成
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class CodeGenerator {

    public static final String QUERY_PATH = "Query";
    public static final String API_PATH = "Api";
    public static final String ENUM_PATH = "Enum";
    public static final String CONSTANT_PATH = "Constant";
    public static final String SAVE_DTO_PATH = "SaveDTO";
    public static final String UPDATE_DTO_PATH = "UpdateDTO";

    public static final String SRC_MAIN_JAVA = "src" + File.separator + "main" + File.separator + "java";
    public static final String SRC_MAIN_RESOURCE = "src" + File.separator + "main" + File.separator + "resources";

    public static void main(final CodeGeneratorConfig config) {
        // 代码生成器
        AutoGenerator mpg = new AutoGenerator();
        //项目的根路径
        String projectRootPath = config.getProjectRootPath();

        //全局配置
        GlobalConfig gc = globalConfig(config, projectRootPath);
        mpg.setGlobalConfig(gc);

        // 数据源配置
        DataSourceConfig dsc = dataSourceConfig(config);
        mpg.setDataSource(dsc);

        PackageConfig pc = packageConfig(config);
        mpg.setPackageInfo(pc);

        // 配置模板
        TemplateConfig templateConfig = new TemplateConfig();
        // 不生成下列文件
        templateConfig.setController(null);
        templateConfig.setServiceImpl(null);
        templateConfig.setService(null);
        templateConfig.setMapper(null);
        templateConfig.setXml(null);
        templateConfig.setEntity(null);
        mpg.setTemplate(templateConfig);

        // 自定义配置
        InjectionConfig cfg = injectionConfig(config, projectRootPath, pc);
        mpg.setCfg(cfg);

        // 策略配置
        StrategyConfig strategy = strategyConfig(config);
        mpg.setStrategy(strategy);
        mpg.setTemplateEngine(new FreemarkerTemplateEngineExt(config));
//        mpg.setTemplateEngine(new FreemarkerTemplateEngine());

        mpg.execute();
    }

    /**
     * 全局配置
     *
     * @param config      参数
     * @param projectPath 项目根路径
     * @return
     */
    private static GlobalConfig globalConfig(final CodeGeneratorConfig config, String projectPath) {
        GlobalConfig gc = new GlobalConfig();
        gc.setOutputDir(String.format("%s/%s", projectPath, SRC_MAIN_JAVA));
        gc.setAuthor(config.getAuthor());
        gc.setOpen(false);
        gc.setServiceName("%sService");
        gc.setFileOverride(true);
        gc.setBaseResultMap(true);
        gc.setBaseColumnList(true);
        gc.setDateType(DateType.TIME_PACK);
        gc.setIdType(IdType.INPUT);
        // 实体属性 Swagger2 注解
        gc.setSwagger2(true);
        return gc;
    }

    /**
     * 数据库设置
     *
     * @param config
     * @return
     */
    private static DataSourceConfig dataSourceConfig(CodeGeneratorConfig config) {
        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setUrl(config.getUrl());
        dsc.setDriverName(config.getDriverName());
        dsc.setUsername(config.getUsername());
        dsc.setPassword(config.getPassword());
        dsc.setDbQuery(new MySqlQueryExt());
        return dsc;
    }


    private static PackageConfig packageConfig(final CodeGeneratorConfig config) {
        PackageConfig pc = new PackageConfig();
//        pc.setModuleName(config.getChildPackageName());
        pc.setParent(config.getPackageBase());
        pc.setMapper("dao");
        if (StringUtils.isNotEmpty(config.getChildPackageName())) {
            pc.setMapper(pc.getMapper() + StringPool.DOT + config.getChildPackageName());
            pc.setEntity(pc.getEntity() + StringPool.DOT + config.getChildPackageName());
            pc.setService(pc.getService() + StringPool.DOT + config.getChildPackageName());
            pc.setServiceImpl(pc.getService() + StringPool.DOT + "impl");
            pc.setController(pc.getController() + StringPool.DOT + config.getChildPackageName());
        }
//        pc.setPathInfo(pathInfo(config));
        return pc;
    }

    private static StrategyConfig strategyConfig(CodeGeneratorConfig pc) {
        StrategyConfig strategy = new StrategyConfig();
        strategy.setNaming(NamingStrategy.underline_to_camel);
        strategy.setColumnNaming(NamingStrategy.underline_to_camel);
        strategy.setEntityTableFieldAnnotationEnable(true);
        strategy.setEntityLombokModel(true);
        strategy.setEntityBuilderModel(true);
        strategy.setInclude(pc.getTableInclude());
        strategy.setExclude(pc.getTableExclude());
        strategy.setTablePrefix(pc.getTablePrefix());
        strategy.setFieldPrefix(pc.getFieldPrefix());
        strategy.setEntityColumnConstant(GenerateType.IGNORE.neq(pc.getFileCreateConfig().getGenerateConstant()));
        strategy.setRestControllerStyle(true);
        strategy.setSuperEntityClass(pc.getSuperEntity().getVal());
        strategy.setSuperControllerClass(pc.getSuperControllerClass());

        strategy.setSuperEntityColumns(pc.getSuperEntity().getColumns());
        return strategy;
    }

    /**
     * InjectionConfig   自定义配置   这里可以进行包路径的配置，自定义的代码生成器的接入配置。这里定义了xmlmapper 及query两个文件的自动生成配置
     */
    private static InjectionConfig injectionConfig(final CodeGeneratorConfig config, String projectRootPath, PackageConfig pc) {
        InjectionConfig cfg = new InjectionConfig() {
            @Override
            public void initMap() {
                Map<String, Object> map = initImportPackageInfo(config.getPackageBase(), config.getChildPackageName());
                this.setMap(map);
            }
        };
        cfg.setFileCreate(config.getFileCreateConfig());

        // 自定义输出配置
        cfg.setFileOutConfigList(getFileConfig(config));
        return cfg;
    }

    /**
     * 配置包信息    配置规则是：   parentPackage + "层" + "模块"
     */
    public static Map<String, Object> initImportPackageInfo(String parentPackage, String childPackageName) {
        Map<String, Object> packageMap = new HashMap<>();
        if (childPackageName != null && !"".equals(childPackageName.trim())) {
            childPackageName = "." + childPackageName;
        }

        packageMap.put(API_PATH, parentPackage + ".api" + childPackageName);
//        packageMap.put(ConstVal.CONTROLLER, parentPackage + ".controller" + childPackageName);

//        packageMap.put(ConstVal.SERVICE, parentPackage + ".service" + childPackageName);
//        packageMap.put(ConstVal.SERVICE_IMPL, parentPackage + ".service" + childPackageName + ".impl");

//        packageMap.put(ConstVal.MAPPER, parentPackage + ".dao" + childPackageName);
        packageMap.put(QUERY_PATH, parentPackage + ".query" + childPackageName);
//        packageMap.put(ConstVal.ENTITY, parentPackage + ".entity" + childPackageName);

        packageMap.put(ENUM_PATH, parentPackage + ".entity" + childPackageName);
        packageMap.put(CONSTANT_PATH, parentPackage + ".constant" + childPackageName);
        packageMap.put("constantSuffix", "Constant");
//        packageMap.put(DTO_PATH, parentPackage + ".dto" + childPackageName);
        packageMap.put(SAVE_DTO_PATH, parentPackage + ".dto" + childPackageName);
        packageMap.put(UPDATE_DTO_PATH, parentPackage + ".dto" + childPackageName);

        return packageMap;
    }

    private static List<FileOutConfig> getFileConfig(CodeGeneratorConfig config) {
        List<FileOutConfig> focList = new ArrayList<>();

        String projectRootPath = config.getProjectRootPath();
        if (!projectRootPath.endsWith(File.separator)) {
            projectRootPath += File.separator;
        }
        String packageBase = config.getPackageBase().replace(".", File.separator);

        StringBuilder basePathSb = new StringBuilder(projectRootPath).append("%s");
        basePathSb.append(SRC_MAIN_JAVA).append(File.separator)
                .append(packageBase)
                .toString();

        final String basePath = basePathSb.toString();

        focList.add(new FileOutConfigExt(basePath, ConstVal.CONTROLLER, config));
        focList.add(new FileOutConfigExt(basePath, ConstVal.SERVICE, config));
        focList.add(new FileOutConfigExt(basePath, ConstVal.SERVICE_IMPL, config));
        focList.add(new FileOutConfigExt(basePath, ConstVal.MAPPER, config));
        focList.add(new FileOutConfigExt(basePath, ConstVal.XML, config));

        focList.add(new FileOutConfigExt(basePath, QUERY_PATH, config));
        focList.add(new FileOutConfigExt(basePath, CONSTANT_PATH, config));
//        focList.add(new FileOutConfigExt(basePath, DTO_PATH, config));
        focList.add(new FileOutConfigExt(basePath, SAVE_DTO_PATH, config));
        focList.add(new FileOutConfigExt(basePath, UPDATE_DTO_PATH, config));

        return focList;
    }


}
