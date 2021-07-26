package cloud.column.impl.resources;

import cloud.column.GenTableColumnService;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.NO;
import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenAttachment implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        keyField.put("biz_id", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("biz_type", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("group_", new GenTableColumn(NO, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("path", new GenTableColumn(NO, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("url", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_InputTextArea));
        keyField.put("unique_file_name", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("original_file_name", new GenTableColumn(NO, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("content_type", new GenTableColumn(NO, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("ext", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_RadioButtonGroup));
        keyField.put("size", new GenTableColumn(NO, YES, NO, HtmlType.PLUS_RadioButtonGroup));
        keyField.put("org_id", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));

        //表名
        map.put("c_attachment", keyField);
        return map;
    }
}
