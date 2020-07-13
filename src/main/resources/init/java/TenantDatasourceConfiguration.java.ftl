package ${packageBase}.config.mq;

import com.alibaba.fastjson.JSONObject;
import com.github.zuihou.common.constant.BizMqQueue;
import com.github.zuihou.database.properties.DatabaseProperties;
import com.github.zuihou.mq.properties.MqProperties;
import com.github.zuihou.tenant.service.DataSourceService;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.amqp.core.Binding;
import org.springframework.amqp.core.Queue;
import org.springframework.amqp.rabbit.annotation.RabbitListener;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.handler.annotation.Payload;

import java.util.HashMap;


/**
 * 消息队列开启时，启用
 *
 * @author ${author}
 * @date ${date}
 */
@Slf4j
@AllArgsConstructor
@Configuration
@ConditionalOnProperty(prefix = MqProperties.PREFIX, name = "enabled", havingValue = "true")
public class ${service}TenantDatasourceConfiguration {
    /** 建议将该变量手动移动到： BizMqQueue 类 */
    private final static String TENANT_DS_QUEUE_BY_${service?upper_case} = "tenant_ds_${service?lower_case}";
    private final DataSourceService dataSourceService;

    @Bean
    @ConditionalOnProperty(prefix = DatabaseProperties.PREFIX, name = "multiTenantType", havingValue = "DATASOURCE")
    public Queue dsQueue() {
        return new Queue(TENANT_DS_QUEUE_BY_${service?upper_case});
    }

    @Bean
    @ConditionalOnProperty(prefix = DatabaseProperties.PREFIX, name = "multiTenantType", havingValue = "DATASOURCE")
    public Binding dsQueueBinding() {
        return new Binding(TENANT_DS_QUEUE_BY_${service?upper_case}, Binding.DestinationType.QUEUE, BizMqQueue.TENANT_DS_FANOUT_EXCHANGE, "", new HashMap(1));
    }

    @RabbitListener(queues = TENANT_DS_QUEUE_BY_${service?upper_case})
    @ConditionalOnProperty(prefix = DatabaseProperties.PREFIX, name = "multiTenantType", havingValue = "DATASOURCE")
    public void dsRabbitListener(@Payload String param) {
        log.debug("异步初始化数据源=={}", param);
        JSONObject map = JSONObject.parseObject(param);
        if ("init".equals(map.getString("method"))) {
            dataSourceService.initDataSource(map.getString("tenant"));
        } else {
            dataSourceService.remove(map.getString("tenant"));
        }
    }
}
