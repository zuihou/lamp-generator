package ${packageBase}.config.datasource;

import com.baomidou.mybatisplus.extension.plugins.inner.InnerInterceptor;
import com.tangyh.lamp.oauth.api.UserApi;
import com.tangyh.basic.database.datasource.BaseMybatisConfiguration;
import com.tangyh.basic.database.mybatis.auth.DataScopeInnerInterceptor;
import com.tangyh.basic.database.properties.DatabaseProperties;
import com.tangyh.basic.utils.SpringUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 * 配置一些 Mybatis 常用重用拦截器
 * ${description}
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
@Slf4j
@EnableConfigurationProperties({DatabaseProperties.class})
public class ${service}MybatisAutoConfiguration extends BaseMybatisConfiguration {

    public ${service}MybatisAutoConfiguration(DatabaseProperties databaseProperties) {
        super(databaseProperties);
    }


    /**
     * 数据权限插件
     * @return 数据权限插件
     */
    @Override
    protected List<InnerInterceptor> getPaginationBeforeInnerInterceptor() {
        List<InnerInterceptor> list = new ArrayList<>();
        Boolean isDataScope = databaseProperties.getIsDataScope();
        if (isDataScope) {
            list.add(new DataScopeInnerInterceptor(userId -> SpringUtils.getBean(UserApi.class).getDataScopeById(userId)));
        }
        return list;
    }

}
