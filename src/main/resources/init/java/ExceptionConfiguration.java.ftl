package ${packageBase}.config;

import com.github.zuihou.boot.handler.DefaultGlobalExceptionHandler;
import org.springframework.context.annotation.Configuration;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * ${description}-全局异常处理
 *
 * @author ${author}
 * @date ${date}
 */
@Configuration
@ControllerAdvice(annotations = {RestController.class, Controller.class})
@ResponseBody
public class ${service}ExceptionConfiguration extends DefaultGlobalExceptionHandler {
}
