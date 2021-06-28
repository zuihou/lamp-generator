package ${cfg.PageQuery};

import java.time.LocalDateTime;
<#list table.importPackages as pkg>
import ${pkg};
</#list>
<#if swagger2>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
<#if entityLombokModel>
import lombok.Data;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.ToString;
import lombok.experimental.Accessors;
import ${cfg.groupId}.common.constant.DictionaryType;
</#if>
<#list cfg.filedTypes as fieldType>
    <#list table.fields as field>
        <#if field.propertyName == fieldType.name && table.name==fieldType.table && field.propertyType=="String">
import ${fieldType.packagePath};
            <#break>
        </#if>
    </#list>
</#list>
import java.io.Serializable;

/**
 * <p>
 * 实体类
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if entityLombokModel>
@Data
@NoArgsConstructor
@AllArgsConstructor
@Accessors(chain = true)
@ToString(callSuper = true)
@EqualsAndHashCode(callSuper = false)
@Builder
</#if>
<#if swagger2>
@ApiModel(value = "${entity}PageQuery", description = "${table.comment!?replace("\r\n"," ")?replace("\r"," ")?replace("\n"," ")}")
</#if>
public class ${entity}PageQuery implements Serializable {

    private static final long serialVersionUID = 1L;

<#list table.fields as field>
<#-- 如果有父类，排除公共字段 -->
<#if (superEntityClass?? && cfg.superExtend?? && field.propertyName !="id") || (superEntityClass?? && field.propertyName !="id" && field.propertyName !="createTime" && field.propertyName != "updateTime" && field.propertyName !="createUser" && field.propertyName !="updateUser") || !superEntityClass??>
    <#if field.keyFlag>
        <#assign keyPropertyName="${field.propertyName}"/>
    </#if>
    <#assign fieldComment="${field.comment!}"/>
    <#if field.comment!?length gt 0>
    /**
     * ${field.comment!?replace("\n","\n     * ")}
     */
        <#if field.comment!?contains("\n") >
            <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
        </#if>
    </#if>
    <#if swagger2>
    @ApiModelProperty(value = "${fieldComment}")
    </#if>
    <#assign myPropertyType="${field.propertyType}"/>
    <#assign isEnumType="1"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="${fieldType.type}"/>
            <#assign isEnumType="2"/>
        </#if>
    </#list>
    <#assign myPropertyName="${field.propertyName}"/>
    <#-- 自动注入注解 -->
<#--    <#if field.customMap.annotation??>-->
<#--    ${field.customMap.annotation}-->
<#--        <#assign myPropertyType="${field.customMap.type}"/>-->
<#--        <#if field.propertyName?ends_with("Id")>-->
<#--            <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>-->
<#--        </#if>-->
<#--    </#if>-->
    private ${myPropertyType} ${myPropertyName};
</#if>
</#list>

<#if superEntityClass?? && superEntityClass=="TreeEntity">
    @ApiModelProperty(value = "名称")
    protected String label;

    @ApiModelProperty(value = "父ID")
    protected <#list table.commonFields as field><#if field.keyFlag>${field.propertyType}</#if></#list> parentId;

    @ApiModelProperty(value = "排序号")
    protected Integer sortValue;
</#if>
}
