package cloud.column.impl.resources;

import cloud.column.GenTableColumnService;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.NO;
import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenSms implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        // edit list query
        keyField.put("template_id", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_API_SELECT));
        keyField.put("status", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("TaskStatus"));
        keyField.put("source_type", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_API_SELECT).setEnumType("SourceType"));
        keyField.put("receiver", new GenTableColumn(YES, NO, YES, HtmlType.PLUS_INPUT));
        keyField.put("topic", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("template_params", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("send_time", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_INPUT));
        keyField.put("content", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("draft", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_RadioButtonGroup));

        //表名
        map.put("e_sms_task", keyField);
        return map;
    }
}
