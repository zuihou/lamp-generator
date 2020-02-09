<template>
  <div class="${entity?uncap_first}">
    <el-row :gutter="10">
      <el-col :sm="12" :xs="24">
        <div class="app-container">
          <div class="filter-container">
            <el-input :placeholder="$t('table.${entity?uncap_first}.label')" class="filter-item search-item" v-model="label"/>
            <el-button @click="search" class="filter-item" plain type="primary">
              {{ $t("table.search") }}
            </el-button>
            <el-button @click="reset" class="filter-item" plain type="warning">
              {{ $t("table.reset") }}
            </el-button>
            <el-dropdown class="filter-item" trigger="click" v-has-any-permission="['${entity?uncap_first}:add', '${entity?uncap_first}:delete', '${entity?uncap_first}:export']">
              <el-button>
                {{ $t("table.more") }}<i class="el-icon-arrow-down el-icon--right"/>
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
          <el-tree
                :check-strictly="true"
                :data="${entity?uncap_first}Tree"
                :filter-node-method="filterNode"
                @node-click="nodeClick"
                :load="loadTree"
                highlight-current
                node-key="id"
                ref="${entity?uncap_first}Tree"
                :lazy="true"
                show-checkbox/>
        </div>
      </el-col>
      <el-col :sm="12" :xs="24">
        <el-card class="box-card">
          <div class="clearfix" slot="header">
            <span>
              {{${entity?uncap_first}.id === "" ? this.$t("common.add") : this.$t("common.edit")}}
            </span>
          </div>
          <div>
            <el-form :model="${entity?uncap_first}" :rules="rules" label-position="right" label-width="100px" ref="form">
              <el-form-item :hidden="true" :label="$t('table.${entity?uncap_first}.parentId')" prop="parentId">
                <el-tooltip :content="$t('tips.topId')" class="item" effect="dark" placement="top-start">
                  <el-input readonly v-model="${entity?uncap_first}.parentId"/>
                </el-tooltip>
              </el-form-item>
              <el-form-item :label="$t('table.${entity?uncap_first}.parentId')" prop="parentLabel">
                <el-input readonly disabled="disabled" v-model="${entity?uncap_first}.parentLabel"/>
              </el-form-item>
              <el-form-item :label="$t('table.${entity?uncap_first}.label')" prop="label">
                <el-input v-model="${entity?uncap_first}.label"/>
              </el-form-item>
              <#list table.fields as field>
                <#assign fType = "${field.type}"/>
                <#if field.type?contains("(")>
                    <#assign fType = field.type?substring(0, field.type?index_of("("))?upper_case/>
                </#if>
                <#assign isInsert="1"/><#-- 是否保存 -->
                <#assign isUpdate="1"/><#-- 是否修改 -->
                <#assign htmlType="input"/><#-- 输入框 -->
                <#assign inputType=""/><#-- 输入框类型 -->
                <#assign myPropertyName="${field.propertyName}"/>
                <#assign labelPropertyName="${field.propertyName}"/>
                <#assign fieldComment="${field.comment!}"/>
                <#if field.comment!?contains("\n") >
                    <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
                </#if>
                <#if field.propertyType =="String">
                    <#assign htmlType="input"/>
                    <#if fType?index_of("TEXT") != -1>
                        <#assign inputType="textarea"/>
                    </#if>
                <#elseif field.propertyType =="LocalDate">
                  <#assign htmlType="date-picker"/>
                  <#assign inputType="date"/>
                <#elseif field.propertyType =="LocalDateTime">
                    <#assign htmlType="date-picker"/>
                    <#assign inputType="datetime"/>
                <#elseif field.propertyType =="Boolean">
                    <#assign htmlType="radio-button"/>
                <#elseif field.propertyType =="Long">
                    <#assign htmlType="input"/>
                </#if>
              <#-- 手动填写的覆盖进来 -->
                <#if field.customMap??>
                    <#if field.customMap.annotation??>
                        <#if field.propertyName?ends_with("Id")>
                            <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}.key"/>
                            <#assign labelPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
                        <#else >
                            <#assign myPropertyName="${field.propertyName}.key"/>
                        </#if>
                    </#if>
                    <#if field.customMap.info??>
                        <#if field.customMap.info.isInsert??><#assign isInsert="${field.customMap.info.isInsert}"/></#if>
                        <#if field.customMap.info.isUpdate??><#assign isUpdate="${field.customMap.info.isUpdate}"/></#if>
                        <#if field.customMap.info.htmlType??>
                            <#assign htmlType="${field.customMap.info.htmlType}"/>
                            <#if field.customMap.info.htmlType == "textarea">
                                <#assign htmlType="input"/>
                                <#assign inputType="textarea"/>
                            <#elseif field.customMap.info.htmlType?index_of('select') != -1>
                                <#assign inputType=""/>
                            <#elseif field.customMap.info.htmlType == "date-picker">
                                <#assign htmlType="date-picker"/>
                                <#assign inputType="date"/>
                            <#elseif field.customMap.info.htmlType == "datetime-picker">
                                <#assign htmlType="date-picker"/>
                                <#assign inputType="datetime"/>
                            </#if>
                        </#if>
                    </#if>
                </#if>
                <#if field.customMap.isEnum?? && field.customMap.isEnum == "1">
                  <#assign myPropertyName="${field.propertyName}.code"/>
                </#if>
                <#if isInsert =="1" || isUpdate =="1">
              <el-form-item :label="$t('table.${entity?uncap_first}.${labelPropertyName}')" prop="${labelPropertyName}">
                        <#if htmlType=="date-picker">
              <el-date-picker
                    v-model="${entity?uncap_first}.${myPropertyName}"
                    placeholder="${fieldComment}"
                    :start-placeholder="$t('table.${entity?uncap_first}.${field.propertyName}')"
                    value-format="yyyy-MM-dd<#if inputType=="datetime"> HH:mm:ss</#if>"
                    format="yyyy-MM-dd<#if inputType=="datetime"> HH:mm:ss</#if>"
                    class="filter-item date-range-item"
                    type="${inputType}"/>
                        <#elseif htmlType?index_of('radio')!=-1>
              <el-radio-group v-model="${entity?uncap_first}.${myPropertyName}" size="medium">
                                <#if myPropertyName == "status">
                <el-${htmlType} :label="true">{{ $t("common.status.valid") }}</el-${htmlType}>
                <el-${htmlType} :label="false">{{ $t("common.status.invalid") }}</el-${htmlType}>
                                <#else>
                <el-${htmlType} :label="true">{{ $t("common.yes") }}</el-${htmlType}>
                <el-${htmlType} :label="false">{{ $t("common.no") }}</el-${htmlType}>
                                </#if>
              </el-radio-group>
                        <#elseif htmlType=="switch">
              <el-switch :active-text="$t('common.yes')" :inactive-text="$t('common.no')" v-model="${entity?uncap_first}.${myPropertyName}" />
                        <#elseif htmlType?index_of('checkbox')!=-1>
              <el-checkbox-group v-model="${entity?uncap_first}.${myPropertyName}">
                <el-${htmlType} label="${entity?uncap_first}.${myPropertyName}"></el-${htmlType}>
              </el-checkbox-group>
                        <#elseif htmlType=="select">
              <el-select v-model="${entity?uncap_first}.${myPropertyName}" placeholder="${fieldComment}" style="width:100%">
                <el-option v-for="item in ${entity?uncap_first}List" :key="item.id" :label="item.name" :value="item.id"/>
              </el-select>
                        <#else >
                <el-${htmlType} type="${inputType}" v-model="${entity?uncap_first}.${myPropertyName}" placeholder="${fieldComment}"/>
                        </#if>
            </el-form-item>
                </#if>
            </#list>
              <el-form-item :label="$t('table.${entity?uncap_first}.sortValue')" prop="sortValue">
                <el-input-number :max="100" :min="0" @change="handleNumChange" v-model="${entity?uncap_first}.sortValue"/>
              </el-form-item>
            </el-form>
          </div>
        </el-card>
        <el-card class="box-card" style="margin-top: -2rem;">
          <el-row>
            <el-col :span="24" style="text-align: right">
              <el-button @click="submit" plain type="primary">
                {{${entity?uncap_first}.id === "" ? this.$t("common.add") : this.$t("common.edit") }}
              </el-button>
            </el-col>
          </el-row>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import ${entity?uncap_first}Api from "@/api/${entity}.js";

export default {
  name: "${entity}Manager",
  data() {
    return {
      label: "",
      ${entity?uncap_first}Tree: [],
      ${entity?uncap_first}: this.init${entity}(),
      rules: {

      }
    };
  },
  mounted() {
  },
  methods: {
    init${entity}() {
      return {
        id: "",
        label: "",
        sortValue: 0,
        parentId: 0,
        parentLabel: "",
        <#list table.fields as field>
          <#assign myPropertyName="${field.propertyName}"/>
          <#assign defVal="null"/>
          <#if field.propertyType == "String">
          <#assign defVal="''"/>
          <#elseif field.propertyType == "Boolean">
          <#assign defVal="true"/>
          </#if>
        <#if field.customMap?? && field.customMap.annotation??>
          <#if field.propertyName?ends_with("Id")>
          <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
          </#if>
        ${myPropertyName}: {
            key: null
        },
        <#elseif field.customMap.isEnum?? && field.customMap.isEnum == "1">
        ${field.propertyName}: {
          code: ''
        },
        <#else >
        ${myPropertyName}: ${defVal},
        </#if>
        </#list>
      };
    },
    init${entity}Tree(parentId = 0) {
      ${entity?uncap_first}Api.find({parentId: parentId}).then(response => {
        const res = response.data;
        this.${entity?uncap_first}Tree = res.data;
      });
    },
    loadTree(node, resolve) {
      ${entity?uncap_first}Api.find({parentId: node.data.id}).then(response => {
        const res = response.data;
        resolve(res.data);
      });
    },
    exportExcel() {
      this.$message({
        message: "待完善",
        type: "warning"
      });
    },
    handleNumChange(val) {
      this.${entity?uncap_first}.sortValue = val;
    },
    filterNode(value, data) {
      if (!value) return true;
      return data.label.indexOf(value) !== -1;
    },
    nodeClick(val) {
      const vm = this;
      if(val){
        this.${entity?uncap_first} = {...val};

        <#list table.fields as field>
        <#assign myPropertyName="${field.propertyName}"/>
        <#if field.customMap?? && field.customMap.annotation??>
        <#if field.propertyName?ends_with("Id")>
        <#assign myPropertyName="${field.propertyName!?substring(0,field.propertyName?index_of('Id'))}"/>
        </#if>
        if(!vm.${entity?uncap_first}['${myPropertyName}']){
          vm.${entity?uncap_first}['${myPropertyName}'] = {'key': ''};
        }
        <#elseif field.customMap.isEnum?? && field.customMap.isEnum == "1">
        if(!vm.${entity?uncap_first}['${myPropertyName}']){
          vm.${entity?uncap_first}['${myPropertyName}'] = {'code': ''};
        }
        <#else >
        </#if>
        </#list>
      }

      const parent = this.$refs.${entity?uncap_first}Tree.getNode(val.parentId);
      if (parent) {
        this.${entity?uncap_first}.parentLabel = parent.label;
      }

      this.$refs.form.clearValidate();
    },
    add() {
      this.resetForm();
      const checked = this.$refs.${entity?uncap_first}Tree.getCheckedNodes();
      if (checked.length > 1) {
        this.$message({
          message: this.$t("tips.onlyChooseOne"),
          type: "warning"
        });
      } else if (checked.length > 0) {
        this.${entity?uncap_first}.parentId = checked[0].id;
        this.${entity?uncap_first}.parentLabel = checked[0].label;
      } else {
        this.${entity?uncap_first}.parentId = 0;
        this.${entity?uncap_first}.parentLabel = "";
      }
    },
    batchDelete() {
      const checked = this.$refs.${entity?uncap_first}Tree.getCheckedKeys();
      if (checked.length === 0) {
        this.$message({
            message: this.$t("tips.noNodeSelected"),
            type: "warning"
        });
      } else {
        this.$confirm(this.$t("tips.confirmDeleteNode"), this.$t("common.tips"), {
                    confirmButtonText: this.$t("common.confirm"),
                    cancelButtonText: this.$t("common.cancel"),
                    type: "warning"
        }).then(() => {
          ${entity?uncap_first}Api.delete({ids: checked}).then(response => {
            const res = response.data;
            if (res.isSuccess) {
              this.$message({
                message: this.$t("tips.deleteSuccess"),
                type: "success"
              });
            }
            this.reset();
          });
        }).catch(() => {
          this.$refs.${entity?uncap_first}Tree.setCheckedKeys([]);
        });
      }
    },
    search() {
      this.$refs.${entity?uncap_first}Tree.filter(this.label);
    },
    reset() {
      this.init${entity}Tree();
      this.label = "";
      this.resetForm();
    },
    submit() {
      this.$refs.form.validate(valid => {
        if (valid) {
          if (this.${entity?uncap_first}.id) {
            this.update();
          } else {
            this.save();
          }
        } else {
          return false;
        }
      });
    },
    save() {
      ${entity?uncap_first}Api.save({...this.${entity?uncap_first}}).then(response => {
        const res = response.data;
        if (res.isSuccess) {
          this.$message({
            message: this.$t("tips.createSuccess"),
            type: "success"
          });
        }

        this.reset();
      });
    },
    update() {
      ${entity?uncap_first}Api.update({...this.${entity?uncap_first}}).then(response => {
        const res = response.data;
        if (res.isSuccess) {
          this.$message({
            message: this.$t("tips.updateSuccess"),
            type: "success"
          });
        }
        this.reset();
      });
    },
    resetForm() {
      this.$refs.form.clearValidate();
      this.$refs.form.resetFields();
      this.${entity?uncap_first} = this.init${entity}();
    }
  }
};
</script>
<style lang="scss" scoped>
.${entity?uncap_first} {
  margin: 10px;

  .app-container {
    margin: 0 0 10px 0 !important;
  }
}

.el-card.is-always-shadow {
  box-shadow: none;
}

.el-card {
  border-radius: 0;
  border: none;

 .el-card__header {
    padding: 10px 20px !important;
    border-bottom: 1px solid #f1f1f1 !important;
  }
}
</style>
