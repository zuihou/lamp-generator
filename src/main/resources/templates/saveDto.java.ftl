package ${cfg.SaveDTO};

<#list table.importPackages as pkg>
import ${pkg};
</#list>
<#if swagger2>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.Range;
<#if entityLombokModel>
import lombok.Data;
import lombok.Builder;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.ToString;
import lombok.experimental.Accessors;
</#if>
<#list cfg.filedTypes as fieldType>
    <#list table.fields as field>
        <#if field.propertyName == fieldType.name && table.name==fieldType.table && (field.type?starts_with("varchar") || field.type?starts_with("char"))>
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
@ApiModel(value = "${entity}SaveDTO", description = "${table.comment!?replace("\r\n"," ")?replace("\r"," ")?replace("\n"," ")}")
</#if>
public class ${entity}SaveDTO implements Serializable {

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
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && (field.type?starts_with("varchar") || field.type?starts_with("char"))>
            <#assign myPropertyType="${fieldType.type}"/>
            <#assign isEnumType="2"/>
        </#if>
    </#list>
    <#if field.customMap.dict??>
        <#assign isEnumType="3"/>
    </#if>
    <#if field.customMap.Null == "NO" >
        <#if (field.columnType!"") == "STRING" && isEnumType == "1">
    @NotEmpty(message = "${fieldComment}不能为空")
        <#else>
    @NotNull(message = "${fieldComment}不能为空")
        </#if>
    </#if>
    <#if (field.columnType!"") == "STRING" && isEnumType == "1">
        <#assign max = 255/>
        <#if field.type?starts_with("varchar") || field.type?starts_with("char")>
            <#if field.type?contains("(")>
                <#assign max = field.type?substring(field.type?index_of("(") + 1, field.type?index_of(")"))/>
            </#if>
    @Length(max = ${max}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("text")>
            <#assign max = 65535/>
    @Length(max = ${max?string["0"]}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("mediumtext")>
            <#assign max = 16777215/>
    @Length(max = ${max?string["0"]}, message = "${fieldComment}长度不能超过${max}")
        <#elseif field.type?starts_with("longtext")>
        </#if>
    <#else>
        <#if field.propertyType?starts_with("Short")>
    @Range(min = Short.MIN_VALUE, max = Short.MAX_VALUE, message = "${fieldComment}长度不能超过"+Short.MAX_VALUE)
        </#if>
        <#if field.propertyType?starts_with("Byte")>
    @Range(min = Byte.MIN_VALUE, max = Byte.MAX_VALUE, message = "${fieldComment}长度不能超过"+Byte.MAX_VALUE)
        </#if>
        <#if field.propertyType?starts_with("Short")>
    @Range(min = Short.MIN_VALUE, max = Short.MAX_VALUE, message = "${fieldComment}长度不能超过"+Short.MAX_VALUE)
        </#if>
    </#if>
    <#if field.customMap.dict??>
    @DictionaryType("${field.customMap.dict}")
        <#assign myPropertyType="Dictionary"/>
    </#if>
    private ${myPropertyType} ${field.propertyName};
</#if>
</#list>

}
