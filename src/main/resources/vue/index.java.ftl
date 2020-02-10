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
        v-model="queryParams.${field.propertyName}"
      />
      </#if>
    </#list>

      <el-date-picker
        :range-separator="null"
        class="filter-item search-item date-range-item"
        end-placeholder="结束日期"
        format="yyyy-MM-dd HH:mm:ss"
        start-placeholder="开始日期"
        type="daterange"
        v-model="queryParams.timeRange"
        value-format="yyyy-MM-dd HH:mm:ss"
      />
      <el-button @click="search" class="filter-item" plain type="primary">
        {{ $t("table.search") }}
      </el-button>
      <el-button @click="reset" class="filter-item" plain type="warning">
        {{ $t("table.reset") }}
      </el-button>
      <el-dropdown class="filter-item" trigger="click" v-has-any-permission="['${entity?uncap_first}:add',
        '${entity?uncap_first}:delete', '${entity?uncap_first}:export']">
        <el-button>
          {{ $t("table.more") }}<i class="el-icon-arrow-down el-icon--right" />
        </el-button>
        <el-dropdown-menu slot="dropdown">
          <el-dropdown-item @click.native="add" v-has-permission="['${entity?uncap_first}:add']">
            {{ $t("table.add") }}
          </el-dropdown-item>
          <el-dropdown-item @click.native="batchDelete" v-has-permission="['${entity?uncap_first}:delete']">
            {{ $t("table.delete") }}
          </el-dropdown-item>
          <el-dropdown-item @click.native="exportExcel" v-has-permission="['${entity?uncap_first}:export']">
            {{ $t("table.export") }}
          </el-dropdown-item>
        </el-dropdown-menu>
      </el-dropdown>
    </div>

    <el-table
      :data="tableData.records"
      :key="tableKey"
      @filter-change="filterChange"
      @selection-change="onSelectChange"
      @sort-change="sortChange"
      border
      fit
      ref="table"
      style="width: 100%;"
      v-loading="loading">
      <el-table-column align="center" type="selection" width="40px" />
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
      <el-table-column :label="$t('table.${entity?uncap_first}.${labelPropertyName}')" :show-overflow-tooltip="true" align="center"
                       <#if fType == "BIT">
                       :filter-multiple="false" column-key="${myPropertyName}"
                       <#if myPropertyName == "status">
                       :filters="[{ text: $t('common.status.valid'), value: true },{ text: $t('common.status.invalid'), value: false }]"
                       <#else >
                       :filters="[{ text: $t('common.yes'), value: 'true' }, { text: $t('common.no'), value: 'false' }]"
                       </#if>
                       </#if>
                       prop="${labelPropertyName}" width="${width}">
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
        :label="$t('table.operation')" align="center" class-name="small-padding fixed-width" width="100px">
        <template slot-scope="{ row }">
          <i @click="copy(row)" class="el-icon-copy-document table-operation" :title="$t('common.delete')"
             style="color: #2db7f5;" v-hasPermission="['${entity?uncap_first}:copy']"/>
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
    <pagination
      :limit.sync="pagination.size"
      :page.sync="pagination.current"
      :total="Number(tableData.total)"
      @pagination="fetch"
      v-show="tableData.total > 0"/>
    <${entity?uncap_first}-edit
      :dialog-visible="dialog.isVisible"
      :type="dialog.type"
      @close="editClose"
      @success="editSuccess"
      ref="edit"/>
  </div>
</template>

<script>
import Pagination from "@/components/Pagination";
import ${entity}Edit from "./Edit";
import ${entity?uncap_first}Api from "@/api/${entity}.js";

export default {
  name: "${entity}Manage",
  components: { Pagination, ${entity}Edit },
  filters: {

  },
  data() {
    return {
      dialog: {
          isVisible: false,
          type: "add"
      },
      tableKey: 0,
      queryParams: {},
      sort: {},
      selection: [],
      loading: false,
      tableData: {
          total: 0
      },
      pagination: {
          size: 10,
          current: 1
      }
    };
  },
  computed: {},
  watch: {
  },
  mounted() {
    this.fetch();
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
          ...this.queryParams,
          ...this.sort
      });
    },
    reset() {
      this.queryParams = {};
      this.sort = {};
      this.$refs.table.clearSort();
      this.$refs.table.clearFilter();
      this.search();
    },
    exportExcel() {
      this.$message({
          message: "待完善",
          type: "warning"
      });
    },
    singleDelete(row) {
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
        }
        this.search();
      });
    },
    add() {
      this.dialog.type = "add";
      this.dialog.isVisible = true;
      this.$refs.edit.set${entity}(false);
    },
    copy(row) {
      this.$refs.edit.set${entity}(row);
      this.dialog.type = "copy";
      this.dialog.isVisible = true;
    },
    edit(row) {
      this.$refs.edit.set${entity}(row);
      this.dialog.type = "edit";
      this.dialog.isVisible = true;
    },
    fetch(params = {}) {
      this.loading = true;
      params.size = this.pagination.size;
      params.current = this.pagination.current;
      if (this.queryParams.timeRange) {
          params.startCreateTime = this.queryParams.timeRange[0];
          params.endCreateTime = this.queryParams.timeRange[1];
      }

      ${entity?uncap_first}Api.page(params).then(response => {
        const res = response.data;
        this.loading = false;
        this.tableData = res.data;
      });
    },
    sortChange(val) {
      this.sort.field = val.prop;
      this.sort.order = val.order;
      this.search();
    },
    filterChange (filters) {
      for (const key in filters) {
        this.queryParams[key] = filters[key][0]
      }
      this.search()
    }
  }
};
</script>
<style lang="scss" scoped></style>
