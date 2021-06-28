package ${packageBase}.config;

import ${groupId}.oauth.api.LogApi;
import ${utilPackage}.boot.config.BaseConfig;
import ${utilPackage}.log.event.SysLogListener;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * ${description}-Web配置
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
public class ${service}WebConfiguration extends BaseConfig {

    /**
     * ${projectPrefix}.log.enabled = true 并且 ${projectPrefix}.log.type=DB时实例该类
     */
    @Bean
    @ConditionalOnExpression("${r'${'}${projectPrefix}.log.enabled:true${r'}'} && 'DB'.equals('${r'${'}${projectPrefix}.log.type:LOGGER${r'}'}')")
    public SysLogListener sysLogListener(LogApi logApi) {
        return new SysLogListener(logApi::save);
    }
}
