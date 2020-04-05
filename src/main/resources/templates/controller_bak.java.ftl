package ${package.Controller};


import java.util.List;
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
public class ${table.controllerName} extends ${superControllerClass} {
    <#else>
public class ${table.controllerName} {
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
    @ApiImplicitParams({
        @ApiImplicitParam(name = "current", value = "当前页", dataType = "long", paramType = "query", defaultValue = "1"),
        @ApiImplicitParam(name = "size", value = "每页显示几条", dataType = "long", paramType = "query", defaultValue = "10"),
    })
    @GetMapping("/page")
    @SysLog("分页查询${tableComment}")
    public R<IPage<${entity}>> page(${entity}PageDTO data) {
        ${entity} ${entity?uncap_first} = BeanPlusUtil.toBean(data, ${entity}.class);
        <#list table.fields as field>
        <#-- 自动注入注解 -->
        <#if field.customMap.annotation??>
        <#assign myPropertyName="${field.propertyName}"/>
        <#assign capPropertyName="${field.propertyName?cap_first}"/>
        <#assign entityCapPropertyName="${field.propertyName?cap_first}"/>
        <#if entityCapPropertyName?ends_with("Id")>
            <#assign entityCapPropertyName="${entityCapPropertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
        </#if>

        if (data != null && data.get${capPropertyName}() != null) {
            ${entity?uncap_first}.set${entityCapPropertyName}(new RemoteData<>(data.get${capPropertyName}()));
        }
        </#if>
        </#list>

        IPage<${entity}> page = getPage();
        // 构建值不为null的查询条件
        LbqWrapper<${entity}> query = Wraps.<${entity}>lbQ(${entity?uncap_first})
            .geHeader(${entity}::getCreateTime, data.getStartCreateTime())
            .leFooter(${entity}::getCreateTime, data.getEndCreateTime())
            .orderByDesc(${entity}::getCreateTime);
        ${table.serviceName?uncap_first}.page(page, query);
        return success(page);
    }

    /**
     * 查询${tableComment}
     *
     * @param id 主键id
     * @return 查询结果
     */
    @ApiOperation(value = "查询${tableComment}", notes = "查询${tableComment}")
    @GetMapping("/{id}")
    @SysLog("查询${tableComment}")
    public R<${entity}> get(@PathVariable <#list table.commonFields as field><#if field.keyFlag>${field.propertyType}</#if></#list><#list table.fields as field><#if field.keyFlag>${field.propertyType}</#if></#list> id) {
        return success(${table.serviceName?uncap_first}.getById(id));
    }

    /**
     * 新增${tableComment}
     *
     * @param data 新增对象
     * @return 新增结果
     */
    @ApiOperation(value = "新增${tableComment}", notes = "新增${tableComment}不为空的字段")
    @PostMapping
    @SysLog("新增${tableComment}")
    public R<${entity}> save(@RequestBody @Validated ${entity}SaveDTO data) {
        ${entity} ${entity?uncap_first} = BeanPlusUtil.toBean(data, ${entity}.class);
        ${table.serviceName?uncap_first}.save(${entity?uncap_first});
        return success(${entity?uncap_first});
    }

    /**
     * 修改${tableComment}
     *
     * @param data 修改对象
     * @return 修改结果
     */
    @ApiOperation(value = "修改${tableComment}", notes = "修改${tableComment}不为空的字段")
    @PutMapping
    @SysLog("修改${tableComment}")
    public R<${entity}> update(@RequestBody @Validated(SuperEntity.Update.class) ${entity}UpdateDTO data) {
        ${entity} ${entity?uncap_first} = BeanPlusUtil.toBean(data, ${entity}.class);
        ${table.serviceName?uncap_first}.updateById(${entity?uncap_first});
        return success(${entity?uncap_first});
    }

    /**
     * 删除${tableComment}
     *
     * @param ids 主键id
     * @return 删除结果
     */
    @ApiOperation(value = "删除${tableComment}", notes = "根据id物理删除${tableComment}")
    @DeleteMapping
    @SysLog("删除${tableComment}")
    public R<Boolean> delete(@RequestParam("ids[]") <#list table.commonFields as field><#if field.keyFlag>List<${field.propertyType}></#if></#list><#list table.fields as field><#if field.keyFlag>List<${field.propertyType}></#if></#list> ids) {
        ${table.serviceName?uncap_first}.removeByIds(ids);
        return success(true);
    }

    <#if superEntityClass?? && superEntityClass=="TreeEntity">
    /**
     * 级联查询${tableComment}
     *
     * @param data 参数
     * @return 查询结果
     */
    @ApiOperation(value = "级联查询${tableComment}", notes = "级联查询${tableComment}")
    @GetMapping
    @SysLog("级联查询${tableComment}")
    public R<List<${entity}>> list(${entity} data) {
        if (data == null) {
            data = new ${entity}();
        }
        if (data.getParentId() == null) {
            data.setParentId(0L);
        }
        LbqWrapper<${entity}> wrapper = Wraps.lbQ(data).orderByAsc(${entity}::getSortValue);
        return success(${entity?uncap_first}Service.list(wrapper));
    }
    </#if>
}
</#if>
