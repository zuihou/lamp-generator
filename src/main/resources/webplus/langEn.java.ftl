export default {
  table: { title: '${entity} list' },
  id: 'ID',
<#list table.fields as field>
    <#assign myPropertyName="${field.propertyName}"/>
  ${myPropertyName}: '${myPropertyName}',
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  label: 'label',
  parentId: 'parentId',
  sortValue: 'sortValue',
</#if>
};
