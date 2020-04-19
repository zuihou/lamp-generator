<template>
  <div class="app-container">
    <div class="filter-container">
    <#list table.fields as field>
      <#assign fType = "${field.type}"/>
      <#if field.type?contains("(")>
        <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
      </#if>
      <#assign myPropertyName="${field.propertyName}"/>
      <#assign htmlType="input"/>
      <#assign isQuery="0"/>
      <#if field.propertyType =="String">
        <#if field.customMap??>
          <#if field.customMap.Null == "NO"><#assign isQuery="1"/></#if>
          <#if field.customMap.info??>
            <#if field.customMap.info.htmlType??><#assign htmlType="${field.customMap.info.htmlType}"/></#if>
            <#if field.customMap.info.isQuery??><#assign isQuery="${field.customMap.info.isQuery}"/></#if>
          </#if>
        </#if>
      </#if>
      <#if field.customMap?? && field.customMap.annotation??>
        <#if field.propertyName?ends_with("Id")>
          <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
        </#if>
      </#if>
      <#if isQuery == "1">
      <el-${htmlType}
        :placeholder="$t('table.${entity?uncap_first}.${myPropertyName}')"
        class="filter-item search-item"
        v-model="queryParams.model.${field.propertyName}"
      />
      </#if>
    </#list>

      <el-date-picker :range-separator="null" class="filter-item search-item date-range-item"
                      end-placeholder="结束日期" format="yyyy-MM-dd HH:mm:ss" start-placeholder="开始日期"
                      type="daterange" v-model="queryParams.timeRange" value-format="yyyy-MM-dd HH:mm:ss"
      />
      <el-button @click="search" class="filter-item" plain type="primary">
        {{ $t("table.search") }}
      </el-button>
      <el-button @click="reset" class="filter-item" plain type="warning">
        {{ $t("table.reset") }}
      </el-button>
      <el-button @click="add" class="filter-item" plain type="danger" v-has-permission="['${entity?uncap_first}:add']">
        {{ $t("table.add") }}
      </el-button>
      <el-dropdown class="filter-item" trigger="click" v-has-any-permission="['${entity?uncap_first}:delete', '${entity?uncap_first}:export',
        '${entity?uncap_first}:import']">
        <el-button>
          {{ $t("table.more") }}<i class="el-icon-arrow-down el-icon--right" />
        </el-button>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item @click.native="batchDelete" v-has-permission="['${entity?uncap_first}:delete']">
            {{ $t("table.delete") }}
          </el-dropdown-item>
          <el-dropdown-item @click.native="exportExcel" v-has-permission="['${entity?uncap_first}:export']">
            {{ $t("table.export") }}
          </el-dropdown-item>
          <el-dropdown-item @click.native="exportExcelPreview" v-has-permission="['${entity?uncap_first}:export']">
            {{ $t("table.exportPreview") }}
          </el-dropdown-item>
          <el-dropdown-item @click.native="importExcel" v-has-permission="['${entity?uncap_first}:import']">
            {{ $t("table.import") }}
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>

    <el-table :data="tableData.records" :key="tableKey" @cell-click="cellClick"
              @filter-change="filterChange" @selection-change="onSelectChange" @sort-change="sortChange"
              border fit row-key="id" ref="table" style="width: 100%;" v-loading="loading">
      <el-table-column align="center" type="selection" width="40px" :reserve-selection="true"/>
      <#list table.fields as field>
      <#assign fType = "${field.type}"/>
      <#if field.type?contains("(")>
          <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
      </#if>
      <#assign isList="1"/>
      <#assign width=""/>
      <#assign myPropertyName="${field.propertyName}"/>
      <#assign labelPropertyName="${field.propertyName}"/>
      <#-- 自动计算 -->
      <#if field.propertyType =="String">
      </#if>
      <#-- 手动填写的覆盖进来 -->
      <#if field.customMap??>
          <#if field.customMap.Null == "NO"><#assign isQuery="1"/></#if>
          <#if field.customMap.info??>
              <#if field.customMap.info.isList??><#assign isList="${field.customMap.info.isList}"/></#if>
              <#if field.customMap.info.width??><#assign width="${field.customMap.info.width}"/></#if>
          </#if>
      </#if>
      <#if field.customMap?? && field.customMap.annotation??>
        <#if field.propertyName?ends_with("Id")>
          <#assign labelPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
        </#if>
      </#if>
      <#if isList =="1">
      <el-table-column :label="$t('table.${entity?uncap_first}.${labelPropertyName}')" :show-overflow-tooltip="true" align="center" prop="${labelPropertyName}"
                       <#if fType == "BIT">
                       :filter-multiple="false" column-key="${myPropertyName}"
                       <#if myPropertyName == "status">
                       :filters="[{ text: $t('common.status.valid'), value: true },{ text: $t('common.status.invalid'), value: false }]"
                       <#else >
                       :filters="[{ text: $t('common.yes'), value: 'true' }, { text: $t('common.no'), value: 'false' }]"
                       </#if>
                       </#if>
                  <#if field.customMap?? && field.customMap.info?? && field.customMap.info.enumType??>
                        :filter-multiple="false" column-key="${myPropertyName}.code" :filters="${myPropertyName}List"
                  <#elseif field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
                        :filter-multiple="false" column-key="${myPropertyName}.key" :filters="${myPropertyName}List"
                  </#if>
                        <#if field.propertyType =="LocalDate">width="110"<#elseif field.propertyType =="LocalDateTime">width="170"<#else>width="${width}"</#if>>
        <template slot-scope="scope">
          <#if fType == "BIT">
            <#if myPropertyName == "status">
          <el-tag :type="scope.row.${myPropertyName} ? 'success' : 'danger'" slot>
            {{ scope.row.status ? $t("common.status.valid") : $t("common.status.invalid") }}
          </el-tag>
            <#else >
          <el-tag :type="scope.row.${myPropertyName} ? 'success' : 'danger'" slot>
            {{ scope.row.${myPropertyName} ? $t("common.yes") : $t("common.no") }}
          </el-tag>
            </#if>
          <#elseif field.customMap.isEnum?? && field.customMap.isEnum == "1">
            <span>{{ scope.row.${myPropertyName} ? scope.row.${myPropertyName}['desc'] : ''}}</span>
          <#elseif field.customMap.annotation??>
            <#if field.propertyName?ends_with("Id")>
              <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
            <span>
              {{ scope.row.${myPropertyName}['data'] && scope.row.${myPropertyName}['data']['name'] ? scope.row.${myPropertyName}['data']['name'] : scope.row.${myPropertyName}.key }}
            </span>
            <#else >
            <span>
              {{ scope.row.${myPropertyName}['data'] ? scope.row.${myPropertyName}.data : scope.row.${myPropertyName}.key }}
            </span>
            </#if>
          <#else>
          <span>{{ scope.row.${myPropertyName} }}</span>
          </#if>
        </template>
      </el-table-column>
      </#if>
      </#list>
      <el-table-column
        :label="$t('table.createTime')"
        align="center"
        prop="createTime"
        sortable="custom"
        width="170px">
        <template slot-scope="scope">
          <span>{{ scope.row.createTime }}</span>
        </template>
      </el-table-column>
      <el-table-column
        :label="$t('table.operation')" align="center" column-key="operation" class-name="small-padding fixed-width" width="100px">
        <template slot-scope="{ row }">
          <i @click="copy(row)" class="el-icon-copy-document table-operation" :title="$t('common.delete')"
             style="color: #2db7f5;" v-hasPermission="['${entity?uncap_first}:add']"/>
          <i @click="edit(row)" class="el-icon-edit table-operation" :title="$t('common.delete')"
             style="color: #2db7f5;" v-hasPermission="['${entity?uncap_first}:update']"/>
          <i @click="singleDelete(row)" class="el-icon-delete table-operation" :title="$t('common.delete')"
             style="color: #f50;" v-hasPermission="['${entity?uncap_first}:delete']"/>
          <el-link class="no-perm" v-has-no-permission="['${entity?uncap_first}:update', '${entity?uncap_first}:copy', '${entity?uncap_first}:delete']">
            {{ $t("tips.noPermission") }}
          </el-link>
        </template>
      </el-table-column>
    </el-table>
    <pagination :limit.sync="queryParams.size" :page.sync="queryParams.current"
      :total="Number(tableData.total)" @pagination="fetch" v-show="tableData.total > 0"/>
    <${entity?uncap_first}-edit :dialog-visible="dialog.isVisible" :type="dialog.type"
            @close="editClose" @success="editSuccess" ref="edit"/>
    <${entity?uncap_first}-import ref="import" :dialog-visible="fileImport.isVisible" :type="fileImport.type"
            :action="fileImport.action" accept=".xls,.xlsx" @close="importClose" @success="importSuccess" />
    <el-dialog :close-on-click-modal="false" :close-on-press-escape="true"
               title="预览" width="80%" top="50px" :visible.sync="preview.isVisible" v-el-drag-dialog>
      <el-scrollbar>
        <div v-html="preview.context"></div>
      </el-scrollbar>
    </el-dialog>
  </div>
</template>

<script>
import Pagination from "@/components/Pagination";
import elDragDialog from '@/directive/el-drag-dialog'
import ${entity}Edit from "./Edit";
import ${entity?uncap_first}Api from "@/api/${entity}.js";
import ${entity}Import from "@/components/zuihou/Import"
import {convertEnum} from '@/utils/utils'
import {downloadFile, loadEnums, initDicts, initQueryParams} from '@/utils/commons'

export default {
  name: "${entity}Manage",
  directives: { elDragDialog },
  components: { Pagination, ${entity}Edit, ${entity}Import},
  filters: {

  },
  data() {
    return {
      // 编辑
      dialog: {
          isVisible: false,
          type: "add"
      },
      // 预览
      preview: {
        isVisible: false,
        context: ''
      },
      // 导入
      fileImport: {
        isVisible: false,
        type: "import",
        action: `${r'${'}process.env.VUE_APP_BASE_API${r'}'}/${cfg.serviceName}/${entity?uncap_first}/import`
      },
      tableKey: 0,
      queryParams: initQueryParams(),
      selection: [],
      loading: false,
      tableData: {
          total: 0
      },
      // 枚举
      enums: {
        <#list table.fields as field>
        <#if field.customMap?? && field.customMap.info?? && field.customMap.info.enumType??>
        ${field.customMap.info.enumType}: {},
        </#if>
        </#list>
      },
      // 字典
      dicts: {
        <#list table.fields as field>
        <#if field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
        ${field.customMap.info.dictType}: {},
        </#if>
        </#list>
      }
    };
  },
  computed: {
    <#list table.fields as field>
    <#if field.customMap?? && field.customMap.info?? && field.customMap.info.enumType??>
    ${field.propertyName}List() {
      return convertEnum(this.enums.${field.customMap.info.enumType})
    },
    <#elseif field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
    ${field.propertyName}List() {
      return convertEnum(this.dicts.${field.customMap.info.dictType})
    },
    </#if>
    </#list>
  },
  watch: {
  },
  mounted() {
    this.fetch();

    // 初始化字典和枚举
    const enumList = [];
    const dictList = [];
    <#list table.fields as field>
    <#if field.customMap?? && field.customMap.info?? && field.customMap.info.enumType??>
    enumList.push('${field.customMap.info.enumType}');
    <#elseif field.customMap?? && field.customMap.info?? && field.customMap.info.dictType??>
    dictList.push('${field.customMap.info.dictType}');
    </#if>
    </#list>
    loadEnums(enumList, this.enums, '${cfg.serviceName}');
    initDicts(dictList, this.dicts);
  },
  methods: {
    editClose() {
      this.dialog.isVisible = false;
    },
    editSuccess() {
      this.search();
    },
    onSelectChange(selection) {
      this.selection = selection;
    },
    search() {
      this.fetch({
          ...this.queryParams
      });
    },
    reset() {
      this.queryParams = initQueryParams();
      this.$refs.table.clearSort();
      this.$refs.table.clearFilter();
      this.search();
    },
    exportExcelPreview() {
      if (this.queryParams.timeRange) {
        this.queryParams.map.createTime_st = this.queryParams.timeRange[0];
        this.queryParams.map.createTime_ed = this.queryParams.timeRange[1];
      }
      this.queryParams.map.fileName = '导出数据';
      ${entity?uncap_first}Api.preview(this.queryParams).then(response => {
        const res = response.data;
        this.preview.isVisible = true;
        this.preview.context = res.data;
      });
    },
    exportExcel() {
      if (this.queryParams.timeRange) {
        this.queryParams.map.createTime_st = this.queryParams.timeRange[0];
        this.queryParams.map.createTime_ed = this.queryParams.timeRange[1];
      }
      this.queryParams.map.fileName = '导出数据';
      ${entity?uncap_first}Api.export(this.queryParams).then(response => {
        downloadFile(response);
      });
    },
    importExcel() {
      this.fileImport.type = "upload";
      this.fileImport.isVisible = true;
      this.$refs.import.setModel(false);
    },
    importSuccess() {
      this.search();
    },
    importClose() {
      this.fileImport.isVisible = false;
    },
    singleDelete(row) {
      this.$refs.table.clearSelection()
      this.$refs.table.toggleRowSelection(row, true);
      this.batchDelete();
    },
    batchDelete() {
      if (!this.selection.length) {
        this.$message({
            message: this.$t("tips.noDataSelected"),
            type: "warning"
        });
        return;
      }
      this.$confirm(this.$t("tips.confirmDelete"), this.$t("common.tips"), {
          confirmButtonText: this.$t("common.confirm"),
          cancelButtonText: this.$t("common.cancel"),
          type: "warning"
      })
      .then(() => {
        const ids = this.selection.map(u => u.id);
        this.delete(ids);
      })
      .catch(() => {
        this.clearSelections();
      });
    },
    clearSelections() {
      this.$refs.table.clearSelection();
    },
    delete(ids) {
      ${entity?uncap_first}Api.delete({ ids: ids }).then(response => {
        const res = response.data;
        if (res.isSuccess) {
          this.$message({
              message: this.$t("tips.deleteSuccess"),
              type: "success"
          });
          this.search();
        }
      });
    },
    add() {
      this.dialog.type = "add";
      this.dialog.isVisible = true;
      this.$refs.edit.set${entity}({ enums: this.enums, dicts: this.dicts});
    },
    copy(row) {
      this.$refs.edit.set${entity}({row, enums: this.enums, dicts: this.dicts});
      this.dialog.type = "copy";
      this.dialog.isVisible = true;
    },
    edit(row) {
      this.$refs.edit.set${entity}({row, enums: this.enums, dicts: this.dicts});
      this.dialog.type = "edit";
      this.dialog.isVisible = true;
    },
    fetch(params = {}) {
      this.loading = true;
      if (this.queryParams.timeRange) {
        this.queryParams.map.createTime_st = this.queryParams.timeRange[0];
        this.queryParams.map.createTime_ed = this.queryParams.timeRange[1];
      }

      this.queryParams.current = params.current ? params.current : this.queryParams.current;
      this.queryParams.size = params.size ? params.size : this.queryParams.size;

      ${entity?uncap_first}Api.page(this.queryParams).then(response => {
        const res = response.data;
        if (res.isSuccess) {
          this.tableData = res.data;
        }
      }).finally(() => this.loading = false);
    },
    sortChange(val) {
      this.queryParams.sort = val.prop;
      this.queryParams.order = val.order;
      if (this.queryParams.sort) {
        this.search();
      }
    },
    filterChange (filters) {
      for (const key in filters) {
        if(key.includes('.')) {
          const val = { };
          val[key.split('.')[1]] = filters[key][0];
          this.queryParams.model[key.split('.')[0]] = val;
        } else {
          this.queryParams.model[key] = filters[key][0]
        }
      }
      this.search()
    },
    cellClick (row, column) {
      if (column['columnKey'] === "operation") {
        return;
      }
      let flag = false;
      this.selection.forEach((item)=>{
        if(item.id === row.id) {
          flag = true;
          this.$refs.table.toggleRowSelection(row);
        }
      })

      if(!flag){
        this.$refs.table.toggleRowSelection(row, true);
      }
    },
  }
};
</script>
<style lang="scss" scoped></style>
