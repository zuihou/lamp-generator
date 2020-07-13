package ${enumCustom.package.importPackage};

import com.github.zuihou.base.BaseEnum;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.Getter;

import java.util.stream.Stream;

<#assign tableComment="${table.comment!}"/>
<#if table.comment!?length gt 0>
    <#if table.comment!?contains("\n") >
        <#assign tableComment="${table.comment!?substring(0,table.comment?index_of('\n'))?trim}"/>
    </#if>
</#if>
/**
 * <p>
 * 实体注释中生成的类型枚举
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
@Getter
@AllArgsConstructor
@NoArgsConstructor
@ApiModel(value = "${enumCustom.enumName}", description = "${enumCustom.comment}-枚举")
public enum ${enumCustom.enumName} implements BaseEnum {

    <#list enumCustom.list?keys as key>
    /**
     * ${key?upper_case}=<#list enumCustom.list[key] as des><#if enumCustom.firstTypeNumber=="false">"${des?trim}"<#else >${des?trim}</#if></#list>
     */
    ${key?upper_case}(<#list enumCustom.list[key] as des><#if des_index == 0 && enumCustom.firstTypeNumber=="true">${des?trim}<#else>"${des?trim}"</#if><#if des_has_next>,</#if></#list>),
    </#list>
    ;

<#list enumCustom.list?keys as key>
<#list enumCustom.list[key] as des>
    <#if des_index == 0>
    @ApiModelProperty(value = "描述")
    </#if>
    private <#if des_index == 0 && enumCustom.firstTypeNumber=="true">int<#else >String</#if> <#if des_index == 0 && (enumCustom.list[key]?size == 1)>desc<#elseif des_index == 0 && (enumCustom.list[key]?size > 1)>val<#elseif des_index == 1 >desc<#else>other${enumCustom.list?size}</#if>;

</#list>
<#break>
</#list>

    /**
     * 跟就当前枚举的name匹配
     */
    public static ${enumCustom.enumName} match(String val, ${enumCustom.enumName} def) {
        return Stream.of(values()).parallel().filter((item) -> item.name().equalsIgnoreCase(val)).findAny().orElse(def);
    }

    public static ${enumCustom.enumName} get(String val) {
        return match(val, null);
    }

    public boolean eq(${enumCustom.enumName} val) {
        return val == null ? false : eq(val.name());
    }

    @Override
    @ApiModelProperty(value = "编码", allowableValues = "<#list enumCustom.list?keys as key>${key?upper_case}<#if key_has_next>,</#if></#list>", example = "${enumCustom.list?keys[0]?upper_case}")
    public String getCode() {
        return this.name();
    }

}
