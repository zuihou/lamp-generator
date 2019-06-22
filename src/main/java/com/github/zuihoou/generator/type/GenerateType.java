package com.github.zuihoou.generator.type;

/**
 * 生成策略
 *
 * @author tangyh
 * @date 2019/05/14
 */
public enum GenerateType {
    /**
     * 覆盖
     */
    OVERRIDE,
    /**
     * 新增
     */
    ADD,
    /**
     * 存在则忽略
     */
    IGNORE,
    ;


    public boolean eq(String val) {
        if (this.name().equals(val)) {
            return true;
        }
        return false;
    }

    public boolean eq(GenerateType val) {
        if (val == null) {
            return false;
        }
        return eq(val.name());
    }

    public boolean neq(GenerateType val) {
        return !eq(val);
    }

}
