package ${cfg.DTO};

<#list table.importPackages as pkg>
import ${pkg};
</#list>
<#if swagger2>
import io.swagger.annotations.ApiModel;
</#if>
import ${package.Entity}.${entity};
<#if entityLombokModel>
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;
import lombok.ToString;
import lombok.experimental.Accessors;

</#if>
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
@Accessors(chain = true)
@ToString(callSuper = true)
@EqualsAndHashCode(callSuper = false)
</#if>
<#if swagger2>
    @ApiModel(value = "${entity}DTO", description = "${table.comment!?replace("\r\n"," ")?replace("\r"," ")?replace("\n"," ")}")
</#if>
public class ${entity}DTO extends ${entity} implements Serializable {

    /**
     * 在DTO中新增并自定义字段，需要覆盖验证的字段，请新建DTO。Entity中的验证规则可以自行修改，但下次生成代码时，记得同步代码！！
     */
    private static final long serialVersionUID = 1L;

    public static ${entity}DTO build() {
        return new ${entity}DTO();
    }

}
