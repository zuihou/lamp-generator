package ${package.Controller};

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.github.zuihou.base.Result;
import com.github.zuihou.mybatis.conditions.query.LbqWrapper;
import com.github.zuihou.mybatis.conditions.Wraps;
import ${package.Entity}.${entity};
import ${cfg.DTO}.${entity}DTO;
import ${package.Service}.${table.serviceName};
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import javax.validation.Valid;
import org.springframework.validation.annotation.Validated;
import com.github.zuihou.base.entity.SuperEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
<#if restControllerStyle>
import org.springframework.web.bind.annotation.RestController;
<#else>
import org.springframework.stereotype.Controller;
</#if>
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
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
@Api(value = "${entity}", description = "${table.comment!?replace("\r\n","")?replace("\r","")?replace("\n","")?trim}")
</#if>
<#if kotlin>
    class ${table.controllerName}<#if superControllerClass??> : ${superControllerClass}()</#if>
<#else>
    <#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass} {
    <#else>
public class ${table.controllerName} {
    </#if>
<#assign tableComment = "${table.comment!''}"/>
<#if table.comment?? && table.comment!?contains('\n')>
    <#assign tableComment = "${table.comment!?substring(0,table.comment?index_of('\n'))?trim}"/>
</#if>

    @Autowired
    private ${table.serviceName} ${table.serviceName?uncap_first};

    /**
     * 分页查询${tableComment}
     *
     * @param data 分页查询对象
     * @return 查询结果
     */
    @ApiOperation(value = "分页查询${tableComment}", notes = "分页查询${tableComment}")
    @GetMapping("/page")
    @Validated(SuperEntity.OnlyQuery.class)
    public Result<IPage<${entity}>> page(@Valid ${entity}DTO data) {
        IPage<${entity}> page = getPage();
        // 构建查询条件
        LbqWrapper<${entity}> query = Wraps.lbQ();
        ${table.serviceName?uncap_first}.page(page, query);
        return success(page);
    }

    /**
     * 单体查询${tableComment}
     *
     * @param id 主键id
     * @return 查询结果
     */
    @ApiOperation(value = "查询${tableComment}", notes = "查询${tableComment}")
    @GetMapping("/{id}")
    public Result<${entity}> get(@PathVariable <#list table.commonFields as field><#if field.keyFlag>${field.propertyType}</#if></#list> id) {
        return success(${table.serviceName?uncap_first}.getById(id));
    }

    /**
     * 保存${tableComment}
     *
     * @param ${entity?uncap_first} 保存对象
     * @return 保存结果
     */
    @ApiOperation(value = "保存${tableComment}", notes = "保存${tableComment}不为空的字段")
    @PostMapping
    public Result<${entity}> save(@RequestBody @Valid ${entity} ${entity?uncap_first}) {
        ${table.serviceName?uncap_first}.save(${entity?uncap_first});
        return success(${entity?uncap_first});
    }

    /**
     * 修改${tableComment}
     *
     * @param ${entity?uncap_first} 修改对象
     * @return 修改结果
     */
    @ApiOperation(value = "修改${tableComment}", notes = "修改${tableComment}不为空的字段")
    @PutMapping
    @Validated(SuperEntity.Update.class)
    public Result<${entity}> update(@RequestBody @Valid ${entity} ${entity?uncap_first}) {
        ${table.serviceName?uncap_first}.updateById(${entity?uncap_first});
        return success(${entity?uncap_first});
    }

    /**
     * 删除${tableComment}
     *
     * @param id 主键id
     * @return 删除结果
     */
    @ApiOperation(value = "删除${tableComment}", notes = "根据id物理删除${tableComment}")
    @DeleteMapping(value = "/{id}")
    public Result<Boolean> delete(@PathVariable <#list table.commonFields as field><#if field.keyFlag>${field.propertyType}</#if></#list> id) {
        ${table.serviceName?uncap_first}.removeById(id);
        return success(true);
    }

}
</#if>
