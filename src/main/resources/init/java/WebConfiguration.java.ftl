package ${packageBase}.config;

import com.github.zuihou.boot.config.BaseConfig;
import org.springframework.context.annotation.Configuration;
import com.github.zuihou.oauth.api.LogApi;
import com.github.zuihou.log.event.SysLogListener;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.autoconfigure.condition.ConditionalOnExpression;

/**
 * ${description}-Web配置
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
public class ${service}WebConfiguration extends BaseConfig {

    /**
    * zuihou.log.enabled = true 并且 zuihou.log.type=DB时实例该类
    *
    * @param optLogService
    * @return
    */
    @Bean
    @ConditionalOnExpression("${r'${'}zuihou.log.enabled:true${r'}'} && 'DB'.equals('${r'${'}zuihou.log.type:LOGGER${r'}'}')")
    public SysLogListener sysLogListener(LogApi logApi) {
        return new SysLogListener((log) -> logApi.save(log));
    }
}
