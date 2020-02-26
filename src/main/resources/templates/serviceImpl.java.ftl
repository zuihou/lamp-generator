package ${package.ServiceImpl};

import ${package.Mapper}.${table.mapperName};
import ${package.Entity}.${entity};
import ${package.Service}.${table.serviceName};
import ${superServiceImplClassPackage};

import lombok.extern.slf4j.Slf4j;
import org.springframework.aop.framework.AopContext;
import org.springframework.cache.annotation.CacheConfig;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 业务实现类
 * ${table.comment!?replace("\n","\n * ")}
 * </p>
 *
 * @author ${author}
 * @date ${date}
 */
@Slf4j
@Service
@CacheConfig(cacheNames = ${table.serviceImplName}.${entity?upper_case})
<#if kotlin>
open class ${table.serviceImplName} : ${superServiceImplClass}<${table.mapperName}, ${entity}>(), ${table.serviceName} {

}
<#else>
public class ${table.serviceImplName} extends ${superServiceImplClass}<${table.mapperName}, ${entity}> implements ${table.serviceName} {

    protected static final String ${entity?upper_case} = "${entity?lower_case}";

    private String classSimpleName = "";

    public ${table.serviceImplName}() {
        this.classSimpleName = this.getClass().getSimpleName();
    }

    @Override
    protected String getRegion() {
        return ${entity?upper_case};
    }

    @Override
    protected String getClassSimpleName() {
        return classSimpleName;
    }

    protected ${table.serviceName} currentProxy() {
        return ((${table.serviceName}) AopContext.currentProxy());
    }


}
</#if>
