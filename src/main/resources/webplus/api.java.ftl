import { ${entity}SaveDTO, ${entity}UpdateDTO, ${entity}, ${entity}PageQuery } from './model/${entity?uncap_first}Model';
import { PageParams, PageResult } from '/@/api/model/baseModel';
import { defHttp } from '/@/utils/http/axios';
<#if cfg.isGenerateExportApi>
import type { UploadFileParams } from '/@/utils/http/axios/types';
</#if>
import { RequestEnum } from '/@/enums/httpEnum';
import { ServicePrefixEnum } from '/@/enums/commonEnum';
import type { AxiosRequestConfig } from 'axios';

export const Api = {
  Page: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}/page',
    method: RequestEnum.POST,
  } as AxiosRequestConfig,
<#if cfg.pageMode == "Tree">
  Tree: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}/tree',
    method: RequestEnum.POST,
  } as AxiosRequestConfig,
</#if>
  Save: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}',
    method: RequestEnum.POST,
  } as AxiosRequestConfig,
  Update: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}',
    method: RequestEnum.PUT,
  },
  Delete: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}',
    method: RequestEnum.DELETE,
  } as AxiosRequestConfig,
  Query: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}/query',
    method: RequestEnum.POST,
  } as AxiosRequestConfig,
<#if cfg.isGenerateExportApi>
  Preview: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}/preview',
    method: RequestEnum.POST,
  } as AxiosRequestConfig,
  Export: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}/export',
    method: RequestEnum.POST,
    responseType: 'blob',
  } as AxiosRequestConfig,
  Import: {
    url: ServicePrefixEnum.${cfg.serviceName?upper_case} + '/${entity?uncap_first}/import',
    method: RequestEnum.POST,
  } as AxiosRequestConfig,
</#if>
};<#---->

<#if cfg.pageMode == "Tree">
export const tree = (params?: ${entity}PageQuery) => defHttp.request<${entity}>({ ...Api.Tree, params });

</#if>
export const page = (params: PageParams<${entity}PageQuery>) =>
  defHttp.request<PageResult<${entity}>>({ ...Api.Page, params });

export const query = (params: ${entity}) => defHttp.request<${entity}[]>({ ...Api.Query, params });

export const save = (params: ${entity}SaveDTO) => defHttp.request<${entity}>({ ...Api.Save, params });

export const update = (params: ${entity}UpdateDTO) =>
  defHttp.request<${entity}>({ ...Api.Update, params });

export const remove = (params: string[]) => defHttp.request<boolean>({ ...Api.Delete, params });
<#if cfg.isGenerateExportApi>

export const exportPreview = (params: PageParams<${entity}PageQuery>) =>
  defHttp.request<string>({ ...Api.Preview, params });

export const exportFile = (params: PageParams<${entity}PageQuery>) =>
  defHttp.request<any>({ ...Api.Export, params }, { isReturnNativeResponse: true });

export const importFile = (params: UploadFileParams) =>
  defHttp.uploadFile<boolean>({ ...Api.Import }, params);
</#if>
