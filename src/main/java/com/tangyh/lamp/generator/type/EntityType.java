package com.tangyh.lamp.generator.type;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * 父类实体类型
 *
 * @author zuihou
 * @date 2019/05/14
 */
@Getter
@AllArgsConstructor
public enum EntityType {
    /**
     * 只有id
     * <p>
     * "tenant_code" 字段会自动忽略
     */
    SUPER_ENTITY("com.tangyh.basic.base.entity.SuperEntity", new String[]{"id", "tenant_code", "create_time", "created_by"}),
    /**
     * 有创建人创建时间等
     * "tenant_code" 字段会自动忽略
     */
    ENTITY("com.tangyh.basic.base.entity.Entity", new String[]{"id", "tenant_code", "create_time", "created_by", "update_time", "updated_by"}),

    /**
     * 树形实体
     * "tenant_code" 字段会自动忽略
     */
    TREE_ENTITY("com.tangyh.basic.base.entity.TreeEntity", new String[]{"id", "tenant_code", "create_time", "created_by", "update_time", "updated_by", "label", "parent_id", "sort_value"}),

    /**
     * 不继承任何实体
     */
    NONE("", new String[]{""}),
    ;

    private String val;
    private String[] columns;


    public boolean eq(String val) {
        if (this.name().equals(val)) {
            return true;
        }
        return false;
    }

    public boolean eq(EntityType val) {
        if (val == null) {
            return false;
        }
        return eq(val.name());
    }

}
