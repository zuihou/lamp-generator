package com.github.zuihoou.generator;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.DataSourceConfig;
import com.baomidou.mybatisplus.generator.config.FileOutConfig;
import com.baomidou.mybatisplus.generator.config.GlobalConfig;
import com.baomidou.mybatisplus.generator.config.PackageConfig;
import com.baomidou.mybatisplus.generator.config.StrategyConfig;
import com.baomidou.mybatisplus.generator.config.TemplateConfig;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.querys.DB2Query;
import com.baomidou.mybatisplus.generator.config.querys.DMQuery;
import com.baomidou.mybatisplus.generator.config.querys.H2Query;
import com.baomidou.mybatisplus.generator.config.querys.MariadbQuery;
import com.baomidou.mybatisplus.generator.config.querys.PostgreSqlQuery;
import com.baomidou.mybatisplus.generator.config.querys.SqlServerQuery;
import com.baomidou.mybatisplus.generator.config.querys.SqliteQuery;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.github.zuihoou.generator.config.CodeGeneratorConfig;
import com.github.zuihoou.generator.ext.FileOutConfigExt;
import com.github.zuihoou.generator.ext.FreemarkerTemplateEngineExt;
import com.github.zuihoou.generator.ext.MySqlQueryExt;
import com.github.zuihoou.generator.ext.OracleQueryExt;
import com.github.zuihoou.generator.type.GenerateType;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 代码生成
 *
 * @author zuihou
 * @date 2019/05/25
 */
public class VueGenerator {

    public static final String API_PATH = "Api";
    public static final String PAGE_INDEX_PATH = "PageIndex";
    public static final String TREE_INDEX_PATH = "TreeIndex";
    public static final String EDIT_PATH = "Edit";
    public static final String LANG_PATH = "Lang";
//    public static final String QUERY_PATH = "Query";
//    public static final String ENUM_PATH = "Enum";
//    public static final String CONSTANT_PATH = "Constant";
//    public static final String SAVE_DTO_PATH = "SaveDTO";
//    public static final String UPDATE_DTO_PATH = "UpdateDTO";
//    public static final String PAGE_DTO_PATH = "PageDTO";

//    public static final String SRC_MAIN_JAVA = "src" + File.separator + "main" + File.separator + "java";
//    public static final String SRC_MAIN_RESOURCE = "src" + File.separator + "main" + File.separator + "resources";

    public static final String SRC = "src";
//    public static final String SRC_API = "src" + File.separator + "api";
//    public static final String SRC_VIEWS = "src" + File.separator + "views" + File.separator + "zuihou";

    public static void run(final CodeGeneratorConfig config) {
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

        mpg.execute();


        System.err.println("前端代码生成完毕， 请在以上日志中查看生成文件的路径");
        System.err.println("并将src/lang/lang.*.js中的配置按照文件提示，复制到en.js和zh.js, 否则页面无法显示中文标题");
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
        gc.setOutputDir(String.format("%s/%s", projectPath, SRC));
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
        if (dsc.getDbType() == DbType.MYSQL) {
            dsc.setDbQuery(new MySqlQueryExt());
        }
        // oracle 没完全测试
        else if (dsc.getDbType() == DbType.ORACLE) {
            dsc.setDbQuery(new OracleQueryExt());
        }
        // 以下的都没测试过
        else if (dsc.getDbType() == DbType.DB2) {
            dsc.setDbQuery(new DB2Query());
        } else if (dsc.getDbType() == DbType.DM) {
            dsc.setDbQuery(new DMQuery());
        } else if (dsc.getDbType() == DbType.H2) {
            dsc.setDbQuery(new H2Query());
        } else if (dsc.getDbType() == DbType.MARIADB) {
            dsc.setDbQuery(new MariadbQuery());
        } else if (dsc.getDbType() == DbType.POSTGRE_SQL) {
            dsc.setDbQuery(new PostgreSqlQuery());
        } else if (dsc.getDbType() == DbType.SQLITE) {
            dsc.setDbQuery(new SqliteQuery());
        } else if (dsc.getDbType() == DbType.SQL_SERVER) {
            dsc.setDbQuery(new SqlServerQuery());
        }
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
        strategy.setChainModel(true);
        strategy.setInclude(pc.getTableInclude());
        strategy.setExclude(pc.getTableExclude());
        strategy.setLikeTable(pc.getLikeTable());
        strategy.setNotLikeTable(pc.getNotLikeTable());
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
                Map<String, Object> map = initImportPackageInfo(config);
                this.setMap(map);
            }

            @Override
            public void initTableMap(TableInfo tableInfo) {
                this.initMap();
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
    public static Map<String, Object> initImportPackageInfo(CodeGeneratorConfig config) {
        String parentPackage = config.getPackageBase();
        String childPackageName = config.getChildPackageName();
        Map<String, Object> packageMap = new HashMap<>();

        packageMap.put("serviceName", config.getServiceName());
        packageMap.put("childPackageName", childPackageName);

        return packageMap;
    }

    private static List<FileOutConfig> getFileConfig(CodeGeneratorConfig config) {
        List<FileOutConfig> focList = new ArrayList<>();

        String projectRootPath = config.getProjectRootPath();
        if (!projectRootPath.endsWith(File.separator)) {
            projectRootPath += File.separator;
        }

        StringBuilder basePathSb = new StringBuilder(projectRootPath).append(SRC);

        final String basePath = basePathSb.toString();

        focList.add(new FileOutConfigExt(basePath, API_PATH, config));
        focList.add(new FileOutConfigExt(basePath, PAGE_INDEX_PATH, config));
        focList.add(new FileOutConfigExt(basePath, EDIT_PATH, config));
        focList.add(new FileOutConfigExt(basePath, LANG_PATH, config));
        focList.add(new FileOutConfigExt(basePath, TREE_INDEX_PATH, config));

        return focList;
    }


}
