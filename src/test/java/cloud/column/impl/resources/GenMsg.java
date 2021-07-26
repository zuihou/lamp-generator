package cloud.column.impl.resources;

import cloud.column.GenTableColumnService;
import top.tangyh.lamp.generator.model.GenTableColumn;
import top.tangyh.lamp.generator.type.HtmlType;

import java.util.HashMap;
import java.util.Map;

import static top.tangyh.lamp.generator.model.GenTableColumn.NO;
import static top.tangyh.lamp.generator.model.GenTableColumn.YES;

public class GenMsg implements GenTableColumnService {
    @Override
    public Map<String, Map<String, GenTableColumn>> map() {
        Map<String, Map<String, GenTableColumn>> map = new HashMap<>();
        //字段名 对应的显示方式
        Map<String, GenTableColumn> keyField = new HashMap<>();
        // edit list query
        keyField.put("biz_id", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("biz_type", new GenTableColumn(NO, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("msg_type", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_API_SELECT).setEnumType("MsgType"));
        keyField.put("title", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("content", new GenTableColumn(YES, YES, NO, HtmlType.PLUS_InputTextArea));
        keyField.put("author", new GenTableColumn(YES, YES, YES, HtmlType.PLUS_INPUT));
        keyField.put("handler_url", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("handler_params", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_INPUT));
        keyField.put("is_single_handle", new GenTableColumn(YES, NO, NO, HtmlType.PLUS_RadioButtonGroup));

        //表名
        map.put("e_msg", keyField);
        return map;
    }
}
