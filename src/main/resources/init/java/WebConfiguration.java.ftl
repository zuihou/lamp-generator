package ${packageBase}.config;

import com.github.zuihou.common.config.BaseConfig;
import org.springframework.context.annotation.Configuration;
import com.github.zuihou.authority.api.LogApi;
import com.github.zuihou.log.event.SysLogListener;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;

/**
 * ${description}-Web配置
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
public class ${service}WebConfiguration extends BaseConfig {

    @Value("${r"${"}zuihou.database.bizDatabase:zuihou_defaults${r"}"}")
    private String database;

    @Bean
    public SysLogListener sysLogListener(LogApi logApi) {
        return new SysLogListener(this.database, (log) -> logApi.save(log));
    }
}
