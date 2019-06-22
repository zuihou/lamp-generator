package ${cfg.Constant};

import java.io.Serializable;

/**
 * <p>
 * 数据库常量
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
public class ${entity}${cfg.constantSuffix} implements Serializable {

    private static final long serialVersionUID = 1L;

    private ${entity}${cfg.constantSuffix}(){
        super();
    }

<#-- 字段常量 -->
<#if entityColumnConstant>
    /**
     * 字段常量
     */
    <#list table.fields as field>
    public static final String ${field.name?upper_case} = "${field.name}";
    </#list>
</#if>

}
