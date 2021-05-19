<template>
  <PageWrapper dense contentFullHeight fixedHeight contentClass="flex">
    <${entity}Tree class="md:w-1/2" @select="handleTreeSelect" @add="handleTreeAdd" ref="treeRef" />
    <Edit class="md:w-1/2" @success="handleEditSuccess" ref="editRef" />
  </PageWrapper>
</template>
<script lang="ts">
  import { defineComponent, ref, unref } from 'vue';
  import { PageWrapper } from '/@/components/Page';
  import { ActionEnum } from '/@/enums/commonEnum';
  import ${entity}Tree from './Tree.vue';
  import Edit from './Edit.vue';

  export default defineComponent({
    name: '${entity}Manage',
    components: { Edit, ${entity}Tree, PageWrapper },
    setup() {
      const editRef = ref<any>(null);
      const treeRef = ref<any>(null);

      // 获取编辑表单
      function getEditRef() {
        return unref(editRef);
      }
      // 获取树
      function getTreeRef() {
        return unref(treeRef);
      }

      // 编辑成功回调
      function handleEditSuccess() {
        getTreeRef().fetch();
      }

      // 选中树的节点
      function handleTreeSelect(parent = {}, record = {}) {
        getEditRef().setData({ type: ActionEnum.EDIT, parent, record });
      }

      // 点击树的新增按钮
      function handleTreeAdd(parent = {}) {
        getEditRef().setData({ type: ActionEnum.ADD, parent });
      }

      return {
        editRef,
        treeRef,
        handleEditSuccess,
        handleTreeSelect,
        handleTreeAdd,
      };
    },
  });
</script>
