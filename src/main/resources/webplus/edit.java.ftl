<template>
  <BasicDrawer
    v-bind="$attrs"
    @register="registerDrawer"
    showFooter
    width="30%"
    :maskClosable="false"
    :title="t(`common.title.${r'${'}type${r'}'}`)"
    @ok="handleSubmit"
  >
    <BasicForm @register="registerForm" />
  </BasicDrawer>
</template>
<script lang="ts">
  import { defineComponent, ref, unref } from 'vue';
  import { BasicDrawer, useDrawerInner } from '/@/components/Drawer';
  import { BasicForm, useForm } from '/@/components/Form/index';
  import { useI18n } from '/@/hooks/web/useI18n';
  import { useMessage } from '/@/hooks/web/useMessage';
  import { ActionEnum } from '/@/enums/commonEnum';
  import { Api, save, update } from '/@/api/${cfg.projectPrefix}/${cfg.childPackageName}/${entity?uncap_first}';
  import { getValidateRules } from '/@/api/${cfg.projectPrefix}/common/formValidateService';
  import { customFormSchemaRules, editFormSchema } from './${entity?uncap_first}.data';

  export default defineComponent({
    name: '${entity}Edit',
    components: { BasicDrawer, BasicForm },
    emits: ['success', 'register'],
    setup(_, { emit }) {
      const { t } = useI18n();
      const type = ref(ActionEnum.ADD);
      const { createMessage } = useMessage();
      const [registerForm, { setFieldsValue, resetFields, updateSchema, validate }] = useForm({
        labelWidth: 100,
        schemas: editFormSchema,
        showActionButtonGroup: false,
        actionColOptions: {
          span: 23,
        },
      });

      const [registerDrawer, { setDrawerProps, closeDrawer }] = useDrawerInner(async (data) => {
        await resetFields();
        setDrawerProps({ confirmLoading: false });
        type.value = data?.type;

        let validateApi = Api.Save;
        if (unref(type) !== ActionEnum.ADD) {
          const record = data.record;
          await setFieldsValue({
            ...record,
          });
          validateApi = Api.Update;
        }
        if (unref(type) === ActionEnum.COPY) {
          validateApi = Api.Save;
        }

        getValidateRules(validateApi, customFormSchemaRules(type)).then(async (rules) => {
          rules && rules.length > 0 && await updateSchema(rules);
        });
      });

      async function handleSubmit() {
        try {
          const params = await validate();
          setDrawerProps({ confirmLoading: true });

          if (unref(type) === ActionEnum.EDIT) {
            await update(params);
          } else {
            params.id = null;
            await save(params);
          }
          createMessage.success(t(`common.tips.${r'${'}type.value${r'}'}Success`));
          closeDrawer();
          emit('success');
        } finally {
          setDrawerProps({ confirmLoading: false });
        }
      }

      return { t, registerDrawer, registerForm, type, handleSubmit };
    },
  });
</script>
