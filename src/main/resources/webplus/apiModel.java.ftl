<#assign isEnumType="1"/>
<#list table.fields as field>
<#list cfg.filedTypes as fieldType>
    <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
        <#assign isEnumType="2"/>
        <#break />
    </#if>
</#list>
</#list>
<#if isEnumType=="2">
import { Enum } from '/@/api/model/baseModel';

</#if>
export interface ${entity}PageQuery {
<#list table.fields as field>
<#assign myPropertyName="${field.propertyName}"/>
<#assign myPropertyType="${field.propertyType}"/>
<#list cfg.filedTypes as fieldType>
    <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
        <#assign myPropertyType="Enum"/>
    </#if>
</#list>
  ${myPropertyName}: ${cfg.fieldTypeMapping[myPropertyType]};
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  label: string;
  parentId: string;
  sortValue: number;
</#if>
}

export interface ${entity}SaveDTO {
<#list table.fields as field>
    <#assign myPropertyName="${field.propertyName}"/>
    <#assign myPropertyType="${field.propertyType}"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="Enum"/>
        </#if>
    </#list>
  ${myPropertyName}: ${cfg.fieldTypeMapping[myPropertyType]};
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  label: string;
  parentId: string;
  sortValue: number;
</#if>
}

export interface ${entity}UpdateDTO {
  id: string;
<#list table.fields as field>
    <#assign myPropertyName="${field.propertyName}"/>
    <#assign myPropertyType="${field.propertyType}"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="Enum"/>
        </#if>
    </#list>
  ${myPropertyName}: ${cfg.fieldTypeMapping[myPropertyType]};
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  label: string;
  parentId: string;
  sortValue: number;
</#if>
}

export interface ${entity} {
<#list table.fields as field>
    <#assign myPropertyName="${field.propertyName}"/>
    <#assign myPropertyType="${field.propertyType}"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="Enum"/>
        </#if>
    </#list>
  ${myPropertyName}?: ${cfg.fieldTypeMapping[myPropertyType]};
</#list>
<#list table.commonFields as field>
    <#assign myPropertyName="${field.propertyName}"/>
    <#assign myPropertyType="${field.propertyType}"/>
    <#list cfg.filedTypes as fieldType>
        <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
            <#assign myPropertyType="Enum"/>
        </#if>
    </#list>
  ${myPropertyName}?: ${cfg.fieldTypeMapping[myPropertyType]};
</#list>
  echoMap?: Recordable;
}
