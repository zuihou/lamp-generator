<template>
  <PageWrapper dense contentFullHeight fixedHeight contentClass="flex">
    <BasicTable @register="registerTable">
      <template #toolbar>
<#if cfg.isGenerateExportApi>
        <a-button type="primary" @click="handleImport">导入</a-button>
        <a-button type="primary" @click="handleExport">导出</a-button>
</#if>
        <a-button type="primary" @click="handleBatchDelete">删除</a-button>
        <a-button type="primary" @click="handleAdd">新增</a-button>
      </template>
      <template #action="{ record }">
        <TableAction
          :actions="[
            {
              label: '编辑',
              onClick: handleEdit.bind(null, record),
            },
            {
              label: '复制',
              onClick: handleCopy.bind(null, record),
            },
            {
              label: '删除',
              color: 'error',
              popConfirm: {
                title: t('common.tips.confirmDelete'),
                confirm: handleDelete.bind(null, record),
              },
            },
          ]"
        />
      </template>
    </BasicTable>
    <EditModal @register="registerDrawer" @success="handleSuccess" />
<#if cfg.isGenerateExportApi>
    <PreviewExcelModel
      width="70%"
      @register="exportRegister"
      @success="handleExportSuccess"
      :exportApi="exportFile"
      :previewApi="exportPreview"
    />
    <ImpExcelModel
      @register="importRegister"
      @success="handleImportSuccess"
      :api="importFile"
      templateHref=""
    />
</#if>
  </PageWrapper>
</template>
<script lang="ts">
  import { defineComponent } from 'vue';
  import { useI18n } from '/@/hooks/web/useI18n';
  import { useMessage } from '/@/hooks/web/useMessage';
  import { BasicTable, useTable, TableAction } from '/@/components/Table';
  import { PageWrapper } from '/@/components/Page';
  import { useDrawer } from '/@/components/Drawer';
  <#if cfg.isGenerateExportApi>
  import { useModal } from '/@/components/Modal';
  import { ImpExcelModel, PreviewExcelModel } from '/@/components/Poi';
  </#if>
  import { handleSearchInfoByCreateTime } from '/@/utils/${cfg.projectPrefix}/common';
  import { ActionEnum } from '/@/enums/commonEnum';
  <#if cfg.isGenerateExportApi>
  import { page, remove, importFile, exportFile, exportPreview } from '/@/api/${cfg.projectPrefix}/${cfg.childPackageName}/${entity?uncap_first}';
  <#else>
  import { page, remove } from '/@/api/${cfg.projectPrefix}/${cfg.childPackageName}/${entity?uncap_first}';
  </#if>
  import { columns, searchFormSchema } from './${entity?uncap_first}.data';
  import EditModal from './Edit.vue';

  export default defineComponent({
    name: '${entity}Management',
    <#if cfg.isGenerateExportApi>
    components: {
      BasicTable,
      PageWrapper,
      EditModal,
      TableAction,
      ImpExcelModel,
      PreviewExcelModel,
    },
    <#else>
    components: { BasicTable, PageWrapper, EditModal, TableAction },
    </#if>
    setup() {
      const { t } = useI18n();
      const { createMessage, createConfirm } = useMessage();
      // 编辑页弹窗
      const [registerDrawer, { openDrawer }] = useDrawer();

      // 表格
      const [registerTable, { reload, getSelectRowKeys<#if cfg.isGenerateExportApi>, getForm</#if> }] = useTable({
        title: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.table.title'),
        api: page,
        columns,
        formConfig: {
          labelWidth: 120,
          schemas: searchFormSchema,
        },
        handleSearchInfoFn: handleSearchInfoByCreateTime,
        useSearchForm: true,
        showTableSetting: true,
        bordered: true,
        rowKey: 'id',
        rowSelection: {
          type: 'checkbox',
        },
        actionColumn: {
          width: 160,
          title: t('common.column.action'),
          dataIndex: 'action',
          slots: { customRender: 'action' },
        },
      });

      // 弹出复制页面
      function handleCopy(record: Recordable, e) {
        e.stopPropagation();
        openModal(true, {
          record,
          type: ActionEnum.COPY,
        });
      }

      // 弹出新增页面
      function handleAdd() {
        openDrawer(true, {
          type: ActionEnum.ADD,
        });
      }

      // 弹出编辑页面
      function handleEdit(record: Recordable, e) {
        e.stopPropagation();
        openDrawer(true, {
          record,
          type: ActionEnum.EDIT,
        });
      }

      // 新增或编辑成功回调
      function handleSuccess() {
        reload();
      }

      async function batchDelete(ids: any[]) {
        await remove(ids);
        createMessage.success(t('common.tips.deleteSuccess'));
        handleSuccess();
      }

      // 点击单行删除
      function handleDelete(record: Recordable, e) {
        e.stopPropagation();
        if (record?.id) {
          batchDelete([record.id]);
        }
      }

      // 点击批量删除
      function handleBatchDelete() {
        const ids = getSelectRowKeys();
        if (!ids || ids.length <= 0) {
          createMessage.warning(t('common.tips.pleaseSelectTheData'));
          return;
        }
        createConfirm({
          iconType: 'warning',
          content: t('common.tips.confirmDelete'),
          onOk: async () => {
            await batchDelete(ids);
          },
        });
      }

      <#if cfg.isGenerateExportApi>
      // 导入弹窗
      const [importRegister, importModal] = useModal();
      // 导出弹窗
      const [exportRegister, exportModel] = useModal();
      // 导入成功
      function handleImportSuccess(_data) {
        reload();
      }

      // 导出成功
      function handleExportSuccess() {
        reload();
      }

      // 点击导出按钮
      function handleExport() {
        const form = getForm();
        let params = { ...form.getFieldsValue() };
        params = handleSearchInfoByCreateTime(params);
        params.extra = {
          ...{
            fileName: t('${cfg.projectPrefix}.${cfg.childPackageName}.${entity?uncap_first}.table.title'),
          },
          ...params?.extra,
        };
        params.size = 20000;

        exportModel.openModal(true, {
          params,
        });
      }

      return {
        t,
        registerTable,
        registerDrawer,
        handleAdd,
        handleCopy,
        handleEdit,
        handleDelete,
        handleSuccess,
        handleBatchDelete,
        importRegister,
        handleImport: importModal.openModal,
        handleImportSuccess,
        importFile,
        exportRegister,
        handleExport,
        handleExportSuccess,
        exportFile,
        exportPreview,
      };
      <#else>
      return {
        t,
        registerTable,
        registerDrawer,
        handleAdd,
        handleCopy,
        handleEdit,
        handleDelete,
        handleSuccess,
        handleBatchDelete,
      };
      </#if>
    },
  });
</script>
