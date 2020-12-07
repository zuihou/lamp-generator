package ${packageBase}.config;

import com.tangyh.lamp.oauth.api.LogApi;
import com.tangyh.basic.boot.config.BaseConfig;
import com.tangyh.basic.log.event.SysLogListener;
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
     * lamp.log.enabled = true 并且 lamp.log.type=DB时实例该类
     */
    @Bean
    @ConditionalOnExpression("${r'${'}lamp.log.enabled:true${r'}'} && 'DB'.equals('${r'${'}lamp.log.type:LOGGER${r'}'}')")
    public SysLogListener sysLogListener(LogApi logApi) {
        return new SysLogListener(logApi::save);
    }
}
