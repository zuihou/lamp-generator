package ${package.Controller};


import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.github.zuihou.base.R;
import com.github.zuihou.log.annotation.SysLog;
import com.github.zuihou.database.mybatis.conditions.query.LbqWrapper;
import com.github.zuihou.database.mybatis.conditions.Wraps;
import ${package.Entity}.${entity};
import ${cfg.SaveDTO}.${entity}SaveDTO;
import ${cfg.SaveDTO}.${entity}UpdateDTO;
import ${cfg.SaveDTO}.${entity}PageDTO;
import ${package.Service}.${table.serviceName};
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiImplicitParams;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import com.github.zuihou.base.entity.SuperEntity;
import com.github.zuihou.model.RemoteData;
import com.github.zuihou.utils.BeanPlusUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>

<#assign tableComment = "${table.comment!''}"/>
<#if table.comment?? && table.comment!?contains('\n')>
    <#assign tableComment = "${table.comment!?substring(0,table.comment?index_of('\n'))?trim}"/>
</#if>
/**
 * <p>
 * 前端控制器
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
@Slf4j
@Validated
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
@RequestMapping("<#if package.ModuleName??>/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")
<#if swagger2>
@Api(value = "${entity}", tags = "${tableComment}")
</#if>
<#if kotlin>
    class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
    <#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass}<${table.serviceName}, <#list table.commonFields as field><#if field.keyFlag>${field.propertyType}</#if></#list><#list table.fields as field><#if field.keyFlag>${field.propertyType}</#if></#list>, ${entity}, ${entity}PageDTO, ${entity}SaveDTO, ${entity}UpdateDTO> {
    <#else>
public class ${table.controllerName} {
    </#if>

    /**
     * Excel导入后的操作
     *
     * @param list
     */
    @Override
    protected void handlerImport(List<Map<String, String>> list){
        List<${entity}> ${entity?uncap_first}List = list.stream().map((map) -> {
            ${entity} ${entity?uncap_first} = ${entity}.builder().build();
            //TODO 请在这里完成转换
            return ${entity?uncap_first};
        }).collect(Collectors.toList());

        baseService.saveBatch(${entity?uncap_first}List);
    }
}
</#if>
