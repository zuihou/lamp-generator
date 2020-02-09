export default {
  table: {
    // 以下复制到en.js
    ${entity?uncap_first}: {
      id: 'ID',
<#list table.fields as field>
<#assign myPropertyName="${field.propertyName}"/>
    <#if field.customMap?? && field.customMap.annotation??>
    <#if field.propertyName?ends_with("Id")>
    <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
    </#if>
    </#if>
      ${myPropertyName}: '${myPropertyName}',
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
      label: 'label',
      parentId: 'parentId',
      sortValue: 'sortValue',
</#if>
    },
    // 以下复制到zh.js
    ${entity?uncap_first}: {
      id: 'ID',
<#list table.fields as field>
<#assign myPropertyName="${field.propertyName}"/>
    <#assign fieldComment="${field.comment!}"/>
    <#if field.comment!?contains("\n") >
        <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
    </#if>
    <#if field.customMap?? && field.customMap.annotation??>
    <#if field.propertyName?ends_with("Id")>
    <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
    </#if>
    </#if>
    <#if fieldComment?default("")?trim?length == 0><#assign fieldComment="${myPropertyName}"/></#if>
      ${myPropertyName}: '${fieldComment}',
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
      label: '名称',
      parentId: '父ID',
      sortValue: '序号',
</#if>
    },
    // 复制之后，删除 lang.js
  },
}
