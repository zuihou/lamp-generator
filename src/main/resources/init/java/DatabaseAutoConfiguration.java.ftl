package ${packageBase}.config.datasource;

import com.baomidou.mybatisplus.autoconfigure.ConfigurationCustomizer;
import com.baomidou.mybatisplus.autoconfigure.MybatisPlusProperties;
import com.baomidou.mybatisplus.autoconfigure.MybatisPlusPropertiesCustomizer;
import com.tangyh.basic.database.datasource.defaults.BaseMasterDatabaseConfiguration;
import com.tangyh.basic.database.properties.DatabaseProperties;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.mapping.DatabaseIdProvider;
import org.apache.ibatis.plugin.Interceptor;
import org.apache.ibatis.scripting.LanguageDriver;
import org.apache.ibatis.type.TypeHandler;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.ObjectProvider;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Repository;

import java.util.List;

import static com.tangyh.lamp.common.constant.BizConstant.UTIL_PACKAGE;

/**
 * lamp.database.multiTenantType != DATASOURCE 时，该类启用.
 * 此时，项目的多租户模式切换成：${r"${lamp.database.multiTenantType}"}。
 * <p>
 * NONE("非租户模式"): 不存在租户的概念
 * COLUMN("字段模式"): 在sql中拼接 tenant_code 字段
 * SCHEMA("独立schema模式"): 在sql中拼接 数据库 schema
 * <p>
 * COLUMN和SCHEMA模式的实现 参考下面的 @see 中的2个类
 *
 * @author ${author}
 * @date ${date}
 * 断点查看原理：👇👇👇
 * @see com.tangyh.basic.database.datasource.BaseMybatisConfiguration#mybatisPlusInterceptor()
 * @see com.tangyh.basic.boot.interceptor.HeaderThreadLocalInterceptor
 */
@Configuration
@Slf4j
@MapperScan(
        basePackages = { "${packageBaseParent}", UTIL_PACKAGE }, annotationClass = Repository.class,
        sqlSessionFactoryRef = ${service}DatabaseAutoConfiguration.DATABASE_PREFIX + "SqlSessionFactory")
@EnableConfigurationProperties({MybatisPlusProperties.class})
@ConditionalOnExpression("!'DATASOURCE'.equals('${r"${lamp.database.multiTenantType}"}')")
public class ${service}DatabaseAutoConfiguration extends BaseMasterDatabaseConfiguration {
    /**
     * 每个数据源配置不同即可
     */
    final static String DATABASE_PREFIX = "master";

    public ${service}DatabaseAutoConfiguration(MybatisPlusProperties properties,
                                              DatabaseProperties databaseProperties,
                                              ObjectProvider${r"<Interceptor[]>"} interceptorsProvider,
                                              ObjectProvider${r"<TypeHandler[]>"} typeHandlersProvider,
                                              ObjectProvider${r"<LanguageDriver[]>"} languageDriversProvider,
                                              ResourceLoader resourceLoader,
                                              ObjectProvider${r"<DatabaseIdProvider>"} databaseIdProvider,
                                              ObjectProvider${r"<List<ConfigurationCustomizer>>"} configurationCustomizersProvider,
                                              ObjectProvider${r"<List<MybatisPlusPropertiesCustomizer>>"} mybatisPlusPropertiesCustomizerProvider,
                                              ApplicationContext applicationContext) {
        super(properties, databaseProperties, interceptorsProvider, typeHandlersProvider,
                languageDriversProvider, resourceLoader, databaseIdProvider,
                configurationCustomizersProvider, mybatisPlusPropertiesCustomizerProvider, applicationContext);
        log.debug("检测到 lamp.database.multiTenantType!=DATASOURCE，加载了 ${service}DatabaseAutoConfiguration");
    }

}
