package ${package.Mapper};

import ${superMapperClassPackage};
import ${package.Entity}.${entity};

import org.springframework.stereotype.Repository;

/**
 * <p>
 * Mapper 接口
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
@Repository
<#if kotlin>
interface ${table.mapperName} : ${superMapperClass}<${entity}>
<#else>
public interface ${table.mapperName} extends ${superMapperClass}<${entity}> {

}
</#if>
