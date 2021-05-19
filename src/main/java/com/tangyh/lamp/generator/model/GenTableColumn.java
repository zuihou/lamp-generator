package com.tangyh.lamp.generator.model;


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
     * 归属表 自动计算
     */
    private String tableName;

    /**
     * 列名称 自动计算
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
     * Index页面 Table 的列宽度
     *
     * @since 2.0 支持
     */
    private String width;

    /**
     * 是否必填（1是） 为空时自动计算 暂时不支持
     */
    private String isRequired;

    /**
     * 是否为插入字段（1是） 为空时自动计算
     *
     * @since 2.0 支持
     */
    private String isInsert = YES;

    /**
     * 是否编辑字段（1是） 为空时自动计算
     *
     * @since 2.0 支持
     */
    private String isEdit = YES;

    /**
     * 是否列表字段（1是）为空时自动计算
     *
     * @since 2.0 支持
     */
    private String isList = YES;

    /**
     * 是否查询字段（1是） 为空时自动计算
     *
     * @since 2.0 支持
     */
    private String isQuery = NO;

    /**
     * 查询方式（EQ等于、NE不等于、GT大于、LT小于、LIKE模糊、BETWEEN范围）  暂时不支持
     */
    private String queryType;

    /**
     * 显示类型（input文本框、textarea文本域、select下拉框、checkbox复选框、radio单选框、datetime日期控件） 为空时自动计算
     *
     * @since 2.0 支持
     */
    private String htmlType;

    /**
     * 字典类型
     *
     * @since 2.0 支持
     */
    private String dictType;
    /**
     * 枚举类型
     *
     * @since 2.0 支持
     */
    private String enumType;

    public GenTableColumn() {
    }

    /**
     * 因为前段新增和报错共用一个页面，所以目前 isInsert 和 isEdit 必须都为0才不会显示在编辑页面
     *
     * @param name     字段名
     * @param isInsert 是否显示在新增页面 1/0 空字符串就自动计算
     * @param isEdit   是否显示在修改页面 1/0 空字符串就自动计算
     * @param isList   是否显示在分页列表 1/0 空字符串就自动计算
     * @param isQuery  是否显示在分页查询条件 1/0 空字符串就自动计算
     * @param htmlType 输入框的类型   见: HtmlType
     */
    public GenTableColumn(String name, String isInsert, String isEdit, String isList, String isQuery, String htmlType) {
        this.name = name;
        this.isInsert = isInsert;
        this.isEdit = isEdit;
        this.isList = isList;
        this.isQuery = isQuery;
        this.htmlType = htmlType;
    }

    public GenTableColumn(String isEdit, String isList, String isQuery, String htmlType) {
        this.isInsert = isEdit;
        this.isEdit = isEdit;
        this.isList = isList;
        this.isQuery = isQuery;
        this.htmlType = htmlType;
    }
    public GenTableColumn(String isEdit, String isList, String isQuery) {
        this.isInsert = isEdit;
        this.isEdit = isEdit;
        this.isList = isList;
        this.isQuery = isQuery;
    }

}
