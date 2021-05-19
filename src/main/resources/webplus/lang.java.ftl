export default {
<#assign tableComment = "${table.comment!''}"/>
<#if table.comment?? && table.comment!?contains('\n')>
    <#assign tableComment = "${table.comment!?substring(0,table.comment?index_of('\n'))?trim}"/>
</#if>
  table: { title: '${tableComment}列表' },
  id: '主键',
<#list table.fields as field>
    <#assign myPropertyName="${field.propertyName}"/>
    <#assign fieldComment="${field.comment!}"/>
    <#if field.comment!?length gt 0 && field.comment!?contains("\n") >
        <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
    </#if>
  ${myPropertyName}: '${fieldComment}',
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  label: '名称',
  parentId: '父ID',
  sortValue: '排序',
</#if>
};
