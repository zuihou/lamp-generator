package ${packageBaseParent}.general.controller;

import com.github.zuihou.base.BaseEnum;
import com.github.zuihou.base.R;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

/**
 * ${description}-通用 控制器
 *
 * @author ${author}
 * @date ${date}
 */
@Slf4j
@RestController
@Api(value = "General", tags = "通用Controller")
public class ${service}GeneralController {

    @ApiOperation(value = "获取当前系统所有枚举", notes = "获取当前系统所有枚举")
    @GetMapping("/enums")
    public R${r"<Map<String, Map<String, String>>>"} enums() {
        Map${r"<String, Map<String, String>>"} map = new HashMap<>(1);
        return R.success(map);
    }

}
