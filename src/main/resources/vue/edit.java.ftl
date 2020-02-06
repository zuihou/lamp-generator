<template>
  <el-dialog
    :close-on-click-modal="false"
    :close-on-press-escape="true"
    :title="title"
    :type="type"
    :visible.sync="isVisible"
    :width="width"
    top="50px">
    <div class="dialog-footer" slot="footer">
      <el-button @click="isVisible = false" plain type="warning">
        {{ $t("common.cancel") }}
      </el-button>
      <el-button @click="submitForm" plain type="primary">
        {{ $t("common.confirm") }}
      </el-button>
    </div>
    <el-form :model="${entity?uncap_first}" :rules="rules" label-position="right" label-width="100px" ref="form">
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
      <#assign fieldComment="${field.comment!}"/>
      <#if field.comment!?contains("\n") >
        <#assign fieldComment="${field.comment!?substring(0,field.comment?index_of('\n'))?replace('\r\n','')?replace('\r','')?replace('\n','')?trim}"/>
      </#if>
      <#if field.propertyType =="String">
          <#assign htmlType="input"/>
          <#if fType?index_of("TEXT") != -1>
            <#assign inputType="textarea"/>
          </#if>
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
                  <#elseif field.customMap.info.htmlType == "datetime-picker">
                    <#assign htmlType="date-picker"/>
                    <#assign inputType="datetime"/>
                  </#if>
              </#if>
          </#if>
      </#if>
      <#if isInsert =="1" || isUpdate =="1">
      <el-form-item :label="$t('table.${entity?uncap_first}.${field.propertyName}')" prop="${field.propertyName}">
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
    </el-form>
  </el-dialog>
</template>
<script>
import ${entity?uncap_first}Api from "@/api/${entity}.js";

export default {
  name: "${entity}Edit",
  components: {  },
  props: {
    dialogVisible: {
      type: Boolean,
      default: false
    },
    type: {
      type: String,
      default: "add"
    }
  },
  data() {
    return {
      ${entity?uncap_first}: this.init${entity}(),
      screenWidth: 0,
      width: this.initWidth(),
      rules: {

      }
    };
  },
  computed: {
    isVisible: {
      get() {
        return this.dialogVisible;
      },
      set() {
        this.close();
        this.reset();
      }
    },
    title() {
      return this.$t("common." + this.type);
    }
  },
  watch: {},
  mounted() {
    window.onresize = () => {
      return (() => {
        this.width = this.initWidth();
      })();
    };
  },
  methods: {
    init${entity}() {
      return {
        id: "",
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
          <#else >
        ${myPropertyName}: ${defVal},
          </#if>
        </#list>
      };
    },
    initWidth() {
      this.screenWidth = document.body.clientWidth;
      if (this.screenWidth < 991) {
        return "90%";
      } else if (this.screenWidth < 1400) {
        return "45%";
      } else {
        return "800px";
      }
    },
    set${entity}(val) {
      const vm = this;
      if (val) {
        vm.${entity?uncap_first} = { ...val };
      }
    },
    close() {
      this.$emit("close");
    },
    reset() {
      // 先清除校验，再清除表单，不然有奇怪的bug
      this.$refs.form.clearValidate();
      this.$refs.form.resetFields();
      this.${entity?uncap_first} = this.init${entity}();
    },
    submitForm() {
      const vm = this;
      this.$refs.form.validate(valid => {
        if (valid) {
          vm.editSubmit();
        } else {
          return false;
        }
      });
    },
    editSubmit() {
      const vm = this;
      if (vm.type === "edit") {
          vm.update();
      } else {
          vm.save();
      }
    },
    save() {
      const vm = this;
      ${entity?uncap_first}Api.save(this.${entity?uncap_first}).then(response => {
        const res = response.data;
        if (res.isSuccess) {
          vm.isVisible = false;
          vm.$message({
            message: vm.$t("tips.createSuccess"),
            type: "success"
          });
          vm.$emit("success");
        }
      });
    },
    update() {
      ${entity?uncap_first}Api.update(this.${entity?uncap_first}).then(response => {
        const res = response.data;
        if (res.isSuccess) {
          this.isVisible = false;
          this.$message({
            message: this.$t("tips.updateSuccess"),
            type: "success"
          });
          this.$emit("success");
        }
      });
    }
  }
};
</script>
<style lang="scss" scoped></style>
