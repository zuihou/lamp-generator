package com.github.zuihoou.generator.model;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;
import lombok.experimental.Accessors;

/**
 * 代码生成业务字段表
 *
 * @author zuihou
 */
@Data
@Builder
@AllArgsConstructor
@ToString
@Accessors(chain = true)
public class GenTableColumn {
    public static final String YES = "1";
    public static final String NO = "0";
    private static final long serialVersionUID = 1L;
    /**
     * 归属表
     */
    private String tableName;

    /**
     * 列名称
     */
    private String name;

    /**
     * 列描述 自动计算
     */
    private String columnComment;

    /**
     * 列类型 自动计算
     */
    private String type;

    /**
     * JAVA类型 自动计算
     */
    private String propertyType;

    /**
     * JAVA字段名 自动计算
     */
    private String javaField;
    /**
     * 宽度
     */
    private String width;

    /**
     * 是否必填（1是） 为空时自动计算
     */
    private String isRequired;

    /**
     * 是否为插入字段（1是） 为空时自动计算
     */
    private String isInsert;

    /**
     * 是否编辑字段（1是） 为空时自动计算
     */
    private String isEdit;

    /**
     * 是否列表字段（1是）为空时自动计算
     */
    private String isList;

    /**
     * 是否查询字段（1是） 为空时自动计算
     */
    private String isQuery;

    /**
     * 查询方式（EQ等于、NE不等于、GT大于、LT小于、LIKE模糊、BETWEEN范围）  暂时不支持
     */
    private String queryType;

    /**
     * 显示类型（input文本框、textarea文本域、select下拉框、checkbox复选框、radio单选框、datetime日期控件） 为空时自动计算
     */
    private String htmlType;

    /**
     * 字典类型 暂时不支持
     */
    private String dictType;

    public GenTableColumn() {
    }

    public GenTableColumn(String name, String isInsert, String isEdit, String isList, String isQuery, String htmlType) {
        this.name = name;
        this.isInsert = isInsert;
        this.isEdit = isEdit;
        this.isList = isList;
        this.isQuery = isQuery;
        this.htmlType = htmlType;
    }
}
