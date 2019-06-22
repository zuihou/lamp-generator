<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${package.Mapper}.${table.mapperName}">

<#if enableCache>
    <!-- 开启二级缓存 -->
    <cache type="org.mybatis.caches.ehcache.LoggingEhcache"/>

</#if>
<#if baseResultMap>
    <!-- 通用查询映射结果 -->
    <resultMap id="BaseResultMap" type="${package.Entity}.${entity}">
<#list table.fields as field>
<#if field.keyFlag><#--生成主键排在第一位-->
    <#if field.type?starts_with("int")>
        <id column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <id column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext")>
        <id column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
        <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <id column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
        <#else>
        <id column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
        </#if>
    </#if>
</#if>
</#list>
<#list table.commonFields as field><#--生成公共字段 -->
    <#if field.keyFlag>
    <#if field.type?starts_with("int")>
        <id column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <id column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext")>
        <id column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
        <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <id column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
        <#else>
        <id column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
        </#if>
    </#if>
    <#else>
    <#if field.type?starts_with("int")>
        <result column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <result column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext") || field.type?starts_with("mediumtext")>
        <result column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
        <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <result column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
        <#else>
        <result column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
        </#if>
    </#if>
    </#if>
</#list>
<#list table.fields as field>
<#if !field.keyFlag><#--生成普通字段 -->
    <#if field.type?starts_with("int")>
        <result column="${field.name}" jdbcType="INTEGER" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("datetime")>
        <result column="${field.name}" jdbcType="TIMESTAMP" property="${field.propertyName}"/>
    <#elseif field.type?starts_with("text") || field.type?starts_with("longtext") || field.type?starts_with("mediumtext")>
        <result column="${field.name}" jdbcType="LONGVARCHAR" property="${field.propertyName}"/>
    <#else>
    <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
        <result column="${field.name}" jdbcType="${fType}" property="${field.propertyName}"/>
    <#else>
        <result column="${field.name}" jdbcType="${field.type?upper_case}" property="${field.propertyName}"/>
    </#if>
    </#if>
</#if>
</#list>
    </resultMap>

</#if>
<#if baseColumnList>
    <!-- 通用查询结果列 -->
    <sql id="Base_Column_List">
        <#list table.commonFields as field>${field.name}, </#list>
        ${table.fieldNames}
    </sql>

</#if>
</mapper>
