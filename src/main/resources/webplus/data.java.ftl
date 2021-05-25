<#list table.fields as field>
  <#if field.propertyType =="LocalDateTime" || field.propertyType =="LocalDate" || field.propertyType =="LocalTime">
import moment from 'moment';
    <#break>
  </#if>
</#list>
import { <#if cfg.pageMode != "Tree">BasicColumn, </#if>FormSchema } from '/@/components/Table';
import { useI18n } from '/@/hooks/web/useI18n';
<#list table.fields as field>
<#assign myPropertyType="${field.propertyType}"/>
<#list cfg.filedTypes as fieldType>
  <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
    <#assign myPropertyType="Enum"/>
  </#if>
</#list>
<#if myPropertyType =="Enum">
import { findEnumLists } from '/@/api/${cfg.projectPrefix}/common/general';
    <#break>
</#if>
</#list>
<#list table.fields as field>
  <#if field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
import { findDictList } from '/@/api/${cfg.projectPrefix}/common/general';
    <#break>
  </#if>
</#list>
import { FormSchemaExt } from '/@/api/${cfg.projectPrefix}/common/formValidateService';

const { t } = useI18n();
<#if cfg.pageMode != "Tree">
// 列表页字段
export const columns: BasicColumn[] = [
<#list table.fields as field>
<#assign myPropertyName="${field.propertyName}"/>
<#assign isList="1"/>
<#if field.customMap.info??>
  <#assign isList="${field.customMap.info.isList!'1'}"/>
</#if>
<#if isList =="1">
  {
    title: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.${myPropertyName}'),
    dataIndex: '${myPropertyName}',
    // width: 180,
  },
</#if>
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  {
    title: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.label'),
    dataIndex: 'label',
  },
  {
    title: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.sortValue'),
    dataIndex: 'sortValue',
    width: 40,
  },
</#if>
  {
    title: t('${cfg.projectPrefix}.common.createTime'),
    dataIndex: 'createTime',
    sorter: true,
    width: 180,
  },
];

export const searchFormSchema: FormSchema[] = [
<#list table.fields as field>
<#assign myPropertyName="${field.propertyName}"/>
<#assign myPropertyType="${field.propertyType}"/>
<#list cfg.filedTypes as fieldType>
  <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
    <#assign myPropertyType="Enum"/>
  </#if>
</#list>
<#assign isQuery="0"/>
<#assign htmlType="Input"/><#-- 输入框 -->
<#if myPropertyType =="String">
  <#assign htmlType="Input"/>
  <#assign fType = "${field.type}"/>
  <#if field.type?contains("(")>
    <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
  </#if>
  <#if fType?index_of("TEXT") != -1>
    <#assign inputType="InputTextArea"/>
  </#if>
<#elseif myPropertyType =="LocalDate" || myPropertyType =="LocalDateTime">
  <#assign htmlType="DatePicker"/>
<#elseif myPropertyType =="LocalTime">
  <#assign htmlType="TimePicker"/>
<#elseif myPropertyType =="Boolean">
  <#assign htmlType="RadioButtonGroup"/>
<#elseif myPropertyType =="Long">
  <#assign htmlType="Input"/>
</#if>
<#assign enumType=""/>
<#assign dictType=""/>
<#if field.customMap.info??>
  <#assign htmlType="${field.customMap.info.htmlType!'${htmlType}'}"/><#-- 输入框 -->
  <#assign enumType="${field.customMap.info.enumType!''}"/>
  <#assign dictType="${field.customMap.info.dictType!''}"/>
  <#assign isQuery="${field.customMap.info.isQuery!'0'}"/>
</#if>
<#if isQuery =="1">
  {
    label: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.${myPropertyName}'),
    field: '${myPropertyName}',
    component: '${htmlType}',
<#if myPropertyType =="LocalDateTime">
    componentProps: {
      format: 'YYYY-MM-DD HH:mm:ss',
      valueFormat: 'YYYY-MM-DD HH:mm:ss',
      showTime: { defaultValue: moment('00:00:00', 'HH:mm:ss') },
    },
<#elseif myPropertyType =="LocalDate">
    componentProps: {
      format: 'YYYY-MM-DD',
      valueFormat: 'YYYY-MM-DD',
      showTime: { defaultValue: moment('00:00:00', 'HH:mm:ss') },
    },
<#elseif myPropertyType =="LocalTime">
    componentProps: {
      format: 'HH:mm:ss',
      valueFormat: 'HH:mm:ss',
      showTime: { defaultValue: moment().format('00:00:00', 'HH:mm:ss') },
    },
<#elseif myPropertyType =="Boolean">
    componentProps: {
      options: [
        { label: t('${cfg.projectPrefix}.common.yes'), value: true },
        { label: t('${cfg.projectPrefix}.common.no'), value: false },
      ],
    },
<#elseif myPropertyType =="Enum">
    componentProps: {
      api: findEnumLists,
      params: ['${enumType}'],
      resultField: '${enumType}',
    },
<#elseif field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
    componentProps: {
      api: findDictList,
      params: ['${dictType}'],
      resultField: '${dictType}',
    },
<#else></#if>
    colProps: { span: 5 },
  },
</#if>
</#list>
  {
    field: 'createTimeRange',
    label: t('${cfg.projectPrefix}.common.createTime'),
    component: 'RangePicker',
    colProps: { span: 6 },
  },
];
</#if>

// 编辑页字段
export const editFormSchema: FormSchema[] = [
  {
    field: 'id',
    label: 'ID',
    component: 'Input',
    show: false,
  },
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  {
    label: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.label'),
    field: 'label',
    component: 'Input',
  },
</#if>
<#list table.fields as field>
<#assign myPropertyName="${field.propertyName}"/>
<#assign myPropertyType="${field.propertyType}"/>
<#list cfg.filedTypes as fieldType>
  <#if fieldType.name == field.propertyName && table.name==fieldType.table && field.propertyType=="String">
    <#assign myPropertyType="Enum"/>
  </#if>
</#list>
<#assign isEdit="1"/>
<#assign htmlType="Input"/><#-- 输入框 -->
<#if myPropertyType =="String">
  <#assign htmlType="Input"/>
  <#assign fType = "${field.type}"/>
  <#if field.type?contains("(")>
    <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
  </#if>
  <#if fType?index_of("TEXT") != -1>
    <#assign inputType="InputTextArea"/>
  </#if>
<#elseif myPropertyType =="LocalDate" || myPropertyType =="LocalDateTime">
  <#assign htmlType="DatePicker"/>
<#elseif myPropertyType =="LocalTime">
  <#assign htmlType="TimePicker"/>
<#elseif myPropertyType =="Boolean">
  <#assign htmlType="RadioButtonGroup"/>
<#elseif myPropertyType =="Long">
  <#assign htmlType="Input"/>
</#if>
<#assign enumType=""/>
<#assign dictType=""/>
<#if field.customMap.info??>
  <#assign isEdit="${field.customMap.info.isEdit!'1'}"/>
  <#assign htmlType="${field.customMap.info.htmlType!'${htmlType}'}"/><#-- 输入框 -->
  <#assign enumType="${field.customMap.info.enumType!''}"/>
  <#assign dictType="${field.customMap.info.dictType!''}"/>
</#if>
<#if isEdit =="1">
  {
    label: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.${myPropertyName}'),
    field: '${myPropertyName}',
    component: '${htmlType}',
<#if myPropertyType =="LocalDateTime">
    componentProps: {
      format: 'YYYY-MM-DD HH:mm:ss',
      valueFormat: 'YYYY-MM-DD HH:mm:ss',
      showTime: { defaultValue: moment('00:00:00', 'HH:mm:ss') },
    },
<#elseif myPropertyType =="LocalDate">
    componentProps: {
      format: 'YYYY-MM-DD',
      valueFormat: 'YYYY-MM-DD',
      showTime: { defaultValue: moment('00:00:00', 'HH:mm:ss') },
    },
<#elseif myPropertyType =="LocalTime">
    componentProps: {
      format: 'HH:mm:ss',
      valueFormat: 'HH:mm:ss',
      showTime: { defaultValue: moment().format('00:00:00', 'HH:mm:ss') },
    },
<#elseif myPropertyType =="Boolean">
    componentProps: {
      options: [
        { label: t('${cfg.projectPrefix}.common.yes'), value: true },
        { label: t('${cfg.projectPrefix}.common.no'), value: false },
      ],
    },
<#elseif myPropertyType =="Enum">
    componentProps: {
      api: findEnumLists,
      params: ['${enumType}'],
      resultField: '${enumType}',
    },
<#elseif field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
    componentProps: {
      api: findDictList,
      params: ['${dictType}'],
      resultField: '${dictType}',
    },
<#else></#if>
  },
</#if>
</#list>
<#if superEntityClass?? && superEntityClass=="TreeEntity">
  {
    label: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.sortValue'),
    field: 'sortValue',
    component: 'InputNumber',
  },
</#if>
];

// 前端自定义表单验证规则
export const customFormSchemaRules = (_): Partial<FormSchemaExt>[] => {
  return [];
};
